library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab5Wrapper is
    Port ( FROM_IMMED       : in  STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK       : in  STD_LOGIC_VECTOR (9 downto 0);
           INTERCEPT        : in  STD_LOGIC_VECTOR (9 downto 0);
           SEL              : in  STD_LOGIC_VECTOR (1 downto 0);
           PC_OE            : in  STD_LOGIC;
           PC_LD            : in  STD_LOGIC;
           PC_INC           : in  STD_LOGIC;
           PC_RST           : in  STD_LOGIC;
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
    
    signal ADDR_S       : std_logic_vector (9 downto 0);
    
begin
    program_counter    : counter port map (FROM_IMMED, FROM_STACK, INTERCEPT, SEL, PC_OE, PC_LD, PC_INC, PC_RST, CLK, open, ADDR_S);
    instruction_reader : prog_rom       port map (ADDR_S, CLK, INSTRUCTION_BITS);
    
end Behavioral;
