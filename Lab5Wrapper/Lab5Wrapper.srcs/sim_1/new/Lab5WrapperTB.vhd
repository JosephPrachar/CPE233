----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2016 06:03:33 PM
-- Design Name: 
-- Module Name: Lab5WrapperTB - Behavioral
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

entity Lab5WrapperTB is
--  Port ( );
end Lab5WrapperTB;

architecture Behavioral of Lab5WrapperTB is
    component Lab5Wrapper Port ( 
           FROM_IMMED       : in  STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK       : in  STD_LOGIC_VECTOR (9 downto 0);
           INTERCEPT        : in  STD_LOGIC_VECTOR (9 downto 0);
           SEL              : in  STD_LOGIC_VECTOR (1 downto 0);
           PC_OE            : in  STD_LOGIC;
           PC_LD            : in  STD_LOGIC;
           PC_INC           : in  STD_LOGIC;
           PC_RST           : in  STD_LOGIC;
           CLK              : in  STD_LOGIC;
           INSTRUCTION_BITS : out STD_LOGIC_VECTOR (17 downto 0));
    end component;
    
    signal immed_s : STD_LOGIC_VECTOR (9 downto 0);
    signal ld_s, inc_s, clk_s : STD_LOGIC := '0';
    signal inst_s : STD_LOGIC_VECTOR (17 downto 0);
    
    constant CLK_period : time := 10 ns;
begin
    wrap : Lab5Wrapper PORT MAP (immed_s, "0000000000", "0000000000", "00", '1', ld_s, inc_s, '0', clk_s, inst_s);

    process
    begin
        clk_s <= '0';
        wait for CLK_period/2;
        clk_s <= '1';
        wait for Clk_period/2;
    end process;
    
    process
    begin 
        -- immed_s <= "0000000000";
        immed_s <= "0001000000";
        ld_s <= '1';
        wait for 2 * Clk_period;
        ld_s <= '0';
        inc_s <= '1';
        --wait for Clk_period;
        assert (inst_s = "110110101000000101");
        
        wait for 100 * Clk_period;
        wait;
    end process;
    
end Behavioral;
