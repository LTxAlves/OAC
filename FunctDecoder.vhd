library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity FunctDecoder is
        port(   funct : in std_logic_vector(5 downto 0);
                tipoR : in std_logic;
                ehcloclzmadd : in std_logic;
                ehadd : out std_logic := '0';
                ehaddu : out std_logic := '0';
                ehand : out std_logic := '0';
                ehclo : out std_logic := '0';
                ehclz : out std_logic := '0';
                ehdiv : out std_logic := '0';
                ehjr : out std_logic := '0';
                ehmfhi : out std_logic := '0';
                ehmflo : out std_logic := '0';
                ehmult : out std_logic := '0';
                ehnor : out std_logic := '0';
                ehor : out std_logic := '0';
                ehsll : out std_logic := '0';
                ehslt : out std_logic := '0';
                ehsra : out std_logic := '0';
                ehsrav : out std_logic := '0';
                ehsrl : out std_logic := '0';
                ehsub : out std_logic := '0';
                ehsubu : out std_logic := '0';
                ehxor : out std_logic := '0';
                ehmadd : out std_logic := '0');
end FunctDecoder;
 
architecture decode of FunctDecoder is
begin
        ehadd <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100000" else '0';
        ehaddu <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100001" else '0';
        ehand <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100100" else '0';
        ehclo <= '1' when tipoR = '0' AND ehcloclzmadd = '1' AND funct = "100001" else '0';
        ehclz <= '1' when tipoR = '0' AND ehcloclzmadd = '1' AND funct = "100000" else '0';
        ehdiv <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "011010" else '0';
        ehjr <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "001000" else '0';
        ehmfhi <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "010000" else '0';
        ehmflo <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "010010" else '0';
        ehmult <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "011000" else '0';
        ehnor <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100111" else '0';
        ehor <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100101" else '0';
        ehsll <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "000000" else '0';
        ehslt <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "101010" else '0';
        ehsra <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "000011" else '0';
        ehsrav <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "000111" else '0';
        ehsrl <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "000010" else '0';
        ehsub <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100010" else '0';
        ehsubu <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100011" else '0';
        ehxor <= '1' when tipoR = '1' AND ehcloclzmadd = '0' AND funct = "100110" else '0';
        ehmadd <= '1' when tipoR = '0' AND ehcloclzmadd = '1' AND funct = "000000" else '0';

end decode;