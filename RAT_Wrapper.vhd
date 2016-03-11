----------------------------------------------------------------------------------
-- Company:  RAT Technologies
-- Engineer:  Various RAT rats
-- 
-- Create Date:    1/31/2012
-- Design Name: 
-- Module Name:    RAT_wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Wrapper for RAT CPU. This model provides a template to interfaces 
--    the RAT CPU to the Nexys2 development board. 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAT_wrapper is
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
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

   -- INPUT PORT IDS -------------------------------------------------------------
   -- Right now, the only possible inputs are the switches
   -- In future labs you can add more port IDs, and you'll have
   -- to add constants here for the mux below
   CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
   -------------------------------------------------------------------------------
   
   -------------------------------------------------------------------------------
   -- OUTPUT PORT IDS ------------------------------------------------------------
   -- In future labs you can add more port IDs
   CONSTANT LEDS_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"40";
   CONSTANT SEGMENTS_ID   : STD_LOGIC_VECTOR (7 downto 0) := X"81";
   CONSTANT AN_ID         : STD_LOGIC_VECTOR (7 downto 0) := X"82";
   CONSTANT VGA_HADD_ID   : STD_LOGIC_VECTOR (7 downto 0) := X"00";
   CONSTANT VGA_LADD_ID   : STD_LOGIC_VECTOR (7 downto 0) := X"01";
   CONSTANT VGA_COLOR_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"02";
   CONSTANT VGA_WE_ID     : STD_LOGIC_VECTOR (7 downto 0) := X"03";
   CONSTANT VGA_PIXEL_DATA_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"04";
   CONSTANT BUTTONS_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"50";
   -------------------------------------------------------------------------------

   -- Declare RAT_CPU ------------------------------------------------------------
   component RAT_CPU 
       Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
              OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
              PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
              IO_OE    : out STD_LOGIC;
              RST      : in  STD_LOGIC;
              INT_IN   : in  STD_LOGIC;
              CLK      : in  STD_LOGIC);
   end component RAT_CPU;
   -------------------------------------------------------------------------------
    
    component vgaDriverBuffer is
        Port (    CLK, we      : in  std_logic;
                  wa           : in  std_logic_vector (10 downto 0);
                  wd           : in  std_logic_vector (7 downto 0);
                  Rout         : out std_logic_vector(2 downto 0);
                  Gout         : out std_logic_vector(2 downto 0);
                  Bout         : out std_logic_vector(1 downto 0);
                  HS           : out std_logic;
                  VS           : out std_logic;
                  pixelData    : out std_logic_vector(7 downto 0)
                         );
   end component;
   
   component sseg_dec is
       Port (     ALU_VAL   : in  std_logic_vector(7 downto 0); 
                  SIGN      : in  std_logic;
                  VALID     : in  std_logic;
                  CLK       : in  std_logic;
                  DISP_EN   : out std_logic_vector(3 downto 0);
                  SEGMENTS  : out std_logic_vector(7 downto 0));
   end component;
   
   -- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------
   signal s_input_port  : std_logic_vector (7 downto 0);
   signal s_output_port : std_logic_vector (7 downto 0);
   signal s_port_id     : std_logic_vector (7 downto 0);
   signal s_load        : std_logic;
   signal s_clk         : std_logic := '0';
   signal s_interrupt   : std_logic := '0';
   
   -- Register definitions for output devices ------------------------------------
   signal temp_LEDS        : std_logic_vector (7 downto 0); 
   signal temp_SEGMENTS    : std_logic_vector (7 downto 0) := x"00"; 
   -------------------------------------------------------------------------------
    
    -- VGA signals
    signal s_vga_wa         : std_logic_vector(10 downto 0)  := (others => '0');
    signal s_vga_wd         : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_vga_we         : std_logic := '0';
    signal s_vga_pixelData  : std_logic_vector(7 downto 0)  := (others => '0');     
    signal s_vga_hadd       : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_vga_ladd       : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_vga_color      : std_logic_vector(7 downto 0)  := (others => '0');
    
    signal s_vga_red        : std_logic_vector(2 downto 0)  := (others => '1');
    signal s_vga_grn        : std_logic_vector(2 downto 0)  := (others => '1');
    signal s_vga_blue       : std_logic_vector(1 downto 0)  := (others => '1');
    signal s_vga_hs         : std_logic := '0';
    signal s_vga_vs         : std_logic := '0';
begin
   -- Instantiate RAT_CPU --------------------------------------------------------
   CPU: RAT_CPU
   port map(  IN_PORT  => s_input_port,
              OUT_PORT => s_output_port,
              PORT_ID  => s_port_id,
              RST      => '0',  
              IO_OE    => s_load,
              INT_IN   => s_interrupt,
              CLK      => s_clk);         
   -------------------------------------------------------------------------------
    VGAbuffer: vgaDriverBuffer
    port map(   CLK         => s_clk,
                we          => s_vga_we,
                wa          => s_vga_wa,
                wd          => s_vga_wd,
                Rout        => s_vga_red,
                Gout        => s_vga_grn,
                Bout        => s_vga_blue,
                HS          => s_vga_hs,
                VS          => s_vga_vs,
                pixelData   => s_vga_pixelData);
    
    sseg_decoder: sseg_dec
    port map(   ALU_VAL     =>  temp_SEGMENTS,
                SIGN        => '0',
                VALID       => '1',
                CLK         => s_clk,
                DISP_EN     => AN,
                SEGMENTS    => SEGMENTS );       
    CLK_div: process(CLK)
    begin
        if(rising_edge(CLK)) then
            s_clk <= not s_clk;
        end if;
    end process CLK_div;
    
    
    
    interrupt_gen: process(CLK)
        variable cnt : integer := 0;
    begin        
        if(rising_edge(CLK)) then
            if(cnt = 1600000) then -- 30 Hz
                s_interrupt <= not s_interrupt;
                cnt := 0;
            else
                cnt := cnt + 1;
            end if;
        end if;
    end process;
   ------------------------------------------------------------------------------- 
   -- MUX for selecting what input to read ---------------------------------------
   -------------------------------------------------------------------------------
   inputs: process(s_port_id, SWITCHES)
   begin
      case(s_port_id) is
            when VGA_PIXEL_DATA_ID =>
                s_input_port <= s_vga_pixelData;
                
            when BUTTONS_ID =>
                s_input_port <= "0000" & BUTTONS;
                
            when others =>
                s_input_port <= x"00";
        end case;
        
   end process inputs;
   -------------------------------------------------------------------------------


   -------------------------------------------------------------------------------
   -- MUX for updating output registers ------------------------------------------
   -- Register updates depend on rising clock edge and asserted load signal
   -------------------------------------------------------------------------------
   outputs: process(CLK) 
   begin   
      if (rising_edge(CLK)) then
         if (s_load = '1') then 
         
            case(s_port_id) is
            
                when LEDS_ID =>           
                   temp_LEDS <= s_output_port;
                
                when SEGMENTS_ID =>
                    temp_SEGMENTS <= s_output_port;             
                
                when VGA_HADD_ID =>
                    s_vga_hadd <= s_output_port;
                
                when VGA_LADD_ID =>
                    s_vga_ladd <= s_output_port;
                
                when VGA_COLOR_ID =>
                    s_vga_color <= s_output_port;    
                    
                when VGA_WE_ID =>
                    s_vga_we    <= s_output_port(0); 
                      
                    
                when others =>
            
            end case;           
         end if; 
      end if;
   end process outputs;      
   -------------------------------------------------------------------------------

   -- Register Interface Assignments ---------------------------------------------
   LEDS     <= temp_LEDS; 
   s_vga_wa <= s_vga_hadd(2 downto 0) & s_vga_ladd;
   s_vga_wd <= s_vga_color;
   VGA_RED  <= s_vga_red & '0';
   VGA_GRN  <= s_vga_grn & '0';
   VGA_BLUE <= s_vga_blue & "00";
   VGA_HS   <= s_vga_hs;
   VGA_VS   <= s_vga_vs;
   
end Behavioral;
