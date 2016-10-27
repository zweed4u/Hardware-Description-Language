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
    sw_in           : in std_logic_vector(7 downto 0); -- a and b, state will determin which
    s_btn           : in std_logic; -- btn to switch state
    clk             : in std_logic;
    reset           : in std_logic;
    seven_seg_hun   : out std_logic_vector(6 downto 0);
    seven_seg_ten   : out std_logic_vector(6 downto 0);
    seven_seg_one   : out std_logic_vector(6 downto 0);
    s_led           : out std_logic_vector(3 downto 0) -- state indicator
  ); 
end component;

--INTERNAL SIGNALS HERE - FIX THESE
constant SEQUENTIAL_FLAG    : boolean := false;
constant NUM_BITS           : integer := 3;
signal output               : std_logic;
constant period             : time := 20ns;                                              
signal clk                  : std_logic := '0';
signal reset                : std_logic := '1';
signal sw_in			    : std_logic_vector(7 downto 0):= (others => '0');
signal s_btn			    : std_logic;
signal seven_seg_hun	    : std_logic_vector(6 downto 0);
signal seven_seg_ten	    : std_logic_vector(6 downto 0);
signal seven_seg_one        : std_logic_vector(6 downto 0);
signal s_led        		: std_logic_vector(3 downto 0);

begin

uut: top
  port map(        
    sw_in               => sw_in,
    s_btn               => s_btn,
    clk                 => clk,
    reset               => reset,
    seven_seg_hun       => seven_seg_hun,
    seven_seg_ten       => seven_seg_ten,
    seven_seg_one       => seven_seg_one,
    s_led               => s_led 
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

concurrent_stimuli: if not SEQUENTIAL_FLAG generate
  s_btn<='0';

  --input 5 for A
  sw_in <= "00000101" after 500 ns;
  s_btn <= '1' after 500 ns; -- lock A in - check SSD  - need to be toggled? (A 5)
  --
  ----input 2 for B
  --sw_in <= "00000010" after 80 ns;
  --s_btn <= '1'; -- lock B in - check SSD  - need to be toggled? (B 2)
  --
  --
  --s_btn <= '1' after 120 ns; -- check SSD - need to ne toggled? (sum 7)
  --
  --s_btn <= '1' after 160 ns; -- check SSD - need to ne toggled? (diff 3)
  --
  --
  ----input 2 for A
  --sw_in <= "00000010" after 200 ns;
  --s_btn <= '1'; -- lock A in - check SSD  - need to be toggled? (A 2)
  --
  ----input 5 for B
  --sw_in <= "00000101" after 240 ns;
  --s_btn <= '1'; -- lock B in - check SSD  - need to be toggled? (B 5)
  --
  --
  --s_btn <= '1' after 280 ns; -- check SSD - need to ne toggled? (sum 7)
  --
  --s_btn <= '1' after 320 ns; -- check SSD - need to ne toggled? (diff 509)
  --
  --
  ----input 200 for A
  --sw_in <= "11001000" after 360 ns;
  --s_btn <= '1'; -- lock A in - check SSD  - need to be toggled? (A 200)
  --
  ----input 100 for B
  --sw_in <= "01100100" after 400 ns;
  --s_btn <= '1'; -- lock B in - check SSD  - need to be toggled? (B 100)
  --
  --
  --s_btn <= '1' after 440 ns; -- check SSD - need to ne toggled? (sum 300)
  --
  --s_btn <= '1' after 480 ns; -- check SSD - need to ne toggled? (diff 100)
  --
  --
  ----input 100 for A
  --sw_in <= "01100100" after 520 ns;
  --s_btn <= '1'; -- lock A in - check SSD  - need to be toggled? (A 100)
  --
  ----input 200 for B
  --sw_in <= "11001000" after 560 ns;
  --s_btn <= '1'; -- lock B in - check SSD  - need to be toggled? (B 200)
  --
  --
  --s_btn <= '1' after 600 ns; -- check SSD - need to ne toggled? (sum 300)
  --
  --s_btn <= '1' after 640 ns; -- check SSD - need to ne toggled? (diff 412)

end generate concurrent_stimuli;



end arch;
