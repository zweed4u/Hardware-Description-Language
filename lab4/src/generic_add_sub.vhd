-------------------------------------------------------------------------------
-- Dr. Kaputa
-- generic adder [behavioral]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_add_sub is
  generic (
    bits    : integer := 3
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    flag    : in  std_logic; -- 0: add 1: sub
    c       : out std_logic_vector(bits downto 0)
  );
end entity generic_add_sub;
 
architecture beh of generic_add_sub is
 
signal add_sig : std_logic_vector(bits downto 0);
signal sub_sig : std_logic_vector(bits downto 0);
 
begin
  add_sig  <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
  sub_sig  <= std_logic_vector(unsigned('0' & a) - unsigned('0' & b));
 
  c <= add_sig when flag = '0' else sub_sig;
end beh;
