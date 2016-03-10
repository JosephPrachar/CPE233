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
        
        VGA_RGB  : out   STD_LOGIC_VECTOR (7 downto 0);
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
   CONSTANT VGA_WRITE_ID : STD_LOGIC_VECTOR(7 downto 0) := x"02";
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
   --signal s_interrupt   : std_logic; -- not yet used
   
      -- VGA signals
   signal r_vga_we   : std_logic;                       -- Write enable
   signal r_vga_wa   : std_logic_vector(10 downto 0);   -- The address to read from / write to  
   signal r_vga_wd   : std_logic_vector(7 downto 0);    -- The pixel data to write to the framebuffer
   signal r_vgaData  : std_logic_vector(7 downto 0);    -- The pixel data read from the framebuffer
   
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
      port map(CLK => CLK,
               WE => r_vga_we,
               WA => r_vga_wa,
               WD => r_vga_wd,
               Rout => VGA_RGB(7 downto 5),
               Gout => VGA_RGB(4 downto 2),
               Bout => VGA_RGB(1 downto 0),
               HS => VGA_HS,
               VS => VGA_VS,
               pixelData => r_vgaData);

   ------------------------------------------------------------------------------- 
   -- MUX for selecting what input to read ---------------------------------------
   -------------------------------------------------------------------------------
   inputs: process(s_port_id, SWITCHES)
   begin
      if (s_port_id = SWITCHES_ID) then
         s_input_port <= SWITCHES;
      elsif (s_port_id = VGA_READ_ID) then
         s_input_port <= r_vgaData;
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
           
            -- the register definition for the LEDS
            if (s_port_id = LEDS_ID) then
               r_LEDS <= s_output_port;
               
            -- VGA support
            elsif (s_port_id = VGA_XADDR_ID) then
               r_vga_wa(5 downto 0) <= s_output_port(5 downto 0);
            elsif (s_port_id = VGA_YADDR_ID) then
               r_vga_wa(10 downto 6) <= s_output_port(4 downto 0);
            elsif (s_port_id = VGA_WRITE_ID) then
               r_vga_wd <= s_output_port;
            end if;
            
            if (s_port_id = VGA_WRITE_ID) then
               r_vga_we <= '1';
            else
               r_vga_we <= '0';
            end if;
           
         end if; 
      end if;
   end process outputs;      
   -------------------------------------------------------------------------------

   -- Register Interface Assignments ---------------------------------------------
   LEDS <= r_LEDS; 

end Behavioral;
