----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2016 11:28:45 AM
-- Design Name: 
-- Module Name: ALU_TB - Behavioral
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

entity ALU_TB is
--  Port ( );
end ALU_TB;

architecture Behavioral of ALU_TB is
    component ALU Port ( 
           A      : in STD_LOGIC_VECTOR (7 downto 0);
           B      : in STD_LOGIC_VECTOR (7 downto 0);
           C_IN   : in STD_LOGIC;
           Sel    : in STD_LOGIC_VECTOR (3 downto 0);
           SUM    : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC));
    end component;
    
    signal a_s, b_s, sum : STD_LOGIC_VECTOR (7 downto 0);
    signal sel_s : STD_LOGIC_VECTOR (3 downto 0);
    signal c_in_s, c_out_s, zero_s : STD_LOGIC;
begin

    process
    begin
        -- Test cases take the form (A, B, Cin) => (sum, C_Flag, Z_Flag, time tested)
    
        -- test ADD
        
        -- (0xAA, 0xAA, 0) => (
        -- (0x0A, 0xA0, 1)
        -- (0xFF, 0x01, 0)
        
        -- test ADDC
        
        -- (0xC8, 0x36, 1)
        -- (0xC8, 0x37, 1)
        
        -- test SUB
        
        -- (0xC8, 0x64, 0)
        -- (0xC8, 0x64, 1)
        -- (0x64, 0xC8, 0)
        
        -- test SUBC
        
        -- (0xC8, 0x64, 0)
        -- (0xC8, 0x64, 1)
        -- (0x64, 0xC8, )
        
        -- test CMP
        
        -- (0x64, 0xC8, 1)
        -- (0xAA, 0xFF, 0)
        -- (0xFF, 0xAA, 0)
        -- (0xAA, 0xAA, 0)
        
        -- test AND
        
        -- (0xAA, 0xAA, 0)
        -- (0x03, 0xAA, 0)
        
        -- test OR
        
        -- (0xAA, 0xAA, 0)
        -- (0x03, 0xAA, 0)
        
        -- test XOR
        
        -- (0xAA, 0xAA, 0)
        
        -- test TEST
        
        -- (0x03, 0xAA, 0)
        -- (0xAA, 0xAA, 0)
        -- (0x55, 0xAA, 0)
        
        -- test LSL
        
        -- (0x01, 0x12, 0)
        
        -- test LSR
        
        -- (0x80, 0x33, 0)
        -- (0x80, 0x43, 1)
        
        -- test ROL
        
        -- (0x01, 0xAB, 1)
        
        -- test ROR
        
        -- (0xAA, 0xF2, 0)
        -- (0x80, 0x3C, 0)
        -- (0x80, 0x98, 1)
        
        -- test ASR
        
        -- (0x80, 0x81, 0)
        -- (0x40, 0xB2, 0)
        
        -- test MOV
        
        -- (0x50, 0x30, 0)
        -- (0x43, 0x22, 1)












    end process;

end Behavioral;
