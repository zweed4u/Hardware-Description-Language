-------------------------------------------------------------------------------
-- Zachary Weeden
-- lab 4 top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
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
end top;

architecture beh of top is

component generic_add_sub is
  generic (
    bits    : integer := 3
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    flag    : in  std_logic; -- 0: add 1: sub
    c       : out std_logic_vector(bits downto 0)
  );
end component;  

component synchronizer is
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in std_logic_vector(2 downto 0);
    sync_out          : out std_logic_vector(2 downto 0)
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


component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component; 

--INTERNAL SIGNALS HERE
signal synced_add   : std_logic;
signal synced_sub   : std_logic;
signal synced_sel   : std_logic;
signal synced_a     : std_logic_vector(2 downto 0);
signal synced_b     : std_logic_vector(2 downto 0);
signal add_sub_out  : std_logic_vector(3 downto 0);

signal bcd_a   : std_logic_vector(3 downto 0);
signal bcd_b   : std_logic_vector(3 downto 0);



begin

sync_a: synchronizer
  port map(
    clk         => clk,
    reset       => reset,
    async_in    => a,
    sync_out    => synced_a
  );

sync_b: synchronizer
  port map(
    clk         => clk,
    reset       => reset,
    async_in    => b,
    sync_out    => synced_b
  );

sync_add: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => reset,
    input   => add,
    edge    => synced_add
  );

sync_sub: rising_edge_synchronizer 
  port map(
    clk     => clk,
    reset   => reset,
    input   => sub,
    edge    => synced_sub
  );

add_sub: generic_add_sub 
  port map(
    a       => synced_a,
    b       => synced_b,
    flag    => synced_sel,
    c       => add_sub_out
  );
    
convert_to_ssd_a: seven_seg 
    port map(
      bcd           => bcd_a,
      seven_seg_out => seven_seg_a
    );

convert_to_ssd_b: seven_seg 
    port map(
      bcd           => bcd_b,
      seven_seg_out => seven_seg_b
    );

convert_to_ssd_res: seven_seg 
    port map(
      bcd           => add_sub_out,
      seven_seg_out => seven_seg_res
    );

process(clk,reset)
begin
if clk'event and clk='1' then
    if reset='1' then
        synced_sel<= '0'; --defaults to addition
    else
        if synced_add = '1' then
            synced_sel <= '0';
        else 
            synced_sel <= '1';
        end if;
    end if;
end if;
bcd_a<=std_logic_vector(unsigned('0' & synced_a));
bcd_b<=std_logic_vector(unsigned('0' & synced_b));
end process;
end beh;
