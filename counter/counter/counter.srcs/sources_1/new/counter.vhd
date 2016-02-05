library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           INTERRUPT : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           PC_OE : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
           PC_TRI : out STD_LOGIC_VECTOR (9 downto 0));
end counter;

architecture Behavioral of counter is

    component programCounter is 
        Port ( D_IN : in STD_LOGIC_VECTOR (9 downto 0);
               PC_OE : in STD_LOGIC;
               PC_LD : in STD_LOGIC;
               PC_INC : in STD_LOGIC;
               RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
               PC_TRI : out STD_LOGIC_VECTOR (9 downto 0));
    end component;

    signal D_IN : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";

begin

    D_IN <= FROM_IMMED when PC_MUX_SEL = "00"
       else FROM_STACK when PC_MUX_SEL = "01"
       else INTERRUPT    when PC_MUX_SEL = "10"
       else (others => '0');
    
    counter : programCounter port map (D_IN, PC_OE, PC_LD,
                                       PC_INC, RST, CLK,
                                       PC_COUNT, PC_TRI);
    
end Behavioral;
