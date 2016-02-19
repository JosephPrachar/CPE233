library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StackPointer is
   port (
      D_IN_BUS  : in  STD_LOGIC_VECTOR (7 downto 0);
      SEL       : in  STD_LOGIC_VECTOR (1 downto 0);
      LD        : in  STD_LOGIC;
      RST       : in  STD_LOGIC;
      CLK       : in  STD_LOGIC;
      D_OUT     : out STD_LOGIC_VECTOR (7 downto 0);
      D_OUT_DEC : out STD_LOGIC_VECTOR (7 downto 0)
   );
end StackPointer;

architecture Stack of StackPointer is
   
   signal SP : STD_LOGIC_VECTOR (7 downto 0);
   signal SP_LD : STD_LOGIC_VECTOR (7 downto 0);
   signal SP_RST : STD_LOGIC_VECTOR (7 downto 0);

begin
   
   -- Load new value if needed
   LOAD : process (CLK, LD, SP, RST) begin
      if (rising_edge(CLK)) then
         if (LD = '1') then
            if (SEL = "00") then
               SP_LD <= D_IN_BUS;
            elsif (SEL = "10") then
               SP_LD <= SP - 1;
            elsif (SEL = "11") then
               SP_LD <= SP + 1;
            end if;
	     end if;
	  end if;
      if (RST = '1') then
         SP_LD <= (others => '0');
      end if;
   end process LOAD;
   
   SP <= SP_LD;
   
   -- Output resulting stack pointers
   D_OUT     <= SP;
   D_OUT_DEC <= SP - 1;
   
end Stack;
