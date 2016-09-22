-------------------------------------------------------------------------------
-- Dr. Kaputa
-- seven_seg top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk             : in std_logic; 
    reset           : in std_logic;
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  ); 
end top;

architecture beh of top is

component seven_seg is
  generic (
    max_count       : integer := 25000000
  );
  port (
    clk             : in std_logic; 
    reset           : in std_logic;
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );   
end component;  

begin

uut: seven_seg  
  generic map (
    max_count => 50000000
  )
  port map(
    clk       => clk,
    reset     => reset,
    bcd    => bcd,
    seven_seg_out => seven_seg_out
  );
end beh;