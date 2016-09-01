-------------------------------------------------------------------------------
-- Zachary Weeden
-- and component
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;      -- gives you the std_logic type
ENTITY my_and IS
    PORT( a,b : IN STD_LOGIC;
        out1 : OUT STD_LOGIC);
END my_and;

ARCHITECTURE behavioral OF my_and IS
BEGIN
        out1 <= (a and b);
END behavioral;