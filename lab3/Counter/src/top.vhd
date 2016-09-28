-------------------------------------------------------------------------------
-- Zachary Weeden
-- counter simulation top top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk             : in std_logic; 
    reset           : in std_logic;
    --a             : in std_logic_vector(3 downto 0); --0001
    seven_seg_out   : out std_logic_vector(6 downto 0)
  ); 
end top;

architecture beh of top is

component generic_adder_beh is
  generic (
    bits    : integer := 4
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    cin     : in  std_logic;
    sum     : out std_logic_vector(bits-1 downto 0);
    cout    : out std_logic
  );
end component;  

component generic_counter is
  generic (
    max_count       : integer := 3
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    output          : out std_logic
  );  
end component;  

component seven_seg is
  generic (
    max_count       : integer := 25000000
  );
  port (
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );   
end component;  

signal sum_sig  : std_logic_vector(3 downto 0);
signal enable_sig  : std_logic;
signal adder_sig  : std_logic_vector(3 downto 0);
begin

adder: generic_adder_beh 
  port map(
    a       => "0001",
    b       => sum_sig,
    cin     => '0',
    sum     => adder_sig,
    cout    => open
  );
    
counter: generic_counter 
    port map(
      clk     => clk,
      reset     => reset,
      output     => enable_sig
    );
    
convert_to_ssd: seven_seg 
    port map(
      bcd     => sum_sig,
      seven_seg_out     => seven_seg_out
    );

process(clk,enable_sig)
begin
if (enable_sig = '1') then
    if (clk'event and clk = '1') then
        sum_sig<=adder_sig;
    else
        --no rising edge clock detected but enable wait for 50 MHz
    end if;
else
    --register not enabled - dont pass signal
end if;
end process;
end beh;
