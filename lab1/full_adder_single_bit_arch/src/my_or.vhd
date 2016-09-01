-------------------------------------------------------------------------------
-- Zachary Weeden
-- or component
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;      -- gives you the std_logic type
ENTITY my_or IS
    PORT( a,b,c : IN STD_LOGIC;
        out1 : OUT STD_LOGIC);
END my_or;

ARCHITECTURE behavioral OF my_or IS
BEGIN
        out1 <= (a or b or c);
END behavioral;