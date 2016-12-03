library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity top is
  port ( 
    CLOCK_50      : in std_logic;
    CLOCK2_50     : in std_logic;
    AUD_DACLRCK   : in std_logic;
    AUD_ADCLRCK   : in std_logic;
    AUD_BCLK      : in std_logic; 
    AUD_ADCDAT    : in std_logic;
    KEY           : in std_logic_vector(0 DOWNTO 0);
    FPGA_I2C_SDAT : inout std_logic;
    FPGA_I2C_SCLK : out std_logic; 
    AUD_DACDAT    : out std_logic; 
    AUD_XCK       : out std_logic
  );
end top;

architecture beh OF top IS
  component clock_generator
    port( 
      CLOCK_27 : in std_logic;
      reset    : in std_logic;
      AUD_XCK  : out std_logic
    );
  end component;
  
  component audio_and_video_config
    port( 
      CLOCK_50 : in std_logic;
      reset    : in std_logic;
      I2C_SDAT : INOUT std_logic;
      I2C_SCLK : out std_logic
    );
  end component;   
  
  component audio_codec
    port(
      CLOCK_50        : in std_logic;
      reset           : in std_logic;
      read_s          : in std_logic;
      write_s         : in std_logic;
      writedata_left  : in std_logic_vector(23 DOWNTO 0); 
      writedata_right : in std_logic_vector(23 DOWNTO 0);                 
      AUD_ADCDAT      : in std_logic;
      AUD_BCLK        : in std_logic;
      AUD_ADCLRCK     : in std_logic;
      AUD_DACLRCK     : in std_logic;
      read_ready      : out std_logic; 
      write_ready     : out std_logic;
      readdata_left   : out std_logic_vector(23 DOWNTO 0);
      readdata_right  : out std_logic_vector(23 DOWNTO 0);                
      AUD_DACDAT      : out std_logic
    );
  end component;
  
  signal read_ready       : std_logic;
  signal write_ready      : std_logic;
  signal read_s           : std_logic;
  signal write_s          : std_logic;
  signal readdata_left    : std_logic_vector(23 DOWNTO 0);
  signal readdata_right   : std_logic_vector(23 DOWNTO 0);            
  signal writedata_left   : std_logic_vector(23 DOWNTO 0);
  signal writedata_right  : std_logic_vector(23 DOWNTO 0);             
  signal reset            : std_logic;
 
begin
  reset <= NOT(KEY(0));

  writedata_left <= readdata_left;
  writedata_right <= readdata_right;
  read_s <= read_ready;
  write_s <= write_ready AND read_ready;
  
  my_clock_gen: clock_generator 
    port map (
      CLOCK_27  => CLOCK2_50, 
      reset     => reset, 
      AUD_XCK   => AUD_XCK
    );
      
  cfg: audio_and_video_config 
    port map (
      CLOCK_50  => CLOCK_50,
      reset     => reset,
      I2C_SDAT  => FPGA_I2C_SDAT,
      I2C_SCLK  => FPGA_I2C_SCLK
    );
    
  codec: audio_codec 
    port map (
      CLOCK_50          => CLOCK_50,
      reset             => reset,
      read_s            => read_s,
      write_s           => write_s,
      writedata_left    => writedata_left,
      writedata_right   => writedata_right,
      AUD_ADCDAT        => AUD_ADCDAT,
      AUD_BCLK          => AUD_BCLK,
      AUD_ADCLRCK       => AUD_ADCLRCK,
      AUD_DACLRCK       => AUD_DACLRCK,
      read_ready        => read_ready,
      write_ready       => write_ready,
      readdata_left     => readdata_left,
      readdata_right    => readdata_right,
      AUD_DACDAT        => AUD_DACDAT
    );
end beh;