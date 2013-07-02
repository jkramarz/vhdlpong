--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:57:31 06/07/2013
-- Design Name:   
-- Module Name:   /home/lenwe/workspace-nighthack/nighthack-1/vhdlpong/main_tb.vhd
-- Project Name:  vga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY main_tb IS
END main_tb;
 
ARCHITECTURE behavior OF main_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         VGA_R : OUT  std_logic_vector(0 to 3);
         VGA_G : OUT  std_logic_vector(0 to 3);
         VGA_B : OUT  std_logic_vector(0 to 3);
         VGA_HSYNC : OUT  std_logic;
         VGA_VSYNC : OUT  std_logic;
         CLK_50MHZ : IN  std_logic;
         ROT_CENTER : IN  std_logic;
         BTN_EAST : IN  std_logic;
         BTN_NORTH : IN  std_logic;
         BTN_SOUTH : IN  std_logic;
         BTN_WEST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_50MHZ : std_logic := '0';
   signal ROT_CENTER : std_logic := '0';
   signal BTN_EAST : std_logic := '0';
   signal BTN_NORTH : std_logic := '0';
   signal BTN_SOUTH : std_logic := '0';
   signal BTN_WEST : std_logic := '0';

 	--Outputs
   signal VGA_R : std_logic_vector(0 to 3);
   signal VGA_G : std_logic_vector(0 to 3);
   signal VGA_B : std_logic_vector(0 to 3);
   signal VGA_HSYNC : std_logic;
   signal VGA_VSYNC : std_logic;

   -- Clock period definitions
   constant CLK_50MHZ_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          VGA_R => VGA_R,
          VGA_G => VGA_G,
          VGA_B => VGA_B,
          VGA_HSYNC => VGA_HSYNC,
          VGA_VSYNC => VGA_VSYNC,
          CLK_50MHZ => CLK_50MHZ,
          ROT_CENTER => ROT_CENTER,
          BTN_EAST => BTN_EAST,
          BTN_NORTH => BTN_NORTH,
          BTN_SOUTH => BTN_SOUTH,
          BTN_WEST => BTN_WEST
        );

   -- Clock process definitions
   CLK_50MHZ_process :process
   begin
		CLK_50MHZ <= '0';
		wait for CLK_50MHZ_period/2;
		CLK_50MHZ <= '1';
		wait for CLK_50MHZ_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_50MHZ_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
