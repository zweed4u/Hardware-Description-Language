--lab 6 - check reset_n polarity/logic
--zachary weeden
--QUESTIONS 
--Length of vectors eg. dout/save 
--Signal coming from fsm register to datapath
--to_mem assignment in each state? 
--TWO STATEMACHINES? HOW TO IMPLEMENT OP CODE 
--CLOCK CYCLE ON GOING BACK TO IDLE ON MS OR MR
--         || we || add
--write_w  ||  1 || 00 working register
--read_w   ||  0 || 00 working register
--write_s  ||  1 || 01 save register
--read_s   ||  0 || 01 save register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    switch          : in std_logic_vector(7 downto 0);
    op              : in std_logic_vector(1 downto 0); 
    clk             : in std_logic;
    reset_n         : in std_logic;
    mr              : in std_logic;
    ms              : in std_logic;
    execute         : in std_logic;
    seven_seg_hun   : out std_logic_vector(6 downto 0);
    seven_seg_ten   : out std_logic_vector(6 downto 0);
    seven_seg_one   : out std_logic_vector(6 downto 0);
    led             : out std_logic_vector(4 downto 0)
  ); 
end top;

architecture beh of top is

component seven_seg is
  generic (
        max_count       : integer := 25000000
  );
  port (
    bcd               : in std_logic_vector(3 downto 0);
    seven_seg_out     : out std_logic_vector(6 downto 0)
  );
end component; 


component memory is
  generic (addr_width : integer := 4; 
           data_width : integer := 8);
  port (
    clk               : in std_logic;
    we                : in std_logic;
    addr              : in std_logic_vector(addr_width - 1 downto 0);
    din               : in std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end component; 


component synchronizer8 is
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in std_logic_vector(7 downto 0);
    sync_out          : out std_logic_vector(7 downto 0)
  ); 
end component;

component synchronizer2 is
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in std_logic_vector(1 downto 0);
    sync_out          : out std_logic_vector(1 downto 0)
  ); 
end component;

component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;

component alu is
  port (
    clk        :in std_logic;
    reset      :in std_logic;
    a          :in std_logic_vector(7 downto 0);
    b          :in std_logic_vector(7 downto 0);
    op         :in std_logic_vector(1 downto 0);
    result     :out std_logic_vector(7 downto 0)
  );
end component;

--INTERNAL SIGNALS
--States
constant read_w          : std_logic_vector(4 downto 0) :="00001";
constant read_r          : std_logic_vector(4 downto 0) :="00010";
constant write_r         : std_logic_vector(4 downto 0) :="00100";
constant write_w_no_op   : std_logic_vector(4 downto 0) :="01000"; -- this is synonymous with 'write_w_wait'
constant write_w         : std_logic_vector(4 downto 0) :="10000";

signal stateReg          : std_logic_vector(4 downto 0);
signal stateNext         : std_logic_vector(4 downto 0);

signal synced_sw         : std_logic_vector(7 downto 0);
signal synced_op         : std_logic_vector(1 downto 0);

signal synced_mr         : std_logic;
signal synced_ms         : std_logic;
signal synced_execute    : std_logic;

signal save              : std_logic_vector(7 downto 0);
signal result_sig        : std_logic_vector(7 downto 0);

signal to_mem            : std_logic_vector(7 downto 0);

signal preDD             : std_logic_vector(11 downto 0);
signal ones              : std_logic_vector(3 downto 0);
signal tens              : std_logic_vector(3 downto 0);
signal hundreds          : std_logic_vector(3 downto 0);

signal output_logic_we   : std_logic;
signal output_logic_addr : std_logic_vector(3 downto 0);

--COMPONENT INSTANTIATIONS
begin
sync_switches: synchronizer8 
  port map(
    clk         => clk,
    reset       => reset_n,
    async_in    => switch, 
    sync_out    => synced_sw
  );
  
sync_op: synchronizer2 
  port map(
    clk         => clk,
    reset       => reset_n,
    async_in    => op, 
    sync_out    => synced_op
  );

alu_comp: alu 
  port map(
    clk         => clk,
    reset       => reset_n,
    a           => save, 
    b           => synced_sw,
    op          => synced_op,
    result      => result_sig
  );
  
sync_mr: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => reset_n,
    input   => mr,
    edge    => synced_mr
  );
  
sync_ms: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => reset_n,
    input   => ms,
    edge    => synced_ms
  );

sync_execute: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => reset_n,
    input   => execute,
    edge    => synced_execute
  );

