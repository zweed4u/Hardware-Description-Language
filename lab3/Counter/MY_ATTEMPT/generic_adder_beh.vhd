-------------------------------------------------------------------------------
-- Dr. Kaputa
-- generic adder [behavioral]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_beh is
  generic (
    bits    : integer := 4
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    sum     : out std_logic_vector(bits-1 downto 0)
  );
end entity generic_adder_beh;

architecture beh of generic_adder_beh is
signal sum_temp   : std_logic_vector(bits downto 0);

begin
  sum_temp  <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
  sum       <= sum_temp(bits-1 downto 0);
end beh;