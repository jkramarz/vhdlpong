----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:22:49 05/24/2013 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_unsigned.all;

use ieee.numeric_std.all; 


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( 
			  VGA_R : out STD_LOGIC_VECTOR (0 to 3);
			  VGA_G : out STD_LOGIC_VECTOR (0 to 3);
			  VGA_B : out STD_LOGIC_VECTOR (0 to 3);
			  VGA_HSYNC : out STD_LOGIC;
			  VGA_VSYNC : out STD_LOGIC;
			  CLK_FPGA_N : in	STD_LOGIC;
			  CLK_FPGA_P : in	STD_LOGIC;
--			  CLK_50MHZ : in STD_LOGIC;
			  
			  ROT_CENTER : in STD_LOGIC;
			  
			  BTN_EAST : in STD_LOGIC;
			  BTN_NORTH : in STD_LOGIC;
			  BTN_SOUTH : in STD_LOGIC;
			  BTN_WEST : in STD_LOGIC
			  );
end main;

architecture Behavioral of main is

component vga_controller_640_60 
port(
   rst         : in std_logic;
   pixel_clk   : in std_logic;

   HS          : out std_logic;
   VS          : out std_logic;
   hcount      : out std_logic_vector(10 downto 0);
   vcount      : out std_logic_vector(10 downto 0);
   blank       : out std_logic
);
end component;

COMPONENT dcm_200_to_25
	PORT(
		CLKIN_N_IN : IN std_logic;
		CLKIN_P_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKDV_OUT : OUT std_logic;
		CLKIN_IBUFGDS_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

--	COMPONENT dcm_50_to_25
--	PORT(
--		CLKIN_IN : IN std_logic;
--		RST_IN : IN std_logic;          
--		CLKDV_OUT : OUT std_logic;
--		CLKIN_IBUFG_OUT : OUT std_logic;
--		CLK0_OUT : OUT std_logic
--		);
--	END COMPONENT;
	
signal clk_25mhz, reset, blank : std_logic;
signal vcount, hcount : std_logic_vector(10 downto 0);

signal rightPosition, leftPosition : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(200, 11));

signal ballH : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(315, 11));
signal ballV : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(235, 11));

signal directionH, directionV : std_logic := '0';

signal clk_95hz : std_logic :=  '0';
signal counter : std_logic_vector(16 downto 0);

begin

reset <= ROT_CENTER;

vga : vga_controller_640_60
port map(
	rst => reset,
	pixel_clk => clk_25mhz,
	HS => VGA_HSYNC,
	VS => VGA_VSYNC,
	hcount => hcount, 
	vcount => vcount,
	blank => blank
);


Inst_dcm_200_to_25: dcm_200_to_25 PORT MAP(
		CLKIN_N_IN => CLK_FPGA_N,
		CLKIN_P_IN => CLK_FPGA_P,
		RST_IN => reset,
		CLKDV_OUT => clk_25mhz,
		CLKIN_IBUFGDS_OUT => open,
		CLK0_OUT => open,
		LOCKED_OUT => open
	);


--
--	Inst_dcm_50_to_25: dcm_50_to_25 PORT MAP(
--		CLKIN_IN => CLK_50MHZ,
--		RST_IN => reset,
--		CLKDV_OUT => clk_25mhz,
--		CLKIN_IBUFG_OUT => open,
--		CLK0_OUT => open
--	);





process(clk_25mhz, counter) begin
	if rising_edge(clk_25mhz) then
		counter <= counter + 1;
		if counter = std_logic_vector(to_unsigned(0, 16)) then
			clk_95hz <= '1';
		else
			clk_95hz <= '0';
		end if;
	end if;
end process;

process(clk_25mhz, BTN_NORTH, BTN_SOUTH, BTN_WEST, BTN_EAST, clk_95hz, ballH, ballV, leftPosition, rightPosition, directionH, directionV) begin
	if rising_edge(clk_25mhz) then
		if clk_95hz = '1' then
			if BTN_NORTH = '1' then
				rightPosition <= rightPosition - 1;
			elsif BTN_EAST = '1' then
				rightPosition <= rightPosition + 1;
			end if;
			
			if BTN_WEST = '1' then
				leftPosition <= leftPosition - 1;
			elsif BTN_SOUTH = '1' then
				leftPosition <= leftPosition + 1;
			end if;
			
			
			
			-- odbicie od paletki lewej
			if ballH = 40 and ballV > 8 + leftPosition and ballV < 18 + 50 + leftPosition then

					directionH <= '0';
				
				
				if directionV = '1' then
					directionV <= '0';
				else
					directionV <= '1';
				end if;
			end if;
			
			-- odbicie od paletki prawej
			if ballH = 590 and ballV > 8 + rightPosition and ballV < 18 + 50 + rightPosition then
	
		
					directionH <= '1';

				
				if directionV = '1' then
					directionV <= '0';
				else
					directionV <= '1';
				end if;
			end if;
			
			-- lewo prawo ruch pileczki
			if directionH = '1' then
				if ballH > 1 then
					ballH <= ballH - 1;
				else
					directionH <= '0';	
					leftPosition <= std_logic_vector(to_unsigned(200, 11));
					rightPosition <= std_logic_vector(to_unsigned(200, 11));
					ballV <= std_logic_vector(to_unsigned(235, 11));
					ballH <= std_logic_vector(to_unsigned(315, 11));
				end if;
			else
				if ballH < 640 then
					ballH <= ballH + 1;
				else
					directionH <= '1';
					leftPosition <= std_logic_vector(to_unsigned(200, 11));
					rightPosition <= std_logic_vector(to_unsigned(200, 11));
					ballV <= std_logic_vector(to_unsigned(235, 11));
					ballH <= std_logic_vector(to_unsigned(315, 11));
				end if;
			end if;
			
			-- gora dol ruch puleczki
			if directionV = '1' then
				if ballV > 10 then
					ballV <= ballV - 1;
				else
					-- odbicie od gornej krawedzi
					directionV <= '0';
				end if;
			else
				if ballV < 460 then
					ballV <= ballV + 1;
				else
					-- odbicie od dolnej krawedzi
					directionV <= '1';
				end if;
			end if;
			
		end if;
		
	end if;
end process;

process(blank, hcount, vcount, ballV, ballH, leftPosition, rightPosition) begin
	if blank = '1' then
		VGA_R <= "0000";
		VGA_G <= "0000";
		VGA_B <= "0000";
	else
		if
			-- border left + right
--			(
--				(hcount < 10) or (hcount > 630)
--			)
--			or
			-- border top + bottom
			(
				(vcount < 10) or (vcount > 470)
			)
			-- 
			
			-- left paddle
			or
			
			(
				(hcount >= 30 and hcount < 40) 
				and
				(vcount >= 18 + leftPosition) and (vcount < 18 + 50 + leftPosition)
			)
			
			--right paddle
			or
			
			(
				(hcount >= 600 and hcount < 610) 
				and
				(vcount >= 18 + rightPosition) and (vcount < 18 + 50 + rightPosition)
			)
			
			or
			
			--ball
			(
				hcount >= ballH and hcount < ballH + 10
				and
				vcount >= ballV and vcount < ballV + 10
			)
			
		then
			VGA_G <= "1111";
			VGA_B <= "1111";
			VGA_R <= "1111";
		else
			VGA_G <= "0000";
			VGA_B <= "0000";
			VGA_R <= "0000";
		end if;
		
	end if;
end process;

end Behavioral;

