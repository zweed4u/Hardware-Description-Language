----
--Zachary Weeden
--Two Bit Full Adder
----

library ieee;
use ieee.std_logic_1164.all;

entity full_adder_2bit is
    port(
        a    : in std_logic_vector(1 downto 0);
        b    : in std_logic_vector(1 downto 0);
        sum  : out std_logic_vector(1 downto 0);
        cout : out std_logic
    );
end full_adder_2bit;



architecture arch of full_adder_2bit is
component full_adder is
    port(
        a    : in std_logic;
        b    : in std_logic;
        cin  : in std_logic;
        sum  : out std_logic;
        cout : out std_logic
    );
end component;

signal cin    : std_logic_vector(1 downto 0);

begin
    cin(0)    <='0';
    
    fullAdder1:    full_adder
        port map(
            a    => a(0),
            b    => b(0),
            cin  => cin(0),
            sum  => sum(0),
            cout => cin(1)
        );
        
    fullAdder2:    full_adder
        port map(
            a    => a(1),
            b    => b(1),
            cin  => cin(1),
            sum  => sum(1),
            cout => cout
        );
end arch;