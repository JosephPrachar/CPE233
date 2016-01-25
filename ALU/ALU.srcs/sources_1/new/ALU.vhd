----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2016 10:40:54 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           C_IN : in STD_LOGIC;
           Sel : in STD_LOGIC_VECTOR (3 downto 0);
           SUM : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    signal temp_s : STD_LOGIC_VECTOR (8 downto 0);
begin
    process (A, B, C_IN, SEL)
    begin
        case SEL is
            when "0000" => temp_s <= ('0' & A) + B; -- add
            when "0001" => temp_s <= ('0' & A) + B + C_IN; -- addc
            when "0010" => temp_s <= ('0' & A) - B; -- sub
            when "0011" => temp_s <= ('0' & A) - B - C_IN; -- subc
            when "0100" => temp_s <= ('0' & A) - B; -- cmp
            when "0101" => temp_s <= ('0' & A) and B; -- and
            when "0110" => temp_s <= ('0' & A) or B; -- or
            when "0111" => temp_s <= ('0' & A) xor B; -- exor
            when "1000" => temp_s <= ('0' & A) and B; -- test
            when "1001" => temp_s <= A & C_IN; -- lsl
            when "1010" => temp_s <= A(0) & C_IN & A (7 downto 1); -- lsr
            when "1011" => temp_s <= A(7 downto 0) & A(7); -- rol
            when "1100" => temp_s <= A(0) & A(0) & A(7 downto 1); -- ror
            when "1101" => temp_s <= A(0) & A(7) & A(7 downto 0); -- asr
            when "1110" => temp_s <= '0' & B; -- mov
            when "1111" => temp_s <= "000000000"; -- unused
        end case;
    end process;
    
    SUM <= temp_s (7 downto 0);
    
    Z_FLAG <= '1' when (temp_s ="-00000000") else '0';
    C_FLAG <= temp_s(8); 
end Behavioral;