convert_to_ssd_a: seven_seg 
    port map(
      bcd           => hundreds, --hundreds from dd
      seven_seg_out => seven_seg_hun
    );

convert_to_ssd_b: seven_seg 
    port map(
      bcd           => tens, --tens from dd
      seven_seg_out => seven_seg_ten
    );

convert_to_ssd_c: seven_seg 
    port map(
      bcd           => ones, --ones from dd
      seven_seg_out => seven_seg_one
    );

comp_memory: memory 
    port map(
      clk  => clk,
      we   => output_logic_we,
      addr => output_logic_addr,
      din  => to_mem,
      dout => save
    );

--state register
process(reset_n, clk) --SR 
begin
    if (reset_n = '0') then
        stateReg <= read_w; --state
    elsif (clk'event and clk ='1') then
        stateReg <= stateNext;
    end if;
end process;

--sensitivity list Next State Logic
process(stateReg,reset_n,synced_execute,synced_ms,synced_mr) --NSL
begin
    if reset_n = '0' then 
        stateNext <= read_w;
    else 
        stateNext <= stateReg; --prevent latch
        case stateReg is
            when read_w =>
                led <= "00001";
                output_logic_we <= '0';
                output_logic_addr <= "0000";
                if (synced_execute='1') then
                    stateNext <= write_w_no_op;
                elsif (synced_ms='1') then
                    stateNext <= write_r;
                elsif (synced_mr='1') then
					--preparing memory for mr (read_r state)
					output_logic_we <= '0';
					output_logic_addr <= "0001";
                    stateNext <= read_r;
                else 
                    stateNext <= read_w;
                end if;

            when read_r => --same as read_s
                led <= "00010";
				output_logic_we <= '0';
				output_logic_addr <= "0001";
                if (synced_execute='1') then
                    stateNext <= write_w_no_op;
                else
                    stateNext <= read_w;
                end if;

            when write_r => --same as write_s
                led <= "00100";
                output_logic_we <= '1';
                output_logic_addr <= "0001";
                stateNext <= read_w;

            when write_w_no_op =>
                led <= "01000";
				output_logic_we <= '1';
                output_logic_addr <= "0000";
                stateNext <= write_w;

            when write_w =>
                led <= "10000";
                output_logic_we <= '1';
                output_logic_addr <= "0000";
                stateNext <= read_w;

            when others =>
                --shouldnt hit this case
                led <= "00000";
                stateNext <= read_w;
        end case;
    end if;
end process;

-- routing [asynchronous]
process(switch,reset_n,stateReg,clk)
begin
    if (clk'event and clk ='1') then
        if (stateReg=write_w_no_op) then
            to_mem <= result_sig;
        elsif (stateReg=read_r) then
            to_mem <= save;
        end if;
    end if;
    preDD <= std_logic_vector(unsigned("0000" & to_mem));
end process;


--DOUBLE DABBLE PROCESS - takes 8 bit number and parses into hundreds, tens,and ones
bcd1: process(preDD)
  -- temporary variable
  variable temp : STD_LOGIC_VECTOR (11 downto 0);
  
  -- variable to store the output BCD number
  -- organized as follows
  -- thousands = bcd(15 downto 12)
  -- hundreds = bcd(11 downto 8)
  -- tens = bcd(7 downto 4)
  -- units = bcd(3 downto 0)
  variable bcd : UNSIGNED (15 downto 0) := (others => '0');

  -- by
  -- https://en.wikipedia.org/wiki/Double_dabble
  
  begin
    -- zero the bcd variable
    bcd := (others => '0');
    
    -- read input into temp variable
    temp(11 downto 0) := preDD;
    
    -- cycle 12 times as we have 12 input bits
    -- this could be optimized, we dont need to check and add 3 for the 
    -- first 3 iterations as the number can never be >4
    for i in 0 to 11 loop
      if bcd(3 downto 0) > 4 then 
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      
      if bcd(7 downto 4) > 4 then 
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
    
      if bcd(11 downto 8) > 4 then  
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;

      -- thousands can't be >4 for a 12-bit input number
      -- so don't need to do anything to upper 4 bits of bcd
    
      -- shift bcd left by 1 bit, copy MSB of temp into LSB of bcd
      bcd := bcd(14 downto 0) & temp(11);
    
      -- shift temp left by 1 bit
      temp := temp(10 downto 0) & '0';
    
    end loop;
 
    -- set outputs
    ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));
    tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
    hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));
    --thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
  end process bcd1;

end beh;