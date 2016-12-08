-- Zachary Weeden
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

signal edge       : std_logic; --synced_execute

signal data_address             : std_logic_vector(13 downto 0);
signal data_address_reg         : std_logic_vector(13 downto 0); --after state reg
signal data_address_play        : std_logic_vector(13 downto 0);
signal data_address_play_repeat : std_logic_vector(13 downto 0);
signal data_address_stop        : std_logic_vector(13 downto 0);
signal data_address_pause       : std_logic_vector(13 downto 0);
signal data_address_seek        : std_logic_vector(13 downto 0);

signal data_out             : std_logic_vector(15 downto 0); --this is audio_out internal signal not needed
signal pc                   : std_logic_vector(4 downto 0); --for other memory instantiation data address
signal rom_instruct_out     : std_logic_vector(7 downto 0); --for other memory instantiation instruction out 

--States
constant idle           : std_logic_vector(4 downto 0) :="00001";
constant fetch          : std_logic_vector(4 downto 0) :="00010";
constant decode         : std_logic_vector(4 downto 0) :="00100";
constant execute        : std_logic_vector(4 downto 0) :="01000";
constant decode_error   : std_logic_vector(4 downto 0) :="10000";
signal instruction      : std_logic_vector(7 downto 0);
signal state_reg        : std_logic_vector(4 downto 0);
signal state_next       : std_logic_vector(4 downto 0);

--Instruction set
constant play           : std_logic_vector(1 downto 0) :="00";
constant pause          : std_logic_vector(1 downto 0) :="01";
constant seek           : std_logic_vector(1 downto 0) :="10";
constant stop           : std_logic_vector(1 downto 0) :="11";

--Aliases for instruction signal
alias opcode        : std_logic_vector(1 downto 0) is rom_instruct_out(7 downto 6);
alias repeat           : std_logic is rom_instruct_out(5);
alias seek_address  : std_logic_vector(4 downto 0) is rom_instruct_out(4 downto 0);

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
        address    => pc,--5bits
        clock      => clk,
        q          => rom_instruct_out --8bits
    );

--sync_sync isn't needed
sync_execute: rising_edge_synchronizer 
    port map(
        clk     => clk,
        reset   => reset,
        input   => execute_btn,
        edge    => edge
    );

--state register
process(reset, clk)
begin
    if (reset = '1') then
        state_reg <= idle;
    elsif (clk'event and clk ='1') then
        state_reg <= state_next;
    end if;
end process;

--sensitivity list Next State Logic
process(state_reg, reset, edge, opcode, seek_address) --NSL
begin
    if reset = '1' then 
        state_next <= idle;
    else 
        state_next <= state_reg; --prevent latch
        case state_reg is
            when idle =>
                if (edge='1') then
                    state_next <= fetch;
                else 
                    state_next <= idle;
                end if;

            when fetch =>
                --get the instruction from mem
                state_next <= decode;

            when decode =>
                if opcode="10" then --seeking
                    if seek_address="0000" then --seeking instruction going to 00000000000000
                        --not allowed to seek to the beginning go to decode_error
                        state_next <= decode_error;
                    end if;
                else
                    state_next <= execute;
                end if;

            when decode_error =>
                state_next <= idle;    

            when execute =>
                if (edge='1') then
                    state_next <= fetch;
                end if;

            when others =>
                state_next <= idle;
        end case;
    end if;
end process;

--FU's here (async) --14 bit signals?
process(data_address_reg,seek_address,reset)--data_address? (sensitivity list)
begin
    data_address_play_repeat  <= std_logic_vector(unsigned(data_address_reg)+1);
    data_address_play<= std_logic_vector(unsigned(data_address_reg)+1); --need something like <="00000000000000" when data_address_reg = "11111111111111" else std_logic_vector(unsigned(data_address_reg)+1);
    data_address_pause<=data_address_reg;
    data_address_stop<=(others => '0');
    data_address_seek<=seek_address&"000000000";
end process;

-- data register [synchronous]
process(clk,reset)
begin 
  if (reset = '1') then 
    data_address_reg <= (others => '0');
  elsif (clk'event and clk = '1') then
    data_address_reg <= data_address;
  end if;
end process;

--Need another PC for u_rom_inst : rom_instructions?
update_address: process(clk, reset, edge, pc) --name of this signal? (pc) sensitivity list?
begin
    if reset = '1' then
        pc <= (others => '0');
    elsif clk'event and clk = '1' then
        if edge = '1' then
            pc <= std_logic_vector(unsigned(pc) + 1 );
        end if;
    end if;
end process;

--Mux process - defined as follows
process(opcode, repeat, data_address_play, data_address_play_repeat, data_address_stop, data_address_pause, data_address_seek, data_address) --seek_address alias/other signals in sensitivity list? 
begin
    if reset = '1' then
        data_address<=(others => '0');
    else
        case opcode is -- rest needed
            when play => --00
                if repeat='1' then
                    data_address<=data_address_play_repeat; --signal assignment? (14 bits)
                else
                    data_address<=data_address_play;
                end if;
        
            when pause => --01
                data_address<=data_address_pause;
        
            when seek => --10
                data_address<=data_address_seek;
        
            when stop => --11
                data_address<=data_address_stop;
        
            when others =>
                data_address<=data_address;
        end case;
    end if;
end process;
-- loop audio file
--process(clk,reset) --sync in sensitivity list?
--begin 
--    if (reset = '1') then 
--        data_address <= (others => '0');
--    elsif (clk'event and clk = '1') then
--        if (sync = '1') then    
--            data_address <= std_logic_vector(unsigned(data_address) + 1 ); -- data_address vs. data_address_reg
--        end if;
--    end if;
--end process;
instruction<=rom_instruct_out;
led <= rom_instruct_out;
end beh;
