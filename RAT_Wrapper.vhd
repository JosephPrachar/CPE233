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
    Port (
        SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
        BTN      : in    STD_LOGIC;
        RST      : in    STD_LOGIC;
        CLK      : in    STD_LOGIC;
        LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
        
        VGA_RED  : out   STD_LOGIC_VECTOR (3 downto 0);
        VGA_GRN  : out   STD_LOGIC_VECTOR (3 downto 0);
        VGA_BLUE : out   STD_LOGIC_VECTOR (3 downto 0);
        VGA_HS   : out   STD_LOGIC;
        VGA_VS   : out   STD_LOGIC
    );
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

   -- INPUT PORT IDS -------------------------------------------------------------
   -- Right now, the only possible inputs are the switches
   -- In future labs you can add more port IDs, and you'll have
   -- to add constants here for the mux below
   CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
   CONSTANT VGA_READ_ID : STD_LOGIC_VECTOR(7 downto 0) := x"00";
   -------------------------------------------------------------------------------
   
   -------------------------------------------------------------------------------
   -- OUTPUT PORT IDS ------------------------------------------------------------
   -- In future labs you can add more port IDs
   CONSTANT VGA_XADDR_ID : STD_LOGIC_VECTOR(7 downto 0) := x"00";
   CONSTANT VGA_YADDR_ID : STD_LOGIC_VECTOR(7 downto 0) := x"01";
   CONSTANT VGA_COLOR_ID : STD_LOGIC_VECTOR(7 downto 0) := x"02";
   CONSTANT VGA_WE_ID    : STD_LOGIC_VECTOR(7 downto 0) := x"03";
   CONSTANT LEDS_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"40";
   -------------------------------------------------------------------------------
   
   component Clk_Divider is
      port (
         CLK   : in  std_logic;
         S_CLK : out std_logic
      );
   end component;
   
   component db_1shot_FSM
      port (
         A    : in  STD_LOGIC;
         CLK  : in  STD_LOGIC;
         A_DB : out STD_LOGIC
      );
   end component;
   
   component vgaDriverBuffer
       Port (         CLK, we : in std_logic;
                      wa : in std_logic_vector (10 downto 0);
                      wd : in std_logic_vector (7 downto 0);
                      Rout : out std_logic_vector(2 downto 0);
                      Gout : out std_logic_vector(2 downto 0);
                      Bout : out std_logic_vector(1 downto 0);
                      HS      : out std_logic;
                      VS      : out std_logic;
                      pixelData : out std_logic_vector(7 downto 0)
                 );
   end component;
   
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
   
   -- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------
   signal s_input_port  : std_logic_vector (7 downto 0);
   signal s_output_port : std_logic_vector (7 downto 0);
   signal s_port_id     : std_logic_vector (7 downto 0);
   signal s_load        : std_logic;
   signal s_clk1        : std_logic := '0';
   --signal s_interrupt   : std_logic; -- not yet used
   
    -- VGA signals
   signal s_vga_wa         : std_logic_vector(10 downto 0)  := (others => '0');
   signal s_vga_wd         : std_logic_vector(7 downto 0)  := (others => '0');
   signal s_vga_we         : std_logic := '1';
   signal s_vga_pixelData  : std_logic_vector(7 downto 0)  := (others => '0');     
   signal s_vga_yadd       : std_logic_vector(7 downto 0)  := (others => '0');
   signal s_vga_xadd       : std_logic_vector(7 downto 0)  := (others => '0');
   signal s_vga_color      : std_logic_vector(7 downto 0)  := (others => '0');
   
   signal s_vga_red        : std_logic_vector(2 downto 0)  := (others => '1');
   signal s_vga_grn        : std_logic_vector(2 downto 0)  := (others => '1');
   signal s_vga_blue       : std_logic_vector(1 downto 0)  := (others => '1');
   signal s_vga_hs         : std_logic := '0';
   signal s_vga_vs         : std_logic := '0';
      
   -- Register definitions for output devices ------------------------------------
   signal r_LEDS        : std_logic_vector (7 downto 0); 
   -------------------------------------------------------------------------------
   
   signal S_CLK : std_logic;
   signal BTN_DEBOUNCE : STD_LOGIC;

begin

   CLK_DIV : Clk_Divider port map (CLK, S_CLK);
   BTN_DEBOUNCER : db_1shot_FSM port map (BTN, CLK, BTN_DEBOUNCE);

   -- Instantiate RAT_CPU --------------------------------------------------------
   CPU: RAT_CPU
   port map(  IN_PORT  => s_input_port,
              OUT_PORT => s_output_port,
              PORT_ID  => s_port_id,
              RST      => RST,  
              IO_OE    => s_load,
              INT_IN   => BTN_DEBOUNCE,
              CLK      => S_CLK);
   -------------------------------------------------------------------------------
   VGA: vgaDriverBuffer
      port map(CLK => s_clk,
               WE => s_vga_we,
               WA => s_vga_wa,
               WD => s_vga_wd,
               Rout =>s_vga_red,
               Gout => s_vga_grn,
               Bout => s_vga_blue,
               HS => s_vga_hs,
               VS => s_vga_vs,
               pixelData => s_vga_PixelData);
               
    CLK_div1: process(CLK)
       begin
           if(rising_edge(CLK)) then
               s_clk1 <= not s_clk1;
           end if;
       end process CLK_div1;

   ------------------------------------------------------------------------------- 
   -- MUX for selecting what input to read ---------------------------------------
   -------------------------------------------------------------------------------
   inputs: process(s_port_id, SWITCHES)
   begin
      if (s_port_id = SWITCHES_ID) then
         s_input_port <= SWITCHES;
      elsif (s_port_id = VGA_READ_ID) then
         s_input_port <= s_vga_PixelData;
      else
         s_input_port <= x"00";
      end if;
   end process inputs;
   -------------------------------------------------------------------------------

   -------------------------------------------------------------------------------
   -- MUX for updating output registers ------------------------------------------
   -- Register updates depend on rising clock edge and asserted load signal
   -------------------------------------------------------------------------------
   outputs: process(S_CLK) 
   begin   
      if (rising_edge(S_CLK)) then
         if (s_load = '1') then 
            case(s_port_id) is
            
                when LEDS_ID =>           
                    r_LEDS <= s_output_port;                
                                         
                when VGA_YADDR_ID =>
                    s_vga_yadd <= s_output_port;                
                when VGA_XADDR_ID =>
                    s_vga_xadd <= s_output_port;                
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
   LEDS <= r_LEDS;
   s_vga_wa <= s_vga_yadd(4 downto 0) & s_vga_xadd(5 downto 0);
   s_vga_wd <= s_vga_color;
   VGA_RED  <= s_vga_red & '0';
   VGA_GRN  <= s_vga_grn & '0';
   VGA_BLUE <= s_vga_blue & "00";
   VGA_HS   <= s_vga_hs;
   VGA_VS   <= s_vga_vs;

end Behavioral;
