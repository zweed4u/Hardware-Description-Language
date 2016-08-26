LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY my_xor IS
    PORT( a,b : IN STD_LOGIC;
        out1 : OUT STD_LOGIC);
END my_xor

ARCHITECTURE behavioral OF my_xor IS
BEGIN
        out1 <= (a xor b);
END behavioral;