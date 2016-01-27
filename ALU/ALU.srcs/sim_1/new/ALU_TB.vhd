library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is
    component ALU Port ( 
           A      : in  STD_LOGIC_VECTOR (7 downto 0);
           B      : in  STD_LOGIC_VECTOR (7 downto 0);
           C_IN   : in  STD_LOGIC;
           Sel    : in  STD_LOGIC_VECTOR (3 downto 0);
           SUM    : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC));
    end component;
    
    signal a_s, b_s, sum_s : STD_LOGIC_VECTOR (7 downto 0);
    signal sel_s : STD_LOGIC_VECTOR (3 downto 0);
    signal c_in_s, c_out_s, zero_s : STD_LOGIC;
begin
    
    uut : ALU port map (a_s, b_s, c_in_s, sel_s, sum_s, c_out_s, zero_s);
    
    test : process begin
        -- Test cases take the form (A, B, Cin) => (sum, C_Flag, Z_Flag, time tested)
    
        -- test ADD
        sel_s  <= 0x'0';
        
        -- (0xAA, 0xAA, 0) => (0x54, 1, 0, 10  ns)
        a_s    <= 0x"AA";
        b_s    <= 0x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"54" and c_out_s = '1' and zero_s = '0')
          report "ADD test 0 failed"
          severity note;
        
        -- (0x0A, 0xA0, 1) => (0xAA, 0, 0, 10 ns)
        a_s    <= 0x"0A";
        b_s    <= 0x"A0";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = 0x"AA" and c_out_s = '0' and zero_s = '0')
          report "ADD test 1 failed"
          severity note;

        -- (0xFF, 0x01, 0) => (0x00, 1, 1, 20 ns)
        a_s    <= 0x"FF";
        b_s    <= 0x"01";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"00" and c_out_s = '1' and zero_s = '1')
          report "ADD test 2 failed"
          severity note;
        
        -- test ADDC
        sel_s  <= 0x'1';
          
        -- (0xC8, 0x36, 1) => (0xFF, 0, 0, 30 ns)
        a_s    <= 0x"C8";
        b_s    <= 0x"36";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = 0x"FF" and c_out_s = '0' and zero_s = '0')
          report "ADDC test 0 failed"
          severity note;
        
        -- (0xC8, 0x37, 1) => (0x00, 1, 1, 40 ns)
        a_s    <= 0x"C8";
        b_s    <= 0x"37";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = 0x"00" and c_out_s = '1' and zero_s = '1')
          report "ADDC test 1 failed"
          severity note;
        
        -- test SUB
        sel_s  <= 0x'2';
        
        -- (0xC8, 0x64, 0) => (0x64, 0, 0, 50 ns)
        a_s    <= 0x"C8";
        b_s    <= 0x"64";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"44" and c_out_s = '0' and zero_s = '0')
          report "SUB test 0 failed"
          severity note;
        
        -- (0xC8, 0x64, 1) => (0x64, 0, 0, 60 ns)
        a_s    <= 0x"C8";
        b_s    <= 0x"64";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = 0x"44" and c_out_s = '0' and zero_s = '0')
          report "SUB test 1 failed"
          severity note;
        
        -- (0x64, 0xC8, 0) => (0x64, 1, 0, 70 ns)
        a_s    <= 0x"64";
        b_s    <= 0x"C8";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"BC" and c_out_s = '1' and zero_s = '0')
          report "SUB test 2 failed"
          severity note;
          
        -- test SUBC
        sel_s <= 0x'3';
        
        -- (0xC8, 0x64, 0)
        a_s    <= 0x"C8";
        b_s    <= 0x"64";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"44" and c_out_s = '0' and zero_s = '0')
          report "SUBC test 0 failed"
          severity note;
        
        -- (0xC8, 0x64, 1)
        a_s    <= 0x"C8";
        b_s    <= 0x"64";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = 0x"43" and c_out_s = '0' and zero_s = '0')
          report "SUBC test 1 failed"
          severity note;
        
        -- (0x64, 0xC8, 0)
        a_s    <= 0x"64";
        b_s    <= 0x"C8";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"BC" and c_out_s = '1' and zero_s = '0')
          report "SUBC test 2 failed"
          severity note;
        
        -- (0x64, 0xC8, 1)
        a_s    <= 0x"64";
        b_s    <= 0x"C8";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = 0x"BB" and c_out_s = '1' and zero_s = '0')
          report "SUBC test 3 failed"
          severity note;
          
        -- test CMP
        sel_s <= 0x'4';
        
        -- (0x64, 0xC8, 1)
        a_s    <= 0x"64";
        b_s    <= 0x"C8";
        c_in_s <= '1';
        wait for 10ns;
        assert (c_out_s = '1' and zero_s = '0')
          report "CMP test 0 failed"
          severity note;
        
        -- (0xAA, 0xFF, 0)
        a_s    <= 0x"AA";
        b_s    <= 0x"FF";
        c_in_s <= '0';
        wait for 10ns;
        assert (c_out_s = '1' and zero_s = '0')
          report "CMP test 1 failed"
          severity note;
        
        -- (0xFF, 0xAA, 0)
        a_s    <= 0x"FF";
        b_s    <= 0x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (c_out_s = '0' and zero_s = '0')
          report "CMP test 2 failed"
          severity note;
          
        -- (0xAA, 0xAA, 0)
        a_s    <= 0x"AA";
        b_s    <= 0x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (c_out_s = '0' and zero_s = '1')
          report "CMP test 3 failed"
          severity note;
        
        -- test AND
        sel_s <= 0x'5';
        
        -- (0xAA, 0xAA, 0)
        a_s    <= 0x"AA";
        b_s    <= 0x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"AA" and c_out_s = '0' and zero_s = '0')
          report "AND test 0 failed"
          severity note;
        
        -- (0x03, 0xAA, 0)
        a_s    <= 0x"03";
        b_s    <= 0x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = 0x"02" and c_out_s = '0' and zero_s = '0')
          report "AND test 1 failed"
          severity note;
        
        -- test OR
        
        -- (0xAA, 0xAA, 0)
        -- (0x03, 0xAA, 0)
        
        -- test XOR
        
        -- (0xAA, 0xAA, 0)
        
        -- test TEST
        
        -- (0x03, 0xAA, 0)
        -- (0xAA, 0xAA, 0)
        -- (0x55, 0xAA, 0)
        
        -- test LSL
        
        -- (0x01, 0x12, 0)
        
        -- test LSR
        
        -- (0x80, 0x33, 0)
        -- (0x80, 0x43, 1)
        
        -- test ROL
        
        -- (0x01, 0xAB, 1)
        
        -- test ROR
        
        -- (0xAA, 0xF2, 0)
        -- (0x80, 0x3C, 0)
        -- (0x80, 0x98, 1)
        
        -- test ASR
        
        -- (0x80, 0x81, 0)
        -- (0x40, 0xB2, 0)
        
        -- test MOV
        
        -- (0x50, 0x30, 0)
        -- (0x43, 0x22, 1)












    end process;

end Behavioral;
