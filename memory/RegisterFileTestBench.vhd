--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:59:22 01/11/2012
-- Design Name:   
-- Module Name:   F:/repos/cpe-233-test-benches/lab-4-arc/RegisterFileTestBench.vhd
-- Project Name:  lab-4-arc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegisterFile
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- Runtime must be set to 700ns for proper execution
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY RegisterFileTestBench IS
END RegisterFileTestBench;
 
ARCHITECTURE behavior OF RegisterFileTestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegisterFile
    PORT(
         D_IN : IN  std_logic_vector(7 downto 0);
         DX_OUT : OUT  std_logic_vector(7 downto 0);
         DY_OUT : OUT  std_logic_vector(7 downto 0);
         ADRX : IN  std_logic_vector(4 downto 0);
         ADRY : IN  std_logic_vector(4 downto 0);
         DX_OE : IN  std_logic;
         WE : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
   -- test signals
	signal data_x_exp : std_logic_vector(7 downto 0) := x"00";
	signal data_y_exp : std_logic_vector(7 downto 0) := x"00";
	

   --Inputs
   signal D_IN_tb : std_logic_vector(7 downto 0) := (others => '0');
   signal ADRX_tb : std_logic_vector(4 downto 0) := (others => '0');
   signal ADRY_tb : std_logic_vector(4 downto 0) := (others => '0');
   signal DX_OE_tb : std_logic := '0';
   signal WE_tb : std_logic := '0';
   signal CLK_tb : std_logic := '0';

 	--Outputs
   signal DX_OUT_tb : std_logic_vector(7 downto 0);
   signal DY_OUT_tb : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegisterFile PORT MAP (
          D_IN => D_IN_tb,
          DX_OUT => DX_OUT_tb,
          DY_OUT => DY_OUT_tb,
          ADRX => ADRX_tb,
          ADRY => ADRY_tb,
          DX_OE => DX_OE_tb,
          WE => WE_tb,
          CLK => CLK_tb
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK_tb <= '0';
		wait for CLK_period/2;
		CLK_tb <= '1';
		wait for CLK_period/2;
   end process;
	

	-- verify memory
	VERIFY_process :process
	variable I : integer range 0 to 32 := 0;

	begin
		--Write to RegisterFile
		ADRX_tb<="00000";
		D_IN_tb<="00000000";
		wait for 4ns;
		WE_tb <= '1'; --togle high before rising edge
		wait for 1ns;
		while( I < 32) loop
			wait for 1ns;
			WE_tb <= '0'; --drop after rising edge
			wait for 1ns;
			ADRX_tb <= ADRX_tb + 1; --prepare next address and data
			wait for 1ns;
			D_IN_tb <= D_IN_tb +2;
			wait for 6ns;
			I := I+1;
			if(I <32) then
				WE_tb <= '1';
			end if;
			wait for 1ns;
		end loop;
		
		WE_tb <= '0';
		DX_OE_tb <= '1';
		wait for 75ns; --no reason, just like to start at a nice number such as 400ns...
		
		-- Read from RegisterFile
		I := 0;
		-- set initial values
		data_x_exp <= "00000000";
		data_y_exp <= "00000010";
		ADRX_tb <= "00000";
		ADRY_tb <= "00001";
		-- loop through all memory locations. NOTE: can read two at once
		while ( I < 16) loop
			WE_tb <= '0';
			wait for 1ns;

			if not(DX_OUT_tb = data_x_exp) then
				report "error with data X at t= " & time'image(now) 
				severity failure;
			else 
				report "data X at t= " & time'image(now) & " is good"
					severity note;
			end if;
		
			if not(DY_OUT_tb = data_y_exp) then
				report "error with data Y at t= " & time'image(now) 
				severity failure;
			else 
				report "data Y at t= " & time'image(now) & " is good"
					severity note;
			end if;	
			wait for 1ns;	
			--get new values
			data_x_exp <= data_x_exp + 4 ; --add 4 because each location increases by 2, and you're increasing by 2 memory locations
			data_y_exp <= data_y_exp + 4 ;
			ADRX_tb <= ADRX_tb + 2;
			ADRY_tb <= ADRY_tb + 2;
			
			wait for 8ns;
			I := I + 1; 
		end loop;
		
		wait for 40ns; -- again, just lining up for a nice start time of 600ns.
		
		-- Test OE pin of RegisterFile
		DX_OE_tb <= '0';
		wait for 50ns;
		if not (DX_OUT_tb = "ZZZZZZZZ") then 
			report "error with OE pin"
			severity failure;
		else
			report "OE pin test 1 passed"
			severity note;
		end if;
		DX_OE_tb <= '1';
		wait for 50ns;
			if (DX_OUT_tb = "ZZZZZZZZ") then 
			report "error with OE pin"
			severity failure;
		else
			report "OE pin test 2 passed"
			severity note;
		end if;
		report "Error checking complete at 700ns" severity note;
		
	end process VERIFY_process;
	

END;
