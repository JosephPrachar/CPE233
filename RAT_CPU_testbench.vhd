----------------------------------------------------------------------------------
-- Engineer: Ian Lang and Davin Johnson
-- Create Date: 10/26/2015 03:30:03 PM
-- Module Name: RAT_CPU_testbench - Behavioral
-- Description: This testbench tests the behavior of the RAT CPU,
--              specifically an EXOR operation on the switches and
--              outputing to the LEDS
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all; 

entity RAT_CPU_testbench is
--  Port ( );
end RAT_CPU_testbench;

architecture Behavioral of RAT_CPU_testbench is

    component RAT_wrapper is
        Port ( LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
               SEGMENTS : out   STD_LOGIC_VECTOR (7 downto 0);
               VGA_RED  : out   STD_LOGIC_VECTOR (3 downto 0);
               VGA_GRN  : out   STD_LOGIC_VECTOR (3 downto 0);
               VGA_BLUE : out   STD_LOGIC_VECTOR (3 downto 0);
               VGA_HS   : out   STD_LOGIC;
               VGA_VS   : out   STD_LOGIC;
               AN       : out   STD_LOGIC_VECTOR (3 downto 0);
               SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
               BUTTONS  : in    STD_LOGIC_VECTOR (3 downto 0);  
               RST      : in    STD_LOGIC;
               INT      : in    STD_LOGIC;
               CLK      : in    STD_LOGIC);
               
    end component;
    
    signal s_leds       : std_logic_vector(7 downto 0);
    signal s_switches   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_an         : std_logic_vector(3 downto 0) := (others => '0');
    signal s_segments   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_buttons    : std_logic_vector(3 downto 0) := (others => '0');
    signal s_rst        : std_logic := '0';
    signal s_int        : std_logic := '0';
    signal CLK          : std_logic := '0';
    
    signal EXP_LEDS     : std_logic_vector(7 downto 0);
    
    signal s_vga_red        : std_logic_vector(3 downto 0)  := (others => '0');
    signal s_vga_grn        : std_logic_vector(3 downto 0)  := (others => '0');
    signal s_vga_blue       : std_logic_vector(3 downto 0)  := (others => '0');
    signal s_vga_hs         : std_logic := '0';
    signal s_vga_vs         : std_logic := '0';
        
    constant clk_period : time := 10ns;
    
begin
    
    uut: RAT_wrapper
    port map (  LEDS        => s_leds,
                SWITCHES    => s_switches,
                SEGMENTS    => s_segments,
                VGA_RED     => s_vga_red,
                VGA_GRN     => s_vga_grn,
                VGA_BLUE    => s_vga_blue,
                VGA_HS      => s_vga_hs,
                VGA_VS      => s_vga_vs,
                AN          => s_an,
                INT         => s_int,
                RST         => s_rst,
                BUTTONS     => s_buttons,
                CLK         => CLK);
                
                
    clk_proc : process
    begin
        CLK <= '0';
        wait for clk_period/2;
        CLK <= '1';
        wait for clk_period/2;
        
    end process;
    

    stim_proc: process
    begin
        s_switches <= x"F0";
        wait for 2ms;
        s_int <= '1';
        wait for 4ms;
        s_int <= '0';
        wait;
        
    end process;



end Behavioral;
