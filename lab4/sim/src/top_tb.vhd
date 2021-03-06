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
constant SEQUENTIAL_FLAG   : boolean := true;
constant NUM_BITS          : integer := 3;
signal output       : std_logic;
constant period     : time := 20ns;                                              
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';
signal a			: std_logic_vector(2 downto 0):= (others => '0');
signal b			: std_logic_vector(2 downto 0):= (others => '0');
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

seq_stim: if SEQUENTIAL_FLAG generate
seq : process
	begin
	sub <= '0';
    add <= '0';
	wait for 2 * period;
	wait for 50 ns;
	
      report "****************** sequential testbench start ****************";
      wait for 10 ns;   -- let all the initial conditions trickle through
      for logic in 0 to 1 loop --half add half sub
        --add<=not(add);
		wait for 50 ns;
        add<=not(add);
		wait for 50 ns;
		a<="000";
          for i in 0 to ((2 ** NUM_BITS) - 1) loop
			b<="000";
			wait for 50 ns;
            for j in 0 to ((2 ** NUM_BITS) - 1)  loop
              b <= std_logic_vector(unsigned(b) + 1 );
              wait for 50 ns;
            end loop;
			a <= std_logic_vector(unsigned(a) + 1 );
          end loop;
		sub<=not(sub);
      end loop;
      report "****************** sequential testbench stop ****************";
      wait;
  end process; 
end generate seq_stim;	


end arch;
