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

entity ControlUnit is
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
    end ControlUnit;

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
        if (RST = '1') then
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
            I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0';    IO_OE        <= '0';
            --WRITE_STROBE  <= '0';   READ_STROBE <= '0';		 	
        
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
            I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0';    IO_OE        <= '0';
            --WRITE_STROBE  <= '0';   READ_STROBE <= '0';					
            
        -- STATE: the execute cycle ---------------------------------
        when ST_exec =>
            NS <= ST_fet;
            
            -- Repeat the default block for all variables here, noting that any output values desired to be different
            -- from init values shown below will be assigned in the following case statements for each opcode.
            PC_LD         <= '0';   PC_MUX_SEL <= "00";    PC_RESET    <= '0';	 PC_OE        <= '0';   PC_INC <= '0';	  			      				
            SP_LD         <= '0';   SP_MUX_SEL  <= "00";   SP_RESET     <= '0';
            RF_WR         <= '0';   RF_WR_SEL   <= "00";   RF_OE        <= '0';  
            REG_IMMED_SEL <= '0';   ALU_SEL     <= "0000";       			
            SCR_WR        <= '0';   SCR_OE      <= '0';    SCR_ADDR_SEL <= "00";       					
            C_FLAG_SEL    <= "00";  C_FLAG_LD   <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
            Z_FLAG_SEL    <= "00";  Z_FLAG_LD   <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
            I_FLAG_SET    <= '0';   I_FLAG_CLR  <= '0';    IO_OE        <= '0';
            --WRITE_STROBE  <= '0';   READ_STROBE <= '0';	
            		
            if    (sig_OPCODE_7 = "0000100") then -- ADD reg-reg
            elsif (OPCODE_HI_5  = "10100"  ) then -- ADD reg-immed
            elsif (sig_OPCODE_7 = "0000101") then -- ADDC reg-reg
            elsif (OPCODE_HI_5  = "10101"  ) then -- ADDC reg-immed
            elsif (sig_OPCODE_7 = "0000000") then -- AND reg-reg
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0101";
                Z_FLAG_LD <= '1';
            elsif (OPCODE_HI_5  = "1000"   ) then -- AND reg-immed
            elsif (sig_OPCODE_7 = "0100100") then -- ASR reg-reg
            elsif (sig_OPCODE_7 = "0010101") then -- BRCC
            elsif (sig_OPCODE_7 = "0010100") then -- BRCS
            elsif (sig_OPCODE_7 = "0010010") then -- BREQ
                if (Z = '1') then
                    PC_LD <= '1';
                end if;
            elsif (sig_OPCODE_7 = "0010000") then -- BRN
                PC_LD <= '1';
            elsif (sig_OPCODE_7 = "0010011") then -- BRNE
                if (Z = '0') then
                    PC_LD <= '1';
                end if;
            elsif (sig_OPCODE_7 = "0010001") then -- CALL
                PC_LD <= '1';
                PC_OE <= '1';
                SP_LD <= '1';
                SCR_ADDR_SEL <= "11";
                SCR_WR <= '1';
            elsif (sig_OPCODE_7 = "0110000") then -- CLC
            elsif (sig_OPCODE_7 = "0110101") then -- CLI
            elsif (sig_OPCODE_7 = "0001000") then -- CMP reg-reg
                RF_OE <= '1';
                ALU_SEL <= "0100";
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (OPCODE_HI_5  = "11000"  ) then -- CMP reg-immed
                RF_OE <= '1';
                ALU_SEL <= "0100";
                REG_IMMED_SEL <= '1';
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (sig_OPCODE_7 = "0000010") then -- EXOR reg-reg
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0111";
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (OPCODE_HI_5  = "10010"  ) then -- EXOR reg-immed
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0111";
                REG_IMMED_SEL <= '1';
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (OPCODE_HI_5  = "11001"  ) then -- IN
                RF_WR <= '1';
                RF_WR_SEL <= "11";
            elsif (sig_OPCODE_7 = "0001010") then -- LD reg-reg
            elsif (OPCODE_HI_5  = "11100"  ) then -- LD reg-immed
            elsif (sig_OPCODE_7 = "0100000") then -- LSL
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "1001";
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (sig_OPCODE_7 = "0100001") then -- LSR
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "1010";
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (sig_OPCODE_7 = "0001001") then -- MOV reg-reg
                RF_WR <= '1';
                RF_OE <= '0';
                ALU_SEL <= "1110";
            elsif (OPCODE_HI_5  = "11011"  ) then -- MOV reg-immed
                RF_WR <= '1';
                ALU_SEL <= "1110";
                REG_IMMED_SEL <= '1';
            elsif (sig_OPCODE_7 = "0000001") then -- OR reg-reg
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0110";
                Z_FLAG_LD <= '1';
            elsif (OPCODE_HI_5  = "10001"  ) then -- OR reg-immed
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0110";
                REG_IMMED_SEL <= '1';
                Z_FLAG_LD <= '1';
            elsif (OPCODE_HI_5  = "11010"  ) then -- OUT
                RF_OE <= '1';
                IO_OE <= '1';
            elsif (sig_OPCODE_7 = "0100110") then -- POP
            elsif (sig_OPCODE_7 = "0100101") then -- PUSH
            elsif (sig_OPCODE_7 = "0110010") then -- RET
                SCR_ADDR_SEL <= "10";
                SCR_OE <= '1';
                PC_MUX_SEL <= "01";
                PC_LD <= '1';
                SP_MUX_SEL <= "11";
                SP_LD <= '1';
            elsif (sig_OPCODE_7 = "0110110") then -- RETID
            elsif (sig_OPCODE_7 = "0110111") then -- RETIE
            elsif (sig_OPCODE_7 = "0100010") then -- ROL
            elsif (sig_OPCODE_7 = "0100011") then -- ROR
            elsif (sig_OPCODE_7 = "0110001") then -- SEC
                C_FLAG_SET <= '1';
            elsif (sig_OPCODE_7 = "0110100") then -- SEI
            elsif (sig_OPCODE_7 = "0001011") then -- ST reg-reg
            elsif (OPCODE_HI_5  = "11101"  ) then -- ST reg-immed
            elsif (sig_OPCODE_7 = "0000110") then -- SUB reg-reg
            elsif (OPCODE_HI_5  = "10110"  ) then -- SUB reg-immed
                RF_WR <= '1';
                RF_OE <= '1';
                ALU_SEL <= "0010";
                REG_IMMED_SEL <= '1';
                C_FLAG_LD <= '1';
                Z_FLAG_LD <= '1';
            elsif (sig_OPCODE_7 = "0000111") then -- SUBC reg-reg
            elsif (OPCODE_HI_5  = "10111"  ) then -- SUBC reg-immed
            elsif (sig_OPCODE_7 = "0000011") then -- TEST reg-reg
            elsif (OPCODE_HI_5  = "10011"  ) then -- TEST reg-immed
            elsif (sig_OPCODE_7 = "0101000") then -- WSP                
            else	
                -- repeat the default block here to avoid incompletely specified outputs and hence avoid
                -- the problem of inadvertently created latches within the synthesized system.						
                PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0';   PC_INC <= '0';			      				
                SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
                RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
                REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
                SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
                C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
                Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
                I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0';    IO_OE        <= '0';
                --WRITE_STROBE  <= '0';   READ_STROBE <= '0';		            
            end if;
        
        when others => 
            NS <= ST_fet;
            
            -- repeat the default block here to avoid incompletely specified outputs and hence avoid
            -- the problem of inadvertently created latches within the synthesized system.
            PC_LD         <= '0';   PC_MUX_SEL <= "00";   PC_RESET <= '0';	  PC_OE        <= '0';  PC_INC <= '0';		      				
            SP_LD         <= '0';   SP_MUX_SEL <= "00";   SP_RESET <= '0';
            RF_WR         <= '0';   RF_WR_SEL  <= "00";   RF_OE    <= '0';  
            REG_IMMED_SEL <= '0';   ALU_SEL    <= "0000";       			
            SCR_WR        <= '0';   SCR_OE     <= '0';    SCR_ADDR_SEL <= "00";       					
            C_FLAG_SEL    <= "00";  C_FLAG_LD  <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  SHAD_C_LD <= '0';   				
            Z_FLAG_SEL    <= "00";  Z_FLAG_LD  <= '0';    Z_FLAG_SET   <= '0';  Z_FLAG_CLR <= '0';  SHAD_Z_LD <= '0';   				
            I_FLAG_SET    <= '0';   I_FLAG_CLR <= '0';    IO_OE        <= '0';
            --WRITE_STROBE  <= '0';   READ_STROBE <= '0';				 
            
        end case;
    end process comb_p;
end Behavioral;
