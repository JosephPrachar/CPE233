----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2016 11:46:58 PM
-- Design Name: 
-- Module Name: cpu_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_TB is
--  Port ( );
end cpu_TB;

architecture Behavioral of cpu_TB is
    component RAT_WRAPPER
        Port ( LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
            SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
            BTN      : in    STD_LOGIC;
            RST      : in    STD_LOGIC;
            CLK      : in    STD_LOGIC);
    end component;
    
    signal BTN, RST, CLK : STD_LOGIC;
    signal LEDS, SWITCHES : STD_LOGIC_VECTOR (7 downto 0);    
    
begin
    cpu : RAT_WRAPPER PORT MAP (LEDS, SWITCHES, BTN, RST, CLK);
    
    process
    begin 
        CLK <= '0';
        wait for 20ns;
        CLK <= '1';
        wait for 20ns;
    end process;

    process
    begin
        RST <= '1';
        SWITCHES <= x"09";
        wait for 50ns;
        
        RST <= '0';
        
        wait for 10050ns;
        BTN <= '1';
        wait for 400ns;
        BTN <= '0';
        
        wait;
        
    end process;
end Behavioral;
