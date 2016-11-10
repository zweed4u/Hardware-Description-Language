-------------------------------------------------------------------------------
-- Dr. Kaputa
-- fsmd test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      -- gives you the std_logic type

entity fsmd_tb is 
end fsmd_tb;

architecture beh of fsmd_tb is


component fsmd is 
  port (
    clk                 : in std_logic;
    reset               : in std_logic;
    button_press        : in std_logic;
    a                   : in std_logic_vector(1 downto 0);
    b                   : in std_logic_vector(1 downto 0);
    result              : out std_logic_vector(1 downto 0)
  );
end component;

constant period         : time := 20ns;                                              
signal clk              : std_logic := '0';
signal reset            : std_logic := '1';
signal a                : std_logic_vector(1 downto 0) := "10";
signal b                : std_logic_vector(1 downto 0) := "01";
signal button_press     : std_logic := '0';

begin 
uut: fsmd 
  port map(
    clk                 => clk,
    reset               => reset,
    button_press        => button_press,
    a                   => a,
    b                   => b,
    result              => open
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
    
main: process 
  begin
    assert false report "****************** TB Start ****************" severity note;
    wait for 100 ns;     
    button_press <= '1';
    wait for 20 ns;
    button_press <= '0';
    wait for 100 ns;
    button_press <= '1';
    wait for 20 ns;
    button_press <= '0';
    wait for 100 ns;     
    a <= "01";
    b <= "01";
    button_press <= '1';
    wait for 20 ns;
    button_press <= '0';
    wait for 100 ns;
    button_press <= '1';
    wait for 20 ns;
    button_press <= '0';
    wait;
  end process;  
end beh;