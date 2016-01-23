library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab5Wrapper is
    Port ( PC_ADDR          : in  STD_LOGIC_VECTOR (9 downto 0);
           SEL              : in  STD_LOGIC_VECTOR (1 downto 0);
           CLK              : in  STD_LOGIC;
           INSTRUCTION_BITS : out STD_LOGIC_VECTOR (17 downto 0));
end Lab5Wrapper;

architecture Behavioral of Lab5Wrapper is
    
    component prog_rom is
        port ( ADDRESS     : in  std_logic_vector(9 downto 0);
               CLK         : in  std_logic;
               INSTRUCTION : out std_logic_vector(17 downto 0)); 
    end component prog_rom;
    
    component counter is
        Port ( FROM_IMMED : in  STD_LOGIC_VECTOR (9 downto 0);
               FROM_STACK : in  STD_LOGIC_VECTOR (9 downto 0);
               INTERRUPT  : in  STD_LOGIC_VECTOR (9 downto 0);
               PC_MUX_SEL : in  STD_LOGIC_VECTOR (1 downto 0);
               PC_OE      : in  STD_LOGIC;
               PC_LD      : in  STD_LOGIC;
               PC_INC     : in  STD_LOGIC;
               RST        : in  STD_LOGIC;
               CLK        : in  STD_LOGIC;
               PC_COUNT   : out STD_LOGIC_VECTOR (9 downto 0);
               PC_TRI     : out STD_LOGIC_VECTOR (9 downto 0));
    end component counter;
    
    signal ADDR_S       : std_logic_vector (9 downto 0) := PC_ADDR;
    signal ADDR_NEW_S   : std_logic_vector (9 downto 0);
    
    signal PC_OE_S  : std_logic;
    signal PC_LD_S  : std_logic;
    signal PC_INC_S : std_logic;
    signal PC_RST_S : std_logic;
    
begin
    
    instruction_reader : prog_rom       port map (ADDR_S, CLK, INSTRUCTION_BITS);
    program_counter    : programCounter port map (ADDR_S, open, open, SEL, '1', '0', '1', '0', CLK, ADDR_NEW_S);
    ADDR_S <= ADDR_NEW_S;
    
end Behavioral;
