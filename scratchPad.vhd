----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2016 11:29:49 AM
-- Design Name: 
-- Module Name: scratchPad - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scratchPad is
    Port ( Scr_Addr : in STD_LOGIC_VECTOR (7 downto 0);
           Scr_Oe   : in STD_LOGIC;
           SCR_WE   : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           SCR_DATA : inout STD_LOGIC_VECTOR (9 downto 0));
end scratchPad;

architecture Behavioral of scratchPad is
    TYPE memory is array (0 to 255) of std_logic_vector(9 downto 0);
    SIGNAL REG: memory := (others=>(others=>'0'));
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
	          if (SCR_WE = '1') then
			REG(conv_integer(Scr_Addr)) <= SCR_DATA;
		  end if;
		end if;
	end process;

	SCR_DATA <= REG(conv_integer(Scr_Addr)) when Scr_Oe='1' else (others=>'Z');

end Behavioral;
