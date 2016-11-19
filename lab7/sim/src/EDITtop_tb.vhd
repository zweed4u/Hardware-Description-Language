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
    switch          : in std_logic_vector(7 downto 0);
    op              : in std_logic_vector(1 downto 0); 
    clk             : in std_logic;
    reset_n         : in std_logic;
    mr              : in std_logic;
    ms              : in std_logic;
    execute         : in std_logic;
    seven_seg_hun   : out std_logic_vector(6 downto 0);
    seven_seg_ten   : out std_logic_vector(6 downto 0);
    seven_seg_one   : out std_logic_vector(6 downto 0);
    led             : out std_logic_vector(4 downto 0) -- state indicator
  );
end component; 
constant SEQUENTIAL_FLAG   : boolean := true;
constant NUM_BITS          : integer := 3;
signal output       : std_logic;
constant period     : time := 20ns;                                              
signal clk          : std_logic := '0';
signal reset_n        : std_logic := '0';
signal switch			: std_logic_vector(7 downto 0):= (others => '0');
signal op			: std_logic_vector(1 downto 0):= (others => '0');
signal mr			: std_logic := '0';
signal ms			: std_logic := '0';
signal execute			: std_logic := '0';
signal seven_seg_hun: std_logic_vector(6 downto 0);
signal seven_seg_ten: std_logic_vector(6 downto 0);
signal seven_seg_one: std_logic_vector(6 downto 0);
signal led: std_logic_vector(4 downto 0);

begin

uut: top
  port map(        
    switch          => switch,       
    op              => op,           
    clk             => clk,          
    reset_n         => reset_n,      
    mr              => mr,           
    ms              => ms,           
    execute         => execute,      
    seven_seg_hun   => seven_seg_hun,
    seven_seg_ten   => seven_seg_ten,
    seven_seg_one   => seven_seg_one,
    led             => led  
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
    reset_n <= '1';
    wait;
end process; 



sequential_stimuli: if SEQUENTIAL_FLAG generate
  sequential_tb : process 
    begin
    wait for 2 * period;
	op<="00";--add
    switch <= "00000100"; --4
    wait for 500 ns;
    for k in 0 to 1 loop
        execute<=not(execute);
        wait for 50 ns;
    end loop;
	--4 on ssd
	
	
    wait for 500 ns;
    wait for 2 * period;
	op<="10";--multiply
    switch <= "00001000"; --8
    wait for 500 ns;
    for k in 0 to 1 loop
        execute<=not(execute);
        wait for 50 ns;
    end loop;
	--32 on ssd
	
	--store ms
	wait for 500 ns;
    wait for 2 * period;
	for k in 0 to 1 loop
        ms<=not(ms);
        wait for 50 ns;
    end loop;
	
	
	
	wait for 500 ns;
    wait for 2 * period;
	op<="01";--subtract
    switch <= "00001000"; --8
    wait for 500 ns;
    for k in 0 to 1 loop
        execute<=not(execute);
        wait for 50 ns;
    end loop;
	--24 on ssd
	
	wait for 500 ns;
    wait for 2 * period;
	op<="11";--divide
    switch <= "00000010"; --2
    wait for 500 ns;
    for k in 0 to 1 loop
        execute<=not(execute);
        wait for 50 ns;
    end loop;
	--12 on ssd
	
	
	--mem recall
	wait for 500 ns;
    wait for 2 * period;
	for k in 0 to 1 loop
        mr<=not(mr);
        wait for 50 ns;
    end loop;
	--32 on ssd
	
	
	wait for 500 ns;
    wait for 2 * period;
	op<="11";--divide
    switch <= "00000010"; --2
    wait for 500 ns;
    for k in 0 to 1 loop
        execute<=not(execute);
        wait for 50 ns;
    end loop;
	--16 on ssd
end process;
end generate sequential_stimuli;
end arch;
