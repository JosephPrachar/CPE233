library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clk_Divider is
    Port ( CLK : in STD_LOGIC;
           S_CLK : out STD_LOGIC);
end Clk_Divider;

architecture Behavioral of Clk_Divider is

    signal CLK_SIG : std_logic_vector (1 downto 0) := "00";

begin
    
    divide : process (CLK) begin
        if (rising_edge(CLK)) then
            CLK_SIG <= CLK_SIG + 1;
        end if;
    end process;
    
    S_CLK <= CLK_SIG(1);
    
end Behavioral;
