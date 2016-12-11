-- Zachary Weeden
-- Lab 9: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_processor_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(9 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end audio_processor_3000;

architecture beh of audio_processor_3000 is
  -- instruction memory
  component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (9 DOWNTO 0)
    );
  end component;
  
  -- data memory
  component rom_data
    port(
      address  : in std_logic_vector (15 DOWNTO 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 DOWNTO 0)
    );
  end component;
  
  -- rising edge sync
component rising_edge_synchronizer is 
	port (
		clk               : in std_logic;
		reset             : in std_logic;
		input             : in std_logic;
		edge              : out std_logic
	);
end component;
  
--States
constant ch_idle        : std_logic_vector(4 downto 0) :="00001"; --nothing proceed to ch0_da on audio_enable pulse
constant ch0_da         : std_logic_vector(4 downto 0) :="00010"; --data_address=ch0_address
constant ch0_audio      : std_logic_vector(4 downto 0) :="00100"; --ch0_audio=the audio returned from the data ROM
constant ch1_da         : std_logic_vector(4 downto 0) :="01000"; --data_address=ch1_address
constant ch1_audio      : std_logic_vector(4 downto 0) :="10000"; --ch1_audio=the audio returned from the data ROM

--Internal Signals
signal edge				: std_logic; --synced_execute
signal instruction      : std_logic_vector(9 downto 0);
signal state_reg        : std_logic_vector(4 downto 0);
signal state_next       : std_logic_vector(4 downto 0);
signal pc       		: std_logic_vector(4 downto 0);
signal data_address  	: std_logic_vector(15 downto 0);
signal da0			  	: std_logic_vector(14 downto 0); --only 15 bits?
signal da1			  	: std_logic_vector(14 downto 0); --only 15 bits?
signal mix_audio  		: std_logic_vector(15 downto 0);
signal ch1_audio  		: std_logic_vector(15 downto 0);
signal ch0_audio  		: std_logic_vector(15 downto 0);
signal rom_instruct_out	: std_logic_vector(9 downto 0);
signal audio_in			: std_logic_vector(15 downto 0);
signal audio_address	: std_logic_vector(15 downto 0);

--Aliases for instruction signal
alias opcode        : std_logic_vector(1 downto 0) is rom_instruct_out(9 downto 8);
alias ch1			: std_logic is rom_instruct_out(7);
alias ch0			: std_logic is rom_instruct_out(6);
alias repeat        : std_logic is rom_instruct_out(5);
alias seek_address	: std_logic is rom_instruct_out(4 downto 0);

--Instruction set
constant play           : std_logic_vector(1 downto 0) :="00";
constant pause          : std_logic_vector(1 downto 0) :="01";
constant seek           : std_logic_vector(1 downto 0) :="10";
constant stop           : std_logic_vector(1 downto 0) :="11";

begin

-- data instantiation
u_rom_data_inst : rom_data
  port map (
    address    => data_address,
    clock      => clk,
    q          => audio_out
  );
  

u_rom_instr_inst : rom_instructions
    port map (
        address    => pc,
        clock      => clk,
        q          => rom_instruct_out
    );
   
sync_execute: rising_edge_synchronizer 
	port map(
		clk     => clk,
		reset   => reset,
		input   => execute_btn,
		edge    => edge
	);
	
	--SR
	--NSL
	--FUs
	--DR
	
update_address: process(clk, reset, edge, pc) 
begin
    if reset = '1' then
        pc <= (others => '0');
    elsif clk'event and clk = '1' then
        if edge = '1' then
            pc <= std_logic_vector(unsigned(pc) + 1 );
        end if;
    end if;
end process;

-- mux process

  led <= rom_instruct_out;
end beh;