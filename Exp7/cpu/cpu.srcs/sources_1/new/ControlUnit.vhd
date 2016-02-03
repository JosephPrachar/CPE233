----------------------------------------------------------------------------------
-- Company: CPE 233
-- Engineer: 
-- -------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL is
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
    end CONTROL;

architecture Behavioral of ControlUnit is    
    type state_type is (ST_init, ST_fet, ST_exec);
    signal PS,NS : state_type;
    
    signal sig_OPCODE_7: std_logic_vector (6 downto 0);
begin
    -- concatenate the all opcodes into a 7-bit complete opcode for
    -- easy instruction decoding.
    sig_OPCODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;
    
    sync_p: process (CLK, NS, RST)
    begin
        if (RST = '0') then
            PS <= ST_init;
        elsif (rising_edge(CLK)) then 
            PS <= NS;
        end if;
    end process sync_p;
    
    
    comb_p: process (sig_OPCODE_7, PS, NS)
    begin
        case PS is
        -- STATE: the init cycle ------------------------------------
        when ST_init =>               
            NS <= ST_fet;
            
            -- Initialize all control outputs to non-active states and reset the PC and SP to all zeros.      
            PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '1';	  PC_OE        <= '0'; 	 PC_INC <= '0';		      				
            SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '1';
            RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
            REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
            SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
            C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
            Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
            I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0'; 
            WRITE_STROBE  <= '0';   READ_STROBE <= '0';		 	
        
        -- STATE: the fetch cycle -----------------------------------
        when ST_fet =>
            NS <= ST_exec;
            
            PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0'; 	 PC_INC <= '1';		  			      				
            SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
            RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
            REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
            SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
            C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
            Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
            I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0'; 
            WRITE_STROBE  <= '0';   READ_STROBE <= '0';					
            
        -- STATE: the execute cycle ---------------------------------
        when ST_exec =>
            NS <= ST_fet;
            
            -- Repeat the default block for all variables here, noting that any output values desired to be different
            -- from init values shown below will be assigned in the following case statements for each opcode.
            PC_LD         <= '0';   PC_RESET    <= '0';	   PC_OE        <= '0';      PC_INC <= '0';	    PC_INC <= '0';	  			      				
            SP_LD         <= '0';   SP_MUX_SEL  <= "00";   SP_RESET     <= '0';
            RF_WR         <= '0';   RF_WR_SEL   <= "00";   RF_OE        <= '0';  
            REG_IMMED_SEL <= '0';   ALU_SEL     <= "0000";       			
            SCR_WR        <= '0';   SCR_OE      <= '0';    SCR_ADDR_SEL <= "00";       					
            C_FLAG_SEL    <= "00";  C_FLAG_LD   <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
            Z_FLAG_SEL    <= "00";  Z_FLAG_LD   <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
            I_FLAG_SET    <= '0';   I_FLAG_CLR  <= '0'; 
            WRITE_STROBE  <= '0';   READ_STROBE <= '0';	
            		
            
            if    (sig_OPCODE_7 = "0010000") then -- BRN
                PC_LD <= '1';
            elsif (sig_OPCODE_7 = "0000010") then -- EXOR reg-reg
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0111";
                C_LD <= '1';
                Z_LD <= '1';
            elsif (OPCODE_HI_5  = "10010"  ) then -- EXOR reg-immed
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0111";
                REG_IMMED_SEL <= '1';
                C_LD <= '1';
                Z_LD <= '1';
            elsif (OPCODE_HI_5  = "11001"  ) then -- IN
                RF_WR <= '1';
                RF_WR_SEL <= "11";
            elsif (sig_OPCODE_7 = "0001001") then -- MOV reg-reg
                RF_WR <= '1';
                RF_OE <= '0';
                ALU_SEL <= "1110";
            elsif (OPCODE_HI_5  = "11011"  ) then -- MOV reg-immed
                RF_WR <= '1';
                ALU_SEL <= "1110";
                REG_IMMED_SEL <= '1';
            elsif (OPCODE_HI_5  = "11010"  ) then -- OUT
                RF_OE <= '1';
            else	
                -- repeat the default block here to avoid incompletely specified outputs and hence avoid
                -- the problem of inadvertently created latches within the synthesized system.						
                PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0';    PC_INC <= '0';			      				
                SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
                RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
                REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
                SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
                C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
                Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
                I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0'; 
                WRITE_STROBE  <= '0';   READ_STROBE <= '0';		
            
            end if;
        
        when others => 
            NS <= ST_fet;
            
            -- repeat the default block here to avoid incompletely specified outputs and hence avoid
            -- the problem of inadvertently created latches within the synthesized system.
            PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0';   PC_INC <= '0';		      				
            SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
            RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
            REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
            SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
            C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
            Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
            I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0'; 
            WRITE_STROBE  <= '0';   READ_STROBE <= '0';				 
            
        end case;
    end process comb_p;
end Behavioral;
