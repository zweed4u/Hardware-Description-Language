-------------------------------------------------------------------------------
-- Dr. Kaputa
-- fsmd example
-- this fsmd will either add or subtract two numbers based upon the state machine
-- state machine starts in idle and will go to add state on button press
-- consecutive button presses will toggle between add and subtract states
--
-- MAKE SURE YOU UNDERSTAND HOW THESE PROCESSES MAP TO THE BLOCK DIAGRAM
-- ALSO UNDERSTAND WHAT EACH PROCESS DOES... AS YOU WILL NEED TO DO SOMETHING
-- SIMILAR TO THIS ON THE TEST.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;   
use ieee.numeric_std.all;   

entity fsmd is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    button_press      : in std_logic;
    a                 : in std_logic_vector(1 downto 0);
    b                 : in std_logic_vector(1 downto 0);
    result            : out std_logic_vector(1 downto 0)
  );
end fsmd;

architecture beh of fsmd is
-- signal declarations
constant add_state      : std_logic_vector(2 downto 0) := "001";
constant subract_state  : std_logic_vector(2 downto 0) := "010";
constant idle_state     : std_logic_vector(2 downto 0) := "100";

signal state_reg        : std_logic_vector(2 downto 0);
signal state_next       : std_logic_vector(2 downto 0);
    
signal idle_sig         : std_logic_vector(1 downto 0);
signal add_sig          : std_logic_vector(1 downto 0);
signal sub_sig          : std_logic_vector(1 downto 0);
signal result_next      : std_logic_vector(1 downto 0);

begin 

-- state register [synchronous]
process(clk,reset)
begin 
  if (reset = '1') then 
    state_reg <= idle_state;
  elsif (clk'event and clk = '1') then
    state_reg <= state_next;
  end if;
end process;

-- next state logic [asynchronous]
process(state_reg,reset,button_press)
begin
  if reset = '1' then 
    state_next <= idle_state;
  else 
    -- default values
    state_next <= state_reg;    -- prevents a latch
    case state_reg is  
      when idle_state =>
        if (button_press = '1') then  
          state_next <= add_state;
        end if;  
      when add_state =>
        if (button_press = '1') then  
          state_next <= subract_state;
        end if; 
      when subract_state =>
        if (button_press = '1') then  
          state_next <= add_state;
        end if; 
      when others =>
        state_next <= idle_state;
    end case;
  end if;
end process;

-- functional units [asynchronous]
process(a,b,reset)
begin
  if reset = '1' then 
    idle_sig  <= "00";  
    add_sig   <= "00";
    sub_sig   <= "00";
  else 
    idle_sig  <= "00";  
    add_sig   <= std_logic_vector(unsigned(a) + unsigned(b));
    sub_sig   <= std_logic_vector(unsigned(a) - unsigned(b));
  end if;
end process;

-- routing [asynchronous]
process(a,b,reset,state_reg)
begin
  if reset = '1' then 
    result_next <= "00";
  else 
    if (state_reg = add_state) then
      result_next <= add_sig;
    elsif (state_reg = subract_state) then
      result_next <= sub_sig;
    else 
      result_next <= idle_sig;
    end if;
  end if;
end process;

-- data register [synchronous]
process(clk,reset)
begin 
  if (reset = '1') then 
    result <= "00";
  elsif (clk'event and clk = '1') then
    result <= result_next;
  end if;
end process;

end beh; 