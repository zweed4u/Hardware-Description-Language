-------------------------------------------------------------------------------
-- Zachary Weeden
-- seven_seg demo
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seven_seg is
    generic (
        max_count       : integer := 25000000
     );
    port (
        bcd             : in std_logic_vector(3 downto 0);
        seven_seg_out   : out std_logic_vector(6 downto 0)
    );   
end seven_seg;  

architecture beh of seven_seg  is

begin
process(bcd)
    begin
    case bcd is
        when "0000" => --0
            seven_seg_out<="1000000";
        when "0001" => --1
            seven_seg_out<="1111001";
        when "0010" => --2
            seven_seg_out<="0100100";
        when "0011" => --3
            seven_seg_out<="0110000";
        when "0100" => --4
            seven_seg_out<="0011001";
        when "0101" => --5
            seven_seg_out<="0010010";
        when "0110" => --6
            seven_seg_out<="0000010";
        when "0111" => --7
            seven_seg_out<="1111000";
        when "1000" => --8
            seven_seg_out<="0000000" ;
        when "1001" => --9
            seven_seg_out<="0011000"; 
        when others => --10 through 16 all off
            seven_seg_out<="1111111"; 
    end case;
end process;
end beh;