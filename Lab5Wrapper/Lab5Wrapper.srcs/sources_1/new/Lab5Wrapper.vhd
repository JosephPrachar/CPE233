library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab5Wrapper is
    Port ( PC_ADDR : in STD_LOGIC_VECTOR (9 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           CLK : in STD_LOGIC;
           INSTRUCTION_BITS : out STD_LOGIC_VECTOR (17 downto 0));
end Lab5Wrapper;

architecture Behavioral of Lab5Wrapper is
    
    component programCounter is
        Port ( D_IN : in STD_LOGIC_VECTOR (9 downto 0);
               PC_OE : in STD_LOGIC;
               PC_LD : in STD_LOGIC;
               PC_INC : in STD_LOGIC;
               RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
    end component programCounter;
    
    component prog_rom is
        port (     ADDRESS : in std_logic_vector(9 downto 0);
                       CLK : in std_logic;
               INSTRUCTION : out std_logic_vector(17 downto 0)); 
    end component prog_rom;
    
    signal ADDR         : std_logic_vector (9 downto 0) := (others <= '0');
    signal INSTRUCTION  : std_logic_vector (17 downto 0);
    
begin
    
    instruction_reader : prog_rom       port map (ADDR, CLK, INSTRUCTION);
    program_counter    : programCounter port map (PC_ADDR, '1', '0', '1', '0', CLK, ADDR);
    
end Behavioral;
