-------------------------------------------------------------------------------
-- Dr. Kaputa
-- seven segment test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arch of top_tb is

component top is
  port (
    a               : in std_logic_vector(2 downto 0);
    b               : in std_logic_vector(2 downto 0);
    add             : in std_logic;
    sub             : in std_logic; 
    clk             : in std_logic;
    reset           : in std_logic;
    seven_seg_a     : out std_logic_vector(6 downto 0);
    seven_seg_b     : out std_logic_vector(6 downto 0);
    seven_seg_res   : out std_logic_vector(6 downto 0)
  );
end component; 

signal output       : std_logic;
constant period     : time := 20ns;                                              
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';
signal a			: std_logic_vector(2 downto 0);
signal b			: std_logic_vector(2 downto 0);
signal add			: std_logic;
signal sub			: std_logic;
signal seven_seg_a	: std_logic_vector(6 downto 0);
signal seven_seg_b	: std_logic_vector(6 downto 0);
signal seven_seg_res: std_logic_vector(6 downto 0);

begin

uut: top
  port map(        
    a               => a,
    b               => b,
    add             => add,
    sub             => sub, 
    clk             => clk,
    reset           => reset,
    seven_seg_a     => seven_seg_a,
    seven_seg_b     => seven_seg_b,
    seven_seg_res   => seven_seg_res
  );

  
-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '0';
    wait;
end process; 

-- debug process
debug: process
  begin
    wait for 100 ns;
    add <= '0';
    sub <= '1';
	a<="010";
	b<="010";
    wait;
end process; 


end arch;
