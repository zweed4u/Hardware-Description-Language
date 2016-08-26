-------File components.vhd---------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------

PACKAGE components is
--or3
    COMPONENT my_or IS
        PORT( a,b,c : IN STD_LOGIC;
            out1 : OUT STD_LOGIC);
    END COMPONENT;

--and2
    COMPONENT my_and IS
        PORT( a,b : IN STD_LOGIC;
            out1 : OUT STD_LOGIC);
    END COMPONENT;

--xor
    COMPONENT my_xor IS
        PORT( a,b : IN STD_LOGIC;
            out1 : OUT STD_LOGIC);
    END COMPONENT;
    
END components;