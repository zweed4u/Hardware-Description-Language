--lab 5 test 
--zachary weeden
--@TODO worry about prepended 0 signals and their locations within the top level view.
--Arithmetic and state logic 
--TB with listed cases and TCL
--QUESTIONS:
--DD process in each state?
--bit guard and their placement within the top level?
--internal signal mapping, assignment and declaration /in sensitivity list
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
  port (
    sw_in           : in std_logic_vector(7 downto 0); -- a and b, state will determin which
    s_btn           : in std_logic; -- btn to switch state
    clk             : in std_logic;
    reset           : in std_logic;
    seven_seg_hun   : out std_logic_vector(6 downto 0);
    seven_seg_ten   : out std_logic_vector(6 downto 0);
    seven_seg_one   : out std_logic_vector(6 downto 0);
    s_led           : out std_logic_vector(3 downto 0) -- state indicator
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
signal stateReg     : std_logic_vector(3 downto 0); --4 states
signal stateNext    : std_logic_vector(3 downto 0); --4 states

signal synced_sw    : std_logic_vector(7 downto 0);
signal synced_button: std_logic;

signal retain_a     : std_logic_vector(7 downto 0);
signal retain_b     : std_logic_vector(7 downto 0);
signal preDD        : std_logic_vector(11 downto 0);

signal ones			: std_logic_vector(3 downto 0);
signal tens			: std_logic_vector(3 downto 0);
signal hundreds		: std_logic_vector(3 downto 0);

--COMPONENT INSTANTIATIONS
begin
sync_a: synchronizer -- adjust component to support 8 bits!
  port map(
    clk         => clk,
    reset       => reset,
    async_in    => sw_in, --8
    sync_out    => synced_sw --8
  );

sync_btn: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => reset,
    input   => s_btn,
    edge    => synced_button
  );
  
  
convert_to_ssd_a: seven_seg 
    port map(
      bcd           => sig_hundred, --hundreds from dd
      seven_seg_out => seven_seg_hun
    );

convert_to_ssd_b: seven_seg 
    port map(
      bcd           => sig_ten, --tens from dd
      seven_seg_out => seven_seg_ten
    );

convert_to_ssd_c: seven_seg 
    port map(
      bcd           => sig_one, --ones from dd
      seven_seg_out => seven_seg_one
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


procStateReg: process(reset, clk)
begin
    if (reset = '1') then
        stateReg<=input_a; --state
    elsif (clk'event and clk ='1') then
        stateReg<=stateNext;
    end if;
end process;


procStateNext: process(stateReg,reset,s_btn)
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
            preDD<=std_logic_vector(unsigned("0000" & retain_a) + unsigned("0000" & retain_b));
            if synced_button='1' then 
                stateNext<=disp_diff;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when disp_diff =>
            s_led<="1000";
            preDD<=std_logic_vector(unsigned("0000" & retain_a) - unsigned("0000" & retain_b));
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