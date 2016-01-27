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
           Z_FLAG : out STD_LOGIC);
    end component;
    
    signal a_s, b_s, sum_s : STD_LOGIC_VECTOR (7 downto 0);
    signal sel_s : STD_LOGIC_VECTOR (3 downto 0);
    signal c_in_s, c_out_s, zero_s : STD_LOGIC;
begin
    
    uut : ALU port map (a_s, b_s, c_in_s, sel_s, sum_s, c_out_s, zero_s);
    
    test : process begin
        -- Test cases take the form (A, B, Cin) => (sum, C_Flag, Z_Flag, time tested)
    
        -- test ADD
        sel_s  <= x"0";
        
        -- (0xAA, 0xAA, 0) => (0x54, 1, 0, 10  ns)
        a_s    <= x"AA";
        b_s    <= x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"54" and c_out_s = '1' and zero_s = '0')
          report "ADD test 0 failed"
          severity note;
        
        -- (0x0A, 0xA0, 1) => (0xAA, 0, 0, 10 ns)
        a_s    <= x"0A";
        b_s    <= x"A0";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = x"AA" and c_out_s = '0' and zero_s = '0')
          report "ADD test 1 failed"
          severity note;

        -- (0xFF, 0x01, 0) => (0x00, 1, 1, 20 ns)
        a_s    <= x"FF";
        b_s    <= x"01";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"00" and c_out_s = '1' and zero_s = '1')
          report "ADD test 2 failed"
          severity note;
        
        -- test ADDC
        sel_s  <= x"1";
          
        -- (0xC8, 0x36, 1) => (0xFF, 0, 0, 30 ns)
        a_s    <= x"C8";
        b_s    <= x"36";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = x"FF" and c_out_s = '0' and zero_s = '0')
          report "ADDC test 0 failed"
          severity note;
        
        -- (0xC8, 0x37, 1) => (0x00, 1, 1, 40 ns)
        a_s    <= x"C8";
        b_s    <= x"37";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = x"00" and c_out_s = '1' and zero_s = '1')
          report "ADDC test 1 failed"
          severity note;
        
        -- test SUB
        sel_s  <= x"2";
        
        -- (0xC8, 0x64, 0) => (0x64, 0, 0, 50 ns)
        a_s    <= x"C8";
        b_s    <= x"64";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"44" and c_out_s = '0' and zero_s = '0')
          report "SUB test 0 failed"
          severity note;
        
        -- (0xC8, 0x64, 1) => (0x64, 0, 0, 60 ns)
        a_s    <= x"C8";
        b_s    <= x"64";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = x"44" and c_out_s = '0' and zero_s = '0')
          report "SUB test 1 failed"
          severity note;
        
        -- (0x64, 0xC8, 0) => (0x64, 1, 0, 70 ns)
        a_s    <= x"64";
        b_s    <= x"C8";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"BC" and c_out_s = '1' and zero_s = '0')
          report "SUB test 2 failed"
          severity note;
          
        -- test SUBC
        sel_s  <= x"3";
        
        -- (0xC8, 0x64, 0)
        a_s    <= x"C8";
        b_s    <= x"64";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"44" and c_out_s = '0' and zero_s = '0')
          report "SUBC test 0 failed"
          severity note;
        
        -- (0xC8, 0x64, 1)
        a_s    <= x"C8";
        b_s    <= x"64";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = x"43" and c_out_s = '0' and zero_s = '0')
          report "SUBC test 1 failed"
          severity note;
        
        -- (0x64, 0xC8, 0)
        a_s    <= x"64";
        b_s    <= x"C8";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"BC" and c_out_s = '1' and zero_s = '0')
          report "SUBC test 2 failed"
          severity note;
        
        -- (0x64, 0xC8, 1)
        a_s    <= x"64";
        b_s    <= x"C8";
        c_in_s <= '1';
        wait for 10ns;
        assert (sum_s = x"BB" and c_out_s = '1' and zero_s = '0')
          report "SUBC test 3 failed"
          severity note;
          
        -- test CMP
        sel_s  <= x"4";
        
        -- (0x64, 0xC8, 1)
        a_s    <= x"64";
        b_s    <= x"C8";
        c_in_s <= '1';
        wait for 10ns;
        assert (c_out_s = '1' and zero_s = '0')
          report "CMP test 0 failed"
          severity note;
        
        -- (0xAA, 0xFF, 0)
        a_s    <= x"AA";
        b_s    <= x"FF";
        c_in_s <= '0';
        wait for 10ns;
        assert (c_out_s = '1' and zero_s = '0')
          report "CMP test 1 failed"
          severity note;
        
        -- (0xFF, 0xAA, 0)
        a_s    <= x"FF";
        b_s    <= x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (c_out_s = '0' and zero_s = '0')
          report "CMP test 2 failed"
          severity note;
          
        -- (0xAA, 0xAA, 0)
        a_s    <= x"AA";
        b_s    <= x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (c_out_s = '0' and zero_s = '1')
          report "CMP test 3 failed"
          severity note;
        
        -- test AND
        sel_s  <= x"5";
        
        -- (0xAA, 0xAA, 0)
        a_s    <= x"AA";
        b_s    <= x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"AA" and c_out_s = '0' and zero_s = '0')
          report "AND test 0 failed"
          severity note;
        
        -- (0x03, 0xAA, 0)
        a_s    <= x"03";
        b_s    <= x"AA";
        c_in_s <= '0';
        wait for 10ns;
        assert (sum_s = x"02" and c_out_s = '0' and zero_s = '0')
          report "AND test 1 failed"
          severity note;
        
        -- test OR
        sel_s  <= x"6";
	
        -- (0xAA, 0xAA, 0)
	a_s    <= x"AA";
	b_s    <= x"AA";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"AA" and c_out_s = '0' and zero_s = '0')
	  report "OR test 0 failed"
	  severity note;

        -- (0x03, 0xAA, 0)
        a_s    <= x"03";
	b_s    <= x"AA";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"AB" and c_out_s = '0' and zero_s = '0')
	  report "OR test 1 failed"
	  severity note;

        -- test XOR
        sel_s  <= x"7";

        -- (0xAA, 0xAA, 0)
        a_s    <= x"AA";
	b_s    <= x"AA";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"00" and c_out_s = '0' and zero_s = '1')
	  report "XOR test 0 failed"
	  severity note;

        -- test TEST
        sel_s  <= x"8";

        -- (0x03, 0xAA, 0)
	a_s    <= x"03";
	b_s    <= x"AA";
	c_in_s <= '0';
	wait for 10ns;
	assert (zero_s = '0')
	  report "TEST test 0 failed"
	  severity notice;

        -- (0xAA, 0xAA, 0)
	a_s    <= x"AA";
	b_s    <= x"AA";
	c_in_s <= '0';
	wait for 10ns;
	assert (zero_s = '0')
	  report "TEST test 1 failed"
	  severity note;

        -- (0x55, 0xAA, 0)
        a_s    <= x"55";
	b_s    <= x"AA";
	c_in_s <= '0';
	wait for 10ns;
	assert (zero_s = '1')
	  report "TEST test 2 failed"
	  severity note;

        -- test LSL
        sel_s  <= x"9";

        -- (0x01, 0x12, 0)
        a_s    <= x"01";
	b_s    <= x"12";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"02" and c_out_s = '0' and zero_s = '0')
	  report "LSL test 0 failed"
	  severity note;

        -- test LSR
        sel_s  <= x"A";

        -- (0x80, 0x33, 0)
	a_s    <= x"80";
	b_s    <= x"33";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"40" and c_out_s = '0' and zero_s = '0')
	  report "LSR test 0 failed"
	  severity note;

        -- (0x80, 0x43, 1)
        a_s    <= x"80";
	b_s    <= x"43";
	c_in_s <= '1';
	wait for 10ns;
	assert (sum_s = x"A0" and c_out_s = '0' and zero_s = '0')
	  report "LSR test 1 failed"
	  severity note;


        -- test ROL
        sel_s  <= x"B";

        -- (0x01, 0xAB, 1)
        a_s    <= x"01";
	b_s    <= x"AB";
	c_in_s <= '1';
	wait for 10ns;
	assert (sum_s = x"02" and c_out_s = '0' and zero_s = '0')
	  report "ROL test 0 failed"
	  severity note;

        -- test ROR
        sel_s  <= x"C";

        -- (0xAA, 0xF2, 0)
	a_s    <= x"AA";
	b_s    <= x"F2";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"55" and c_out_s = '0' and zero_s = '0')
	  report "ROR test 0 failed"
	  severity note;

        -- (0x80, 0x3C, 0)
	a_s    <= x"80";
	b_s    <= x"3C";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"40" and c_out_s = '0' and zero_s = '0')
	  report "ROR test 1 failed"
	  severity note;

        -- (0x80, 0x98, 1)
        a_s    <= x"80";
	b_s    <= x"98";
	c_in_s <= '1';
	wait for 10ns;
	assert (sum_s = x"40" and c_out_s = '0' and zero_s = '0')
	  report "ROR test 2 failed"
	  severity note;

        -- test ASR
        sel_s <= x"D";

        -- (0x80, 0x81, 0)
	a_s    <= x"80";
	b_s    <= x"81";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"C0" and c_out_s = '0' and zero_s = '0')
	  report "ASR test 0 failed"
	  severity note;

        -- (0x40, 0xB2, 0)
        a_s    <= x"40";
	b_s    <= x"B2";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"20" and c_out_s = '0' and zero_s = '0')
	  report "ASR test 1 failed"
	  severity note;

        -- test MOV
        sel_s  <= 0x"E";

        -- (0x50, 0x30, 0)
	a_s    <= x"50";
	b_s    <= x"30";
	c_in_s <= '0';
	wait for 10ns;
	assert (sum_s = x"30" and c_out_s = '0' and zero_s = '0')
	  report "MOV test 0 failed"
	  severity note;

        -- (0x43, 0x22, 1)
	a_s    <= x"43";
	b_s    <= x"22";
	c_in_s <= '1';
	wait for 10ns;
	assert (sum_s = x"22" and c_out_s = '0' and zero_s = '0')
	  report "MOV test 1 failed"
	  severity note;

    end process;

end Behavioral;
