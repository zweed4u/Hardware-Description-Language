-- Zachary Weeden
-- Lab 8: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_processor_3000 is 
    port(
        clk                 : in std_logic;
        reset               : in std_logic;
        execute_btn         : in std_logic; --difference between these two? 
        sync                : in std_logic; --difference between these two?
        audio_in            : in std_logic_vector(15 downto 0); --what is this input vector?
        led                 : out std_logic_vector(9 downto 0);
        audio_out           : out std_logic_vector(15 downto 0)
    );
end audio_processor_3000;

architecture beh of audio_processor_3000 is
--COMPONENTS HERE
component generic_counter is
    generic (
        max_count        : integer := 3
    );
    port (
        clk              : in  std_logic; 
        reset            : in  std_logic;
        output           : out std_logic
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

signal enable           : std_logic;
signal synced_execute   : std_logic;
signal data_address     : std_logic_vector(15 downto 0);
--8bit mif needed - check depth of memory and its associated files
--0   : 00000000; -- play once  
--1   : 00100000; -- play repeating 
--2   : 11000000; -- stop
--3   : 00100000; -- play repeating
--4   : 01000000; -- pause
--5   : 00000000; -- play once
--6   : 10010000; -- seek half way
--7   : 00000000; -- play once
--8   : 11000000; -- stop
--9   : 00000000; -- play once

--States
constant idle           : std_logic_vector(4 downto 0) :="00001";
constant fetch          : std_logic_vector(4 downto 0) :="00010";
constant decode         : std_logic_vector(4 downto 0) :="00100";
constant execute        : std_logic_vector(4 downto 0) :="01000";
constant decode_error   : std_logic_vector(4 downto 0) :="10000";
signal stateReg         : std_logic_vector(4 downto 0);
signal stateNext        : std_logic_vector(4 downto 0);

--example of aliases
signal play : std_logic_vector(7 downto 0) := "00000000"; --0 0 RPT X X X X X
alias rpt : std_logic is play(5);

signal pause : std_logic_vector(7 downto 0) := "00000000"; --0 1 X X X X X X

signal seek : std_logic_vector(7 downto 0) := "00000000"; --1 0 X SK4 SK3 SK2 SK1 SK0
alias sk : std_logic_vector(4 downto 0) is seek(4 downto 0);

signal stop : std_logic_vector(7 downto 0) := "00000000"; --1 1 X X X X X X

begin
--COMPONENT INSTANTIATIONS HERE
--PC, btn synch, ...
sync_execute: rising_edge_synchronizer 
    port map(
        clk     => clk,
        reset   => reset,
        input   => execute_btn,
        edge    => synced_execute
    );

generic_counter_inst: generic_counter  
    generic map (
        max_count => update_rate
    )
    port map(
        clk       => clk,
        reset     => reset,
        output    => enable
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
                stateNext <= decode;
            when decode =>
                --parse for decode_error - conditional for next state transitiion
                stateNext <= decode_error;
                stateNext <= execute;
            when decode_error =>
                stateNext <= idle;	
            when execute =>
                if (synced_execute='1') then
                    stateNext <= fetch;
                --else condition?
                end if;
            when others =>
                stateNext <= idle;
        end case;
    end if;
end process;


--EXAMPLE PC increment - 'enable' is output of generic counter
update_address: process(clk,reset,address_sig)
begin
    if reset = '1' then
        address_sig <= (others => '0');
    elsif clk'event and clk = '1' then
        if enable = '1' then
            address_sig <= std_logic_vector(unsigned(address_sig) + 1 );
        end if;
    end if;
end process;

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