library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity ExceptionHandler is
        port(	overflow			:	in std_logic;
					desconhecimento:	in std_logic;
					PC_EX				:	in std_logic_vector(31 downto 0);
					PC_ID				:	in std_logic_vector(31 downto 0);
					EPC				:	out std_logic_vector(31 downto 0);
					CAUSE				:	out std_logic_vector(31 downto 0);
					STATUS			:	out std_logic_vector(31 downto 0);
					NOVO_PC			:	out std_logic_vector(31 downto 0));
end ExceptionHandler;
 
architecture handle of ExceptionHandler is
begin
		  EPC <= PC_EX when overflow = '1' else
					PC_ID when desconhecimento = '1' else
					"00000000000000000000000000000000";
		  STATUS <= "00000000000000000000000000000001" when overflow = '1' else
						"00000000000000000000000000000010" when desconhecimento = '1' else
						"00000000000000000000000000000000";
		  CAUSE <= "00000000000000000000000000001010" when overflow = '1' else --1010 para overflow
					  "00000000000000000000000000001100" when desconhecimento = '1' else --1100 para instrucao desconhecida
					  "00000000000000000000000000000000";
		  NOVO_PC <= "10000000000000000000000110000000" when overflow = '1' else
						 "10000000000000000000000000000000" when desconhecimento = '1' else
						 "00000000000000000000000000000000";

end handle;