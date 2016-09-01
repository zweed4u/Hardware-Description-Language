--Zachary Weeden
--HDL lab 1
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE work.components.all;

ENTITY full_adder_single_bit_arc IS
    PORT( 
        a    : IN STD_LOGIC;
        b    : IN STD_LOGIC;
        cin  : IN STD_LOGIC;
        sum  : OUT STD_LOGIC;
        cout : OUT STD_LOGIC
    );
END full_adder_single_bit_arc;




ARCHITECTURE behavioral OF full_adder_single_bit_arc IS
    SIGNAL and1_out : STD_LOGIC;
    SIGNAL and2_out : STD_LOGIC;
    SIGNAL and3_out : STD_LOGIC;
    SIGNAL or1_out : STD_LOGIC;
    SIGNAL xor1_out : STD_LOGIC;
    SIGNAL xor2_out : STD_LOGIC;


    
    
     COMPONENT my_or IS
         PORT( a,b,c : IN STD_LOGIC;
             out1 : OUT STD_LOGIC);
     END COMPONENT;

     COMPONENT my_and IS
         PORT( a,b : IN STD_LOGIC;
             out1 : OUT STD_LOGIC);
     END COMPONENT;
    
     COMPONENT my_xor IS
         PORT( a,b : IN STD_LOGIC;
             out1 : OUT STD_LOGIC);
     END COMPONENT;

     
     
     
     
    BEGIN
        ----AND instantiations----
        and1 : my_and
        PORT MAP(a =>a,
            b =>b,
            out1 =>and1_out);
            
        and2 : my_and
        PORT MAP(a =>b,
            b =>cin,
            out1 =>and2_out);
            
        and3 : my_and
        PORT MAP(a =>a,
            b =>cin,
            out1 =>and3_out);
            
        ----END AND----
            
            
            
        ----OR instantiations----
        or1 : my_or
        PORT MAP(a =>and1_out,
            b =>and2_out,
            c =>and3_out,
            out1 =>or1_out);
        ----END OR----
            
            
            
            
            
            
        ----XOR instantiation----
        xor1 : my_xor
        PORT MAP(a =>a,
            b =>b,
            out1 =>xor1_out);
            
        xor2 : my_xor
        PORT MAP(a =>xor1_out,
            b =>cin,
            out1 =>xor2_out);
        ----END XOR----
        
        
cout<=or1_out;
sum<=xor2_out;
END behavioral;
