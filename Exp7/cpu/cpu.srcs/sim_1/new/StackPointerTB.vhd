library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity StackPointerTB is
end StackPointerTB;

architecture Test of StackPointerTB is
    
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
    
    signal D_IN_BUS_S, D_OUT_S, D_OUT_DEC : STD_LOGIC_VECTOR (7 downto 0);
    signal SEL_S                          : STD_LOGIC_VECTOR (1 downto 0);
    signal LD_S, RST_S, CLK_S             : STD_LOGIC;
    
begin
    
    -- Create a stack pointer
    sp : StackPointer port map (D_IN_BUS_S, SEL_S, LD_S, RST_S,
                                CLK_S, D_OUT_S, D_OUT_DEC_S);
    
    -- Create a clock signal
    clock : process begin 
        CLK_S <= '0';
        wait for 10ns;
        CLK_S <= '1';
        wait for 10ns;
    end process;

    -- Test away
    test : process begin
        
	-- Test initial loading
	D_IN_BUS  <= x"10";
	SEL       <= "00";
	LD        <= '1';
	RST       <= '0';
        assert (D_OUT = x"10" and D_OUT_DEC = x"09")
	   report "Test 0 failed" severity note;
	
    end process;

end Test;
