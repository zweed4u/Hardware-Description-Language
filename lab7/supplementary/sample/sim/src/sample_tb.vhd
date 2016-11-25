-------------------------------------------------------------------------------
-- Dr. Kaputa
-- sample test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_tb is
end sample_tb;

architecture arch of sample_tb is

component sample is
  port (
    clk           : in  std_logic;
    a             : in  std_logic;
    b             : in  std_logic;
    c             : out std_logic;
    d             : out std_logic
  );
end component sample;

constant period     : time := 20ns;                                              
signal clk          : std_logic := '0';
signal a            : std_logic := '0';
signal b            : std_logic := '0';

begin

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
a <= not a after 50 ns;
b <= not b after 90 ns;
 
uut: sample 
  port map (
    clk      => clk,
    a        => a,
    b        => b,
    c        => open,
    d        => open
  );
end arch;