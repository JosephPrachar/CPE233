library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity programCounter is
    Port ( D_IN : in STD_LOGIC_VECTOR (9 downto 0);
           PC_OE : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
           PC_TRI : out STD_LOGIC_VECTOR (9 downto 0));
end programCounter;

architecture Behavioral of programCounter is

    signal pcCountSig : STD_LOGIC_VECTOR (9 downto 0);

begin

    process (PC_LD, PC_INC, pcCountSig, CLK)
    begin
        if (rising_edge(CLK)) then
            if (PC_LD = '1') then
                pcCountSig <= D_IN;
            elsif (PC_INC = '1') then
                pcCountSig <= pcCountSig + 1;
            end if;
        end if;
    end process;

    PC_COUNT <= pcCountSig when RST = '0'
           else (others => '0');
    PC_TRI <= (others => '0') when RST = '1'
         else pcCountSig when PC_OE = '1'
         else (others => 'Z');

end Behavioral;
