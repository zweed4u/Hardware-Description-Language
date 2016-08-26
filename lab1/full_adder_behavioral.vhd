--
--Zachary Weeden
--SINGLE bit full adder
--
library ieee;
use ieee.std_logic_1164.all;

entity full_adder_behavioral is
    port(
        a        :in std_logic;
        b        :in std_logic;
        cin      :in std_logic;
        sum      :out std_logic;
        cout     :out std_logic
    );
end full_adder_behavioral;

architecture arch of full_adder_behavioral is
begin
    sum <= (a xor b) xor cin;
    cout <= (a and b) or (b and cin) or (a and cin)
end arch;