-------------------------------------------------------------------------------
-- Dr. Kaputa
-- alias test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aliases_tb is
end aliases_tb;

architecture beh of aliases_tb is

signal word   : std_logic_vector(15 downto 0);
alias opcode  : std_logic_vector(3 downto 0) is word(15 downto 12);
alias arg1    : std_logic_vector(3 downto 0) is word(11 downto 8);
alias arg2    : std_logic_vector(3 downto 0) is word(7 downto 4);
alias arg3    : std_logic_vector(3 downto 0) is word(3 downto 0);

begin
process
  begin 
    word <= x"1234";
    wait;
  end process;
end beh;