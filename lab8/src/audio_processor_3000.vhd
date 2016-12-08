-- Zachary Weeden
-- Lab 8: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_processor_3000 is
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic; -- difference between these two
    sync                : in std_logic; -- difference between these two
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

signal synced_execute       : std_logic;

signal data_address         : std_logic_vector(13 downto 0);
signal data_out             : std_logic_vector(15 downto 0); --this is audio_out internal signal not needed

signal other_da             : std_logic_vector(4 downto 0); --for other memory instantiation?
signal rom_instruct_out     : std_logic_vector(7 downto 0); --for other memory instantiation?

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
        q          => audio_out --data_out
    );

--other rom instantiaion needed?
u_rom_instr_inst : rom_instructions
    port map (
        address    => other_da,--5bits
        clock      => clk,
        q          => rom_instruct_out --8bits
    );

--sync_sync isn't needed
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
process(stateReg, reset, synced_execute, op, sk) --NSL
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

--
--FU's here? (async) --14 bit signals?
--data_address_play<=data_address+1
--data_address_play_repeat<=data_address+1
--stop<=(others => '0')
--pause<=data_address
--seek<=data_address --sk+"000000000"
--
--process(a,b,reset)
--begin
--  if reset = '1' then 
--    idle_sig  <= "00";  
--    add_sig   <= "00";
--    sub_sig   <= "00";
--  else 
--    idle_sig  <= "00";  
--    add_sig   <= std_logic_vector(unsigned(a) + unsigned(b));
--    sub_sig   <= std_logic_vector(unsigned(a) - unsigned(b));
--  end if;
--end process;
--

--Need another PC for u_rom_inst : rom_instructions?
update_address: process(clk, reset, synced_execute, other_da) --name of this signal? (other_da) sensitivity list?
begin
    if reset = '1' then
        other_da <= (others => '0');
    elsif clk'event and clk = '1' then
        if synced_execute = '1' then
            other_da <= std_logic_vector(unsigned(other_da) + 1 );
        end if;
    end if;
end process;

--Mux process - defined as follows
process(op, rpt, data_address_play, data_address_play_repeat, stop, pause, seek, data_address) --sk alias/other signals in sensitivity list? 
begin
    case op is
        when play => --00
            if rpt='1' then
                data_address<=data_address_play_repeat; --is this assignment correct and where is the the signal being 'given'? (14 bits)
            else
                data_address<=data_address_play;        --is this assignment correct and where is the the signal being 'given'?
            end if;

        when pause => --01
            data_address<=pause;                        --is this assignment correct and where is the the signal being 'given'?

        when seek => --10
            data_address<=seek;                         --is this assignment correct and where is the the signal being 'given'?

        when stop => --11
            data_address<=stop;                         --is this assignment correct and where is the the signal being 'given'?

        when others =>
            data_address<=data_address;                 --is this assignment correct and where is the the signal being 'given'?
    end case;

-- loop audio file (data register as mentioned in email?)
process(clk,reset) --sync needed in sensitivity list?
begin 
	if (reset = '1') then 
		data_address <= (others => '0');
	elsif (clk'event and clk = '1') then
		if (sync = '1') then    
			data_address <= std_logic_vector(unsigned(data_address) + 1 ); -- data_address vs. da_reg
		end if;
	end if;
end process;

led <= "10101010";
end beh;