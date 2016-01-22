library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_test is
end counter_test;

architecture Behavioral of counter_test is

    component counter is
        Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
               FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
               INTERRUPT : in STD_LOGIC_VECTOR (9 downto 0);
               PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
               PC_OE : in STD_LOGIC;
               PC_LD : in STD_LOGIC;
               PC_INC : in STD_LOGIC;
               RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
               PC_TRI : out STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;
    
    signal FROM_IMMED_s : STD_LOGIC_VECTOR (9 downto 0) := "1010101010";
    signal FROM_STACK_s : STD_LOGIC_VECTOR (9 downto 0) := "1111100000";
    signal INTERRUPT_s : STD_LOGIC_VECTOR (9 downto 0) := "1111111111";
    signal PC_MUX_SEL_s : STD_LOGIC_VECTOR (1 downto 0);
    signal PC_OE_s, PC_LD_s, PC_INC_s, RST_s : STD_LOGIC;
    signal CLK_s : STD_LOGIC := '1';
    signal PC_COUNT_s, PC_TRI_s : STD_LOGIC_VECTOR (9 downto 0);
    
begin

    uut : counter port map(FROM_IMMED_s, FROM_STACK_s, 
                  INTERRUPT_s, PC_MUX_SEL_s,
                  PC_OE_s, PC_LD_s, PC_INC_s, RST_s, CLK_s, 
                  PC_COUNT_s, PC_TRI_s);

    mClk : process begin
        CLK_s <= not CLK_s;
        wait for 20ns;
    end process;

    test : process begin
        
        PC_OE_s      <= '0';
        PC_LD_s      <= '1';
        PC_INC_s     <= '0';
        RST_s        <= '0';
        
        -- Test 1 => MUX
        PC_MUX_SEL_s <= "00";
        wait for 40ns;
        assert (PC_COUNT_s = "1010101010");
        
        PC_MUX_SEL_s <= "01";
        wait for 40ns;
        assert (PC_COUNT_s = "1111100000");
        
        PC_MUX_SEL_s <= "10";
        wait for 40ns;
        assert (PC_COUNT_s = "1111111111");
        
        -- Test 2 => PC_OE (On timing, should currently be undriven
        PC_OE_s <= '1';
        wait for 40ns;
        assert (PC_TRI_s = "1111111111");
        
        -- Test 3 => PC_LD
        PC_LD_s <= '0';
        PC_MUX_SEL_s <= "00";
        wait for 40ns;
        assert (PC_COUNT_s <= "1111111111");
        
        -- Test 4 => PC_INC
        PC_INC_s <= '1';
        wait for 40ns;
        assert (PC_COUNT_s <= "0000000000");
        
        -- Test 5 => RST
        PC_LD_s <= '1';
        RST_s <= '1';
        wait for 40ns;
        assert (PC_COUNT_s <= "0000000000");
        
        RST_s <= '0';
        
        wait;
        
    end process;

end Behavioral;
