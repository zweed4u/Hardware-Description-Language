--rom vhdl
--inferred when vhdl is written as lut (case, array)
entity hex_to_ssd is

port(
	inputs	:	in std_logic_vector(3 downto 0);
	clk		:	in std_logic;
	outputs	:	out std_logic_vector(6 downto 0)
);
end hex_to_ssd;

architecture structure of hex_to_ssd is

	type ssd_array is array(0 to 9) of std_logic_vector(6 downto 0);
	signal ssd: ssd_array := ("1000000","1111001","0100100","0110000",
		"0011001","0010010","0000010","1111000","0000000","0010000");

	begin
	process (clk)
		begin
			if (rising_edge(clk)) then
				outputs <= ssd (to_integer(unsigned(inputs)));
			end if;
	end process;

end structure;