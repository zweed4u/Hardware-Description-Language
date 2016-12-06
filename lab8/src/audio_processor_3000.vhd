-- Dr. Kaputa
-- Lab 8: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_processor_3000 is
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(7 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end audio_processor_3000;

architecture beh of audio_processor_3000 is
-- instruction memory
component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (7 DOWNTO 0)
    );
end component;
  
-- data memory
component rom_data
    port(
      address  : in std_logic_vector (13 DOWNTO 0);
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

signal enable           : std_logic;
signal synced_execute   : std_logic;
--signal synced_sync   	: std_logic;
signal data_address  	: std_logic_vector(13 downto 0);
signal rom_instruct_out : std_logic_vector(7 downto 0);

--States
constant idle           : std_logic_vector(4 downto 0) :="00001";
constant fetch          : std_logic_vector(4 downto 0) :="00010";
constant decode         : std_logic_vector(4 downto 0) :="00100";
constant execute        : std_logic_vector(4 downto 0) :="01000";
constant decode_error   : std_logic_vector(4 downto 0) :="10000";
signal stateReg         : std_logic_vector(4 downto 0);
signal stateNext        : std_logic_vector(4 downto 0);

--Instruction set
constant play           : std_logic_vector(1 downto 0) :="00";
constant pause          : std_logic_vector(1 downto 0) :="01";
constant seek           : std_logic_vector(1 downto 0) :="10";
constant stop           : std_logic_vector(1 downto 0) :="11";

--Aliases for instruction signal
alias op 	: std_logic_vector(2 downto 0) is rom_instruct_out(7 downto 6);
alias rpt 	: std_logic is rom_instruct_out(5);
alias sk	: std_logic_vector(4 downto 0) is rom_instruct_out(4 downto 0)

begin
-- data instantiation
u_rom_data_inst : rom_data
  port map (
    address    => data_address,
    clock      => clk,
    q          => audio_out
  );
  
  
sync_execute: rising_edge_synchronizer 
    port map(
        clk     => clk,
        reset   => reset,
        input   => execute_btn,
        edge    => synced_execute
    );

--state register
process(reset, clk)
begin
    if (reset = '1') then
        stateReg <= idle;
    elsif (clk'event and clk ='1') then
        stateReg <= stateNext;
    end if;
end process;

--sensitivity list Next State Logic
process(stateReg, reset, synced_execute) --NSL
begin
    if reset = '1' then 
        stateNext <= idle;
    else 
        stateNext <= stateReg; --prevent latch
        case stateReg is
            when idle =>
                if (synced_execute='1') then
                    stateNext <= fetch;
                else 
                    stateNext <= idle;
                end if;
            when fetch =>
				--get the instruction from mem
                stateNext <= decode;
            when decode =>
				if op="10" then --seeking
					if sk="0000" then --seeking instruction going to 00000000000000
						--not allowed to seek to the beginning go to decode_error
						stateNext <= decode_error;
					end if;
                else
					stateNext <= execute;
				end if;
            when decode_error =>
                stateNext <= idle;	
            when execute =>
                if (synced_execute='1') then
                    stateNext <= fetch;
                end if;
            when others =>
                stateNext <= idle;
        end case;
    end if;
end process;

-- routing [asynchronous]
process(reset, stateReg, clk)
begin
    if (clk'event and clk ='1') then
        if (stateReg=write_w_no_op) then
            to_mem <= result_sig;
        elsif (stateReg=read_r) then
            to_mem <= save;
        end if;
    end if;
    preDD <= std_logic_vector(unsigned("0000" & to_mem));
end process;


-- loop audio file
process(clk,reset)
begin 
	if (reset = '1') then 
		data_address <= (others => '0');
	elsif (clk'event and clk = '1') then
		if (sync = '1') then    
			data_address <= std_logic_vector(unsigned(data_address) + 1 );
		end if;
	end if;
end process;

led <= "10101010";
end beh;