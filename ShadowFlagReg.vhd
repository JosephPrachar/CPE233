library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShadowFlagReg is
    Port ( F_IN : in  STD_LOGIC;
           LD   : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           FLAG : out STD_LOGIC);
end ShadowFlagReg;

architecture Behavioral of ShadowFlagReg is   
begin
    
    LOAD : process (CLK) begin
        if (rising_edge(CLK)) then
            if (LD = '1') then
                FLAG <= F_IN;
            end if;
        end if;
    end process;
    
end Behavioral;
