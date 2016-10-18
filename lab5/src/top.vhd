--lab 5 test
--zachary weeden
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
  port (
    input           : in std_logic_vector(7 downto 0); -- a and b, state will determin which
    s_btn           : in std_logic; -- btn to switch state
    clk             : in std_logic;
    reset           : in std_logic;
    seven_seg_a     : out std_logic_vector(6 downto 0);
    seven_seg_b     : out std_logic_vector(6 downto 0);
    seven_seg_res   : out std_logic_vector(6 downto 0);
    s_led           : out std_logic_vector(3 downto 0) -- state indicator
  ); 
end top;

architecture beh of top is

-- components here
--component example is
--  port (
--    a               : in std_logic;
--    a_out           : out std_logic
--  ); 
--end component;  

-- internal signals here
--signal eg_1   : std_logic;
--signal eg_2     : std_logic_vector(2 downto 0);
stateReg: std_logic_vector(3 downto 0); --4 states
stateNext: std_logic_vector(3 downto 0);--4 states

begin 

component generic_add_sub is
  generic (
    bits    : integer := 3
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    flag    : in  std_logic; -- 0: add 1: sub
    c       : out std_logic_vector(bits downto 0)
  );
end component;

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
    async_in          : in std_logic_vector(2 downto 0);
    sync_out          : out std_logic_vector(2 downto 0)
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

-- component instantiations here
--example_a: example
--  port map(
--    a         => top_a,
--    a_out     => Top_a_out_int
--  );

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
    --default calues
    --led indicate default 
    stateNext<=stateReg; --prevent latch
    case stateReg is

        when input_a =>
            s_led<="0001";
            if s_btn='1' then 
                stateNext<=input_b;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when input_b =>
            s_led<="0010";
            if s_btn='1' then 
                stateNext<=disp_sum;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when disp_sum =>
            s_led<="0100";
            if s_btn='1' then 
                stateNext<=disp_diff;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when disp_diff =>
            s_led<="1000";
            if s_btn='1' then 
                stateNext<=input_a;
            elsif reset='1' then
                stateNext<=input_a;
            end if;

        when others =>
            s_led<="0000";
            stateNext<=input_a;
    end case;
end beh;
