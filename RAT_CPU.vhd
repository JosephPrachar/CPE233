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
    component ControlUnit
        Port (
            CLK           : in   STD_LOGIC;
            C             : in   STD_LOGIC;
            Z             : in   STD_LOGIC;
            INT           : in   STD_LOGIC;
            RST           : in   STD_LOGIC;
            OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
            OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
            
            PC_LD         : out  STD_LOGIC;
            PC_INC        : out  STD_LOGIC;
            PC_RESET      : out  STD_LOGIC;
            PC_OE         : out  STD_LOGIC;			  
            PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            SP_LD         : out  STD_LOGIC;
            SP_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            SP_RESET      : out  STD_LOGIC;
            RF_WR         : out  STD_LOGIC;
            RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
            RF_OE         : out  STD_LOGIC;
            REG_IMMED_SEL : out  STD_LOGIC;
            ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
            SCR_WR        : out  STD_LOGIC;
            SCR_OE        : out  STD_LOGIC;
            SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
            C_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            C_FLAG_LD     : out  STD_LOGIC;
            C_FLAG_SET    : out  STD_LOGIC;
            C_FLAG_CLR    : out  STD_LOGIC;
            SHAD_C_LD     : out  STD_LOGIC;
            Z_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            Z_FLAG_LD     : out  STD_LOGIC;
            Z_FLAG_SET    : out  STD_LOGIC;
            Z_FLAG_CLR    : out  STD_LOGIC;
            SHAD_Z_LD     : out  STD_LOGIC;
            I_FLAG_SET    : out  STD_LOGIC;
            I_FLAG_CLR    : out  STD_LOGIC;
            IO_OE         : out  STD_LOGIC);
    end component;

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
     
     component alu
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
     
     component StackPointer is
        port (
            D_IN_BUS  : in  STD_LOGIC_VECTOR (7 downto 0);
            SEL       : in  STD_LOGIC_VECTOR (1 downto 0);
            LD        : in  STD_LOGIC;
            RST       : in  STD_LOGIC;
            CLK       : in  STD_LOGIC;
            D_OUT     : out STD_LOGIC_VECTOR (7 downto 0);
            D_OUT_DEC : out STD_LOGIC_VECTOR (7 downto 0)
        );
     end component;
     
     component scratchPad is
        port (
            Scr_Addr : in STD_LOGIC_VECTOR (7 downto 0);
            Scr_Oe   : in STD_LOGIC;
            SCR_WE   : in STD_LOGIC;
            CLK      : in STD_LOGIC;
            SCR_DATA : inout STD_LOGIC_VECTOR (9 downto 0)
        );
     end component;
     
     signal MULTI_BUS : STD_LOGIC_VECTOR (9 downto 0) := "ZZZZZZZZZZ";
     
     -- Program counter signals
     signal PC_MUX_SEL : STD_LOGIC_VECTOR (1 downto 0);
     signal PC_OE, PC_LD, PC_INC, PC_RST : STD_LOGIC;
     signal PC_COUNT : STD_LOGIC_VECTOR (9 downto 0);
     
     -- Prog-rom signal
     signal Instruction : STD_LOGIC_VECTOR (17 downto 0);
     
     -- Register file signals
     signal RF_DATA_IN : STD_LOGIC_VECTOR (7 downto 0);
     signal RF_WR_SEL : STD_LOGIC_VECTOR (1 downto 0);
     signal RF_OUT_X, RF_OUT_Y : STD_LOGIC_VECTOR (7 downto 0);
     signal RF_OE, RF_WE : STD_LOGIC;
     
     -- ALU signals
     signal ALU_IN_B, ALU_OUT : STD_LOGIC_VECTOR (7 downto 0);
     signal ALU_SEL : STD_LOGIC_VECTOR (3 downto 0);
     signal REG_IMMED_SEL : STD_LOGIC;
     signal ALU_OUT_C, ALU_OUT_Z : STD_LOGIC;
     
     -- C Flag signals
     signal C_FLAG : STD_LOGIC;
     signal C_SET, C_CLR, C_LD : STD_LOGIC;
     
     -- Z Flag signals
     signal Z_FLAG, Z_LD : STD_LOGIC;
     
     -- Stack signals
     signal SP_MUX_SEL : STD_LOGIC_VECTOR (1 downto 0);
     signal SP_LD, SP_RST : STD_LOGIC;
     signal SP, SP_DEC : STD_LOGIC_VECTOR (7 downto 0);
     
     -- ScratchPad signals
     signal SCR_WR, SCR_OE : STD_LOGIC;
     signal SCR_ADDR_SEL : STD_LOGIC_VECTOR (1 downto 0);
     signal SCR_ADDR : STD_LOGIC_VECTOR (7 downto 0);
     
begin
    control : controlUnit PORT MAP (CLK, C_FLAG, Z_FLAG, INT_IN, RST, Instruction (17 downto 13), Instruction (1 downto 0), 
        PC_LD, PC_INC, PC_RST, PC_OE, PC_MUX_SEL, 
        SP_LD, SP_MUX_SEL, SP_RST, 
        RF_WE, RF_WR_SEL, RF_OE, REG_IMMED_SEL, 
        ALU_SEL, 
        SCR_WR, SCR_OE, SCR_ADDR_SEL, 
        open, C_LD, C_SET, C_CLR, open, 
        open, Z_LD, open, open, open, 
        open, open, IO_OE);

    pc : counter PORT MAP (Instruction (12 downto 3), MULTI_BUS (9 downto 0), Instruction (12 downto 3), PC_MUX_SEL, PC_OE, PC_LD, PC_INC, PC_RST, CLK, PC_COUNT, MULTI_BUS);
    progRom : prog_rom PORT MAP (PC_COUNT, Instruction, CLK);
    
    RF_DATA_IN <= ALU_OUT                when RF_WR_SEL = "00"
             else MULTI_BUS (7 downto 0) when RF_WR_SEL = "01"
             else IN_PORT                when RF_WR_SEL = "11"
             else (others => '0');
    regFile : RegisterFile PORT MAP (RF_DATA_IN, RF_OUT_X, RF_OUT_Y, Instruction (12 downto 8), Instruction (7 downto 3), RF_OE, RF_WE, CLK);
    MULTI_BUS (7 downto 0) <= RF_OUT_X;
    
    ALU_IN_B <= RF_OUT_Y when REG_IMMED_SEL = '0'
           else Instruction (7 downto 0);
    aluMod : alu PORT MAP (RF_OUT_X, ALU_IN_B, C_FLAG, ALU_SEL, ALU_OUT, ALU_OUT_C, ALU_OUT_Z);
    cFlag : FlagReg PORT MAP (ALU_OUT_C, C_LD, C_SET, C_CLR, CLK, C_FLAG);
    zFlag : FlagReg PORT MAP (ALU_OUT_Z, Z_LD, '0', '0', CLK, Z_FLAG);
    
    stack : StackPointer port map (MULTI_BUS (7 downto 0), SP_MUX_SEL, SP_LD, SP_RST, CLK, SP, SP_DEC);
    
    SCR_ADDR <= RF_OUT_Y                 when (SCR_ADDR_SEL = "00")
           else Instruction (7 downto 0) when (SCR_ADDR_SEL = "01")
           else SP                       when (SCR_ADDR_SEL = "10")
           else SP_DEC;
    
    scratch : scratchPad port map (SCR_ADDR, SCR_OE, SCR_WR, CLK, MULTI_BUS);
    
    PORT_ID <= Instruction (7 downto 0);
    OUT_PORT <= MULTI_BUS (7 downto 0);
    
end Behavioral;
