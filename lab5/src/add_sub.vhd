-------------------------------------------------------------------------------
-- Dr. Kaputa
-- adder and subtractor [behavioral]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
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
end entity add_sub;

architecture beh of add_sub is

component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;

component synchronizer_3bit is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in std_logic_vector(2 downto 0);
    sync_out          : out std_logic_vector(2 downto 0)
  );
end component;

component generic_add_sub is
  generic (
    bits    : integer := 3
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    flag    : in std_logic;
    c       : out std_logic_vector(bits downto 0)
  );
end component generic_add_sub;

component seven_seg is
  port (
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end component;  

signal a_sync       : std_logic_vector(2 downto 0);
signal a_sync_bcd   : std_logic_vector(3 downto 0);
signal b_sync       : std_logic_vector(2 downto 0);
signal b_sync_bcd   : std_logic_vector(3 downto 0);
signal add_en       : std_logic;
signal sub_en       : std_logic;
signal result       : std_logic_vector(3 downto 0);
signal result_sig   : std_logic_vector(3 downto 0);
signal flag         : std_logic;

constant NUM_BITS   : integer := 3;

begin

u_a_sync: synchronizer_3bit
  port map(
    clk       => clk,
    reset     => reset,
    async_in  => a,
    sync_out  => a_sync
  );
  
u_b_sync: synchronizer_3bit
  port map(
    clk       => clk,
    reset     => reset,
    async_in  => b,
    sync_out  => b_sync
  );
  
u_add_sub: generic_add_sub  
  generic map (
    bits => NUM_BITS
  )
  port map(
    a       => a_sync,
    b       => b_sync,
    flag    => flag,
    c       => result
  );
  
u_add_btn: rising_edge_synchronizer 
  port map(
    clk        => clk,
    reset      => reset,
    input      => add_btn,
    edge       => add_en
  );
  
u_sub_btn: rising_edge_synchronizer 
  port map(
    clk        => clk,
    reset      => reset,
    input      => sub_btn,
    edge       => sub_en
  );

mux: process(reset,clk)
  begin
    if reset = '1' then
      flag <= '0';
    elsif rising_edge(clk) then
      if (add_en = '1') then   
        flag <= '0';
      elsif (sub_en = '1') then
        flag <= '1';
      end if;
    end if;
end process; 

sync_output: process(reset,clk)
  begin
    if reset = '1' then
      result_sig <= "0000";
    elsif rising_edge(clk) then
      result_sig <= result;
    end if;
end process; 

a_lcd: seven_seg 
  port map (
    bcd             => a_sync_bcd,
    seven_seg_out   => a_bcd
  );  
 
b_lcd: seven_seg 
  port map (
    bcd             => b_sync_bcd,
    seven_seg_out   => b_bcd
  );   
  
result_lcd: seven_seg 
  port map (
    bcd             => result_sig,
    seven_seg_out   => result_bcd
  );  
  
  a_sync_bcd <= '0' & a_sync;
  b_sync_bcd <= '0' & b_sync;
end beh;