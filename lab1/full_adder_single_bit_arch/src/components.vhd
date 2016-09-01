-------------------------------------------------------------------------------
-- Zachary Weeden
-- components package
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;      -- gives you the std_logic type

PACKAGE components is
--or 3 inputs
    COMPONENT my_or IS
        PORT( a,b,c : IN STD_LOGIC;
            out1 : OUT STD_LOGIC);
    END COMPONENT;

--and 2 inputs
    COMPONENT my_and IS
        PORT( a,b : IN STD_LOGIC;
            out1 : OUT STD_LOGIC);
    END COMPONENT;

--xor 2 inputs
    COMPONENT my_xor IS
        PORT( a,b : IN STD_LOGIC;
            out1 : OUT STD_LOGIC);
    END COMPONENT;
    
END components;