----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:14:07 04/05/2013 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           DATA : out  STD_LOGIC_VECTOR (16 downto 0));
end counter;

architecture Behavioral of counter is
	signal ctr : STD_LOGIC_VECTOR (20 downto 0); 
begin
		process(CLK) begin
			if RST = '1' then
				ctr <= (others => '0');
			elsif rising_edge(CLK) then
				ctr <= ctr + '1';
			end if;
		end process;
		DATA <= ctr;
		
end Behavioral;

