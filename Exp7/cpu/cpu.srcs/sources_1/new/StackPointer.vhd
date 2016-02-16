library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StackPointer is
   port (
      D_IN_BUS  : in  STD_LOGIC_VECTOR (7 downto 0);
      D_IN_INC  : in  STD_LOGIC_VECTOR (7 downto 0);
      D_IN_DEC  : in  STD_LOGIC_VECTOR (7 downto 0);
      SEL       : in  STD_LOGIC_VECTOR (1 downto 0);
      LD        : in  STD_LOGIC;
      RST       : in  STD_LOGIC;
      CLK       : in  STD_LOGIC;
      D_OUT     : out STD_LOGIC_VECTOR (7 downto 0);
      D_OUT_DEC : out STD_LOGIC_VECTOR (7 downto 0)
   );
end StackPointer;

architecture Stack of StackPointer is
   
   signal D_IN : STD_LOGIC_VECTOR (7 downto 0);
   signal SP : STD_LOGIC_VECTOR (7 downto 0);

begin
   
   -- Filter which input will be used
   D_IN <=      D_IN_BUS when (SEL = "00")
           else D_IN_DEC when (SEL = "10")
	   else D_IN_INC when (SEL = "11")
	   else open;
   
   -- Reset if needed
   SP <= (others => '0') when (RST = '1');
   
   -- Load new value if needed
   LOAD : process (CLK) begin
      if (rising_edge(CLK)) then
         if (LD = '1') then
            SP <= D_IN;
	 end if;
      end if;
   end process LOAD;
   
   D_OUT     <= SP;
   D_OUT_DEC <= SP - 1;
   
end Stack;
