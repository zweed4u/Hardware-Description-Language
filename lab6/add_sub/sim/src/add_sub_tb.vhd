-------------------------------------------------------------------------------
-- Dr. Kaputa
-- add sub test bench 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity add_sub_tb is
end add_sub_tb;

architecture arch of add_sub_tb is

component add_sub is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    a             : in  std_logic_vector(2 downto 0);
    b             : in  std_logic_vector(2 downto 0);
    add_btn       : in  std_logic;
    sub_btn       : in  std_logic;
    a_bcd         : out std_logic_vector(6 downto 0);
    b_bcd         : out std_logic_vector(6 downto 0);
    result_bcd    : out std_logic_vector(6 downto 0)
  );
end component add_sub;

constant NUM_BITS   : integer := 3;
signal a            : std_logic_vector(NUM_BITS - 1 downto 0) := (others => '0');
signal b            : std_logic_vector(NUM_BITS - 1 downto 0) := (others => '0');
signal c            : std_logic_vector(NUM_BITS downto 0) := (others => '0');
signal flag         : std_logic := '0';
signal add_btn      : std_logic := '0';
signal sub_btn      : std_logic := '0';

constant period     : time := 20ns;                                              
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';

begin

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

uut: add_sub 
  port map (
    clk           => clk,
    reset         => reset,
    a             => a,
    b             => b,
    add_btn       => add_btn,
    sub_btn       => sub_btn,
    a_bcd         => open,
    b_bcd         => open,
    result_bcd    => open
  );

sequential_tb : process 
  begin
    report "****************** sequential testbench start ****************";
    wait for 100 ns;   -- let all the initial conditions trickle through
    add_btn <= '1';
    for i in 0 to ((2 ** NUM_BITS) - 1) loop
      a <= std_logic_vector(unsigned(a) + 1 );
      for j in 0 to ((2 ** NUM_BITS) - 1)  loop
        b <= std_logic_vector(unsigned(b) + 1 );  
        wait for 20 ns;
      end loop;
    end loop;
    add_btn <= '0';
    report "****************** add test complete testbench stop ****************";
    
    sub_btn <= '1';
    for i in 0 to ((2 ** NUM_BITS) - 1) loop
      a <= std_logic_vector(unsigned(a) + 1 );
      for j in 0 to ((2 ** NUM_BITS) - 1)  loop
        b <= std_logic_vector(unsigned(b) + 1 );  
        wait for 20 ns;
      end loop;
    end loop;
    sub_btn <= '0';
    report "****************** sub   test complete testbench stop ****************";
    
    wait;
end process; 

end arch;