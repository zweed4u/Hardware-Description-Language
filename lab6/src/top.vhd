--lab 6 
--zachary weeden

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
    led             : out std_logic_vector(4 downto 0) -- state indicator
  ); 
end top;

architecture beh of top is

component seven_seg is
  generic (
    max_count       : integer := 25000000
  );
  port (
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );
end component; 


component memory is
  generic (addr_width : integer := 2;
           data_width : integer := 4);
  port (
    clk               : in std_logic;
    we                : in std_logic;
    addr              : in std_logic_vector(addr_width - 1 downto 0);
    din               : in std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end component; 


component synchronizer is
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in std_logic_vector(7 downto 0);
    sync_out          : out std_logic_vector(7 downto 0)
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

--INTERNAL SIGNALS
--examples!!!
--NEED TO BE EDITTED AND INCLUDE SAVE SIGNAL FOR READ_R CASE WHICH PULLS FROM THE MEM W/O ALU
--NEED TO BE EDITTED AND INCLUDE SAVE SIGNAL FOR READ_R CASE WHICH PULLS FROM THE MEM W/O ALU
--NEED TO BE EDITTED AND INCLUDE SAVE SIGNAL FOR READ_R CASE WHICH PULLS FROM THE MEM W/O ALU
--NEED TO BE EDITTED AND INCLUDE SAVE SIGNAL FOR READ_R CASE WHICH PULLS FROM THE MEM W/O ALU
--NEED TO BE EDITTED AND INCLUDE SAVE SIGNAL FOR READ_R CASE WHICH PULLS FROM THE MEM W/O ALU
constant read_w         : std_logic_vector(3 downto 0) :="00001";
constant read_r         : std_logic_vector(3 downto 0) :="00010";
constant write_r        : std_logic_vector(3 downto 0) :="00100";
constant write_w_no_op  : std_logic_vector(3 downto 0) :="01000"; -- this is synonymous with 'write_w_wait'
constant write_w        : std_logic_vector(3 downto 0) :="10000";

signal stateReg     : std_logic_vector(4 downto 0); --5 states
signal stateNext    : std_logic_vector(4 downto 0); --5 states
--
--PROGRESS ON INTERNAL SIGNAL DECLARATIONS FROM DIAGRAM
--
signal synced_sw    : std_logic_vector(7 downto 0);
signal synced_op    : std_logic_vector(2 downto 0);

signal synced_mr      : std_logic;
signal synced_ms      : std_logic;
signal synced_execute : std_logic;

--COMPONENT INSTANTIATIONS
begin
sync_switches: synchronizer 
  port map(
    clk         => clk,
    reset       => not reset_n,
    async_in    => sw_in, 
    sync_out    => synced_sw
  );
  
begin
sync_op: synchronizer 
  port map(
    clk         => clk,
    reset       => not reset_n,
    async_in    => sw_in, 
    sync_out    => synced_op
  );

sync_mr: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => not reset_n,
    input   => mr,
    edge    => synced_mr
  );
  
sync_ms: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => not reset_n,
    input   => ms,
    edge    => synced_ms
  );

sync_execute: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => not reset_n,
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
      dout => alu_out
    );



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

--NEEDS TO BE EDITTED FROM HERE DOWN
--NEEDS TO BE EDITTED FROM HERE DOWN  
--NEEDS TO BE EDITTED FROM HERE DOWN  
--NEEDS TO BE EDITTED FROM HERE DOWN  
--NEEDS TO BE EDITTED FROM HERE DOWN  
--NEEDS TO BE EDITTED FROM HERE DOWN  
--NEEDS TO BE EDITTED FROM HERE DOWN  
procStateReg: process(reset, clk)
begin
    if (reset = '1') then
        stateReg<=input_a; --state
    elsif (clk'event and clk ='1') then
        stateReg<=stateNext;
    end if;
end process;

procStateNext: process(stateReg,clk,reset,synced_button)
begin
    stateNext<=stateReg; --prevent latch
    case stateReg is
        when input_a =>
            s_led<="0001";
            retain_a<=sw_in;
            preDD<=std_logic_vector(unsigned("0000" & sw_in));
            if synced_button='1' then 
                stateNext<=input_b;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when input_b =>
            s_led<="0010";
            retain_b<=sw_in;
            preDD<=std_logic_vector(unsigned("0000" & sw_in));
            if synced_button='1' then 
                stateNext<=disp_sum;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when disp_sum =>
            s_led<="0100";
            postOp<=std_logic_vector(unsigned('0' & retain_a) + unsigned('0' & retain_b));
            preDD<=std_logic_vector(unsigned("000" & postOp));
            if synced_button='1' then 
                stateNext<=disp_diff;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when disp_diff =>
            s_led<="1000";
            postOp<=std_logic_vector(unsigned('0' & retain_a) - unsigned('0' & retain_b)); 
            preDD<=std_logic_vector(unsigned("000" & postOp)); 
            if synced_button='1' then 
                stateNext<=input_a;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when others =>
            --shouldnt hit this case
            s_led<="0000";
            stateNext<=input_a;
    end case;
    end process;
end beh;