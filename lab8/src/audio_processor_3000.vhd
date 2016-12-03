-- Dr. Kaputa
-- Lab 10: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_processor_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    audio_in            : in std_logic_vector(15 downto 0);
    led                 : out std_logic_vector(9 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end audio_processor_3000;

architecture beh of audio_processor_3000 is

signal data_address  : std_logic_vector(15 downto 0);

begin
  -- feedthrough
  process(clk,reset)
  begin 
    if (reset = '1') then 
      audio_out <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (sync = '1') then    
        audio_out <= audio_in;
      end if;
    end if;
  end process;
  led <= "1010101010";
end beh;