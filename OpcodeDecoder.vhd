library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity OpcodeDecoder is
        port(   opcode : in std_logic_vector(5 downto 0);
                decodRtype : out std_logic := '0';
                decodlw : out std_logic := '0';
                decodsw : out std_logic := '0';
                decodbeq : out std_logic := '0';
                decodccm : out std_logic := '0';
                decodaddi : out std_logic := '0';
                decodandi : out std_logic := '0';
                decodbgez : out std_logic := '0';
                decodbne : out std_logic := '0';
                decodlui : out std_logic := '0';
                decodori : out std_logic := '0';
                decodaddiu : out std_logic := '0';
                decodxori : out std_logic := '0';
                decodj : out std_logic := '0';
                decodjal : out std_logic := '0');
end OpcodeDecoder;
 
architecture decode of OpcodeDecoder is
begin
        decodRtype <= '1' when opcode = "000000" else '0';
        decodlw <= '1' when opcode = "100011" else '0';
        decodsw <= '1' when opcode = "101011" else '0';
        decodbeq <= '1' when opcode = "000100" else '0';
        decodccm <= '1' when opcode = "011100" else '0';
        decodaddi <= '1' when opcode = "001000" else '0';
        decodandi <= '1' when opcode = "001100" else '0';
        decodbgez <= '1' when opcode = "000001" else '0';
        decodbne <= '1' when opcode = "000101" else '0';
        decodlui <= '1' when opcode = "001111" else '0';
        decodori <= '1' when opcode = "001101" else '0';
        decodaddiu <= '1' when opcode = "001001" else '0';
        decodxori <= '1' when opcode = "001110" else '0';
        decodj <= '1' when opcode = "000010" else '0';
        decodjal <= '1' when opcode = "000011" else '0';

end decode;