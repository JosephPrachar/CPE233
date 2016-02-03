----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2016 10:45:34 AM
-- Design Name: 
-- Module Name: RAT_CPU - Behavioral
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

entity RAT_CPU is
    Port (
        IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
        RST : in STD_LOGIC;
        INT_IN : in STD_LOGIC;
        CLK : in STD_LOGIC;
        OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
        PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
        IO_OE : out STD_LOGIC);
end RAT_CPU;

architecture Behavioral of RAT_CPU is
    component counter 
        Port (  FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
            FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
            INTERRUPT : in STD_LOGIC_VECTOR (9 downto 0);
            PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
            PC_OE : in STD_LOGIC;
            PC_LD : in STD_LOGIC;
            PC_INC : in STD_LOGIC;
            RST : in STD_LOGIC;
            CLK : in STD_LOGIC;
            PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
            PC_TRI : out STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    component prog_rom
        Port (  ADDRESS : in std_logic_vector(9 downto 0); 
            INSTRUCTION : out std_logic_vector(17 downto 0); 
            CLK : in std_logic);
    end component;
    
    component RegisterFile
        Port (  D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
            DX_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
            DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
            ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
            ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
            DX_OE  : in     STD_LOGIC;
            WE     : in     STD_LOGIC;
            CLK    : in     STD_LOGIC);
     end component;
     
     component ALU
        Port (  A : in STD_LOGIC_VECTOR (7 downto 0);
            B : in STD_LOGIC_VECTOR (7 downto 0);
            C_IN : in STD_LOGIC;
            Sel : in STD_LOGIC_VECTOR (3 downto 0);
            SUM : out STD_LOGIC_VECTOR (7 downto 0);
            C_FLAG : out STD_LOGIC;
            Z_FLAG : out STD_LOGIC);
     end component;
     
     component FlagReg
        Port (  IN_FLAG  : in  STD_LOGIC;
            LD       : in  STD_LOGIC;
            SET      : in  STD_LOGIC;
            CLR      : in  STD_LOGIC;
            CLK      : in  STD_LOGIC;
            OUT_FLAG : out  STD_LOGIC);
     end component;
begin



end Behavioral;
