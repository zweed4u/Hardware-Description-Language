-------------------------------------------------------------------------------
-- Dr. Kaputa
-- sample[behavioral]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample is
  port (
    clk           : in  std_logic;
    a             : in  std_logic;
    b             : in  std_logic;
    c             : out std_logic;
    d             : out std_logic
  );
end entity sample;

architecture beh of sample is

signal sig        : std_logic;

begin

process(clk)
  begin
    if rising_edge(clk) then
      sig <= a or b;
      c <= sig;
    end if;
end process; 

d <= a and sig;
end beh;