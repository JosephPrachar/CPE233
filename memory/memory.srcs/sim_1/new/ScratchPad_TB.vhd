----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2016 11:36:53 AM
-- Design Name: 
-- Module Name: ScratchPad_TB - Behavioral
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

entity ScratchPad_TB is
--  Port ( );
end ScratchPad_TB;

architecture Behavioral of ScratchPad_TB is
    
    component scratchPad is
        Port ( Scr_Addr : in STD_LOGIC_VECTOR (7 downto 0);
               Scr_Oe   : in STD_LOGIC;
               SCR_WE   : in STD_LOGIC;
               CLK      : in STD_LOGIC;
               SCR_DATA : inout STD_LOGIC_VECTOR (9 downto 0));
    end component scratchPad;
    
    signal scr_addr_tb          : std_logic_vector (7 downto 0);
    signal scr_oe_tb, scr_we_tb : std_logic;
    signal clk_tb               : std_logic;
    signal scr_data_tb          : std_logic_vector (9 downto 0);
    
    
    signal data_x_exp : std_logic_vector (9 downto 0);
    constant clk_period : time := 10ns;
    
begin
    
    uut : scratchPad port map (scr_addr_tb, scr_oe_tb, scr_we_tb, clk_tb, scr_data_tb);
    
    clock_driver : process begin
        clk_tb <= not clk_tb;
        wait for clk_period / 2;
    end process clock_driver;
    
    test : process
        
        variable I : integer range 0 to 32 := 0;
        
    begin
        
            scr_addr_tb<="00000000";
            scr_data_tb<="0000000000";
            wait for 4ns;
            scr_we_tb <= '1'; --togle high before rising edge
            wait for 1ns;
            while( I < 32) loop
                wait for 1ns;
                scr_we_tb <= '0'; --drop after rising edge
                wait for 1ns;
                scr_addr_tb <= scr_addr_tb + 1; --prepare next address and data
                wait for 1ns;
                scr_data_tb <= scr_data_tb +2;
                wait for 6ns;
                I := I+1;
                if(I <32) then
                    scr_we_tb <= '1';
                end if;
                wait for 1ns;
            end loop;
            
            scr_we_tb <= '0';
            scr_oe_tb <= '1';
            wait for 75ns; --no reason, just like to start at a nice number such as 400ns...
            
            -- Read from RegisterFile
            I := 0;
            -- set initial values
            data_x_exp <= "0000000000";
            scr_addr_tb <= "00000000";
            -- loop through all memory locations. NOTE: can read two at once
            while ( I < 16) loop
                scr_we_tb <= '0';
                wait for 1ns;
    
                if not(scr_data_tb = data_x_exp) then
                    report "error with data X at t= " & time'image(now) 
                    severity failure;
                else 
                    report "data X at t= " & time'image(now) & " is good"
                        severity note;
                end if;
                 
                wait for 1ns;    
                --get new values
                data_x_exp <= data_x_exp + 4 ; --add 4 because each location increases by 2, and you're increasing by 2 memory locations
                scr_data_tb <= scr_data_tb + 2;
                
                wait for 8ns;
                I := I + 1; 
            end loop;
            
            wait for 40ns; -- again, just lining up for a nice start time of 600ns.
            
            -- Test OE pin of RegisterFile
            scr_oe_tb <= '0';
            wait for 50ns;
            if not (scr_data_tb = "ZZZZZZZZZZ") then 
                report "error with OE pin"
                severity failure;
            else
                report "OE pin test 1 passed"
                severity note;
            end if;
            scr_oe_tb <= '1';
            wait for 50ns;
                if (scr_data_tb = "ZZZZZZZZZZ") then 
                report "error with OE pin"
                severity failure;
            else
                report "OE pin test 2 passed"
                severity note;
            end if;
            report "Error checking complete at 700ns" severity note;
        
    end process;
    
end Behavioral;
