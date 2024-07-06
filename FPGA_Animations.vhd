----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 09:30:01 AM
-- Design Name: 
-- Module Name: Dot_Matrix - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sq_Animation is

	port(

	CLK_100M: in std_logic;
	send_to_column: out std_logic_vector(7 downto 0);
	send_to_row: out std_logic_vector(7 downto 0)

);

end entity;

architecture Behavior of Sq_Animation is

	signal CLK_100: std_logic := '0';
	signal Frame_rate: std_logic := '0';

	type disp_dot is array(0 to 7) of std_logic_vector(7 downto 0);
	signal pattern_array: disp_dot := (x"00", x"00", x"00", x"18", x"18", x"00", x"00", x"00", -- Frame 1
	x"00", x"00", x"3c", x"24", x"24", x"3c", x"00", x"00", -- Frame 2
	x"00", x"7e", x"42", x"42", x"42", x"42", x"7e", x"00", -- Frame 3
	x"ff", x"81", x"81", x"81", x"81", x"81", x"81", x"ff" -- Frame 4
	); -- Square Frames
	
	-- Note: Vist https://xantorohara.github.io/led-matrix-editor/#0000000000000000|66667e7e66663c18 and generate HEX value array for each frame. 
	-- Paste the array frame by frame as shown above.

	signal state_var: integer range 0 to 7 := 0;
	
	variable offset: integer range 0 to 31 := 0;

begin

CLOCK_100HZ:

	process(CLK_100M)
	
	variable counter: integer range 0 to 10e4;
	
	begin
		if rising_edge(CLK_100M) then
			if counter < 10e4 then
				counter := counter + 1;
				CLK_100 <= '0';
			else			
			 counter := 0;
			 CLK_100 <= '1';
			end if;
		end if;
	end process;
	
FRAME_FREQ:

	process(CLK_100M)
	
	variable counter_f: integer range 0 to 50e6;
	
	begin
	if rising_edge(CLK_100M) then
			if counter_f < 50e6 then
				counter_f := counter_f + 1;
				Frame_rate <= '0';
			else			
			 counter_f := 0;
			 Frame_rate <= '1';
			end if;
		end if;
	end process;

STATE_TRANSION:

		process(CLK_100)
		
		begin 
			if rising_edge(CLK_100) then
				if(state_var < 7) then
					state_var <= state_var + 1;
				else
					state_var <= 0;
				end if;
			end if;
		end process;
		
MATRIX:

	process(CLK_100)
	
	begin
			
			case state_var is
				when 0 =>
					send_to_column <= pattern_array(offset);
					send_to_row <= "11111110";
				when 1 =>
					send_to_column <= pattern_array(offset + 1);
					send_to_row <= "11111101";
				when 2 =>
					send_to_column <= pattern_array(offset + 2);
					send_to_row <= "11111011";
				when 3 =>
					send_to_column <= pattern_array(offset + 3);
					send_to_row <= "11110111";
				when 4 =>
					send_to_column <= pattern_array(offset + 4);
					send_to_row <= "11101111";
				when 5 =>
					send_to_column <= pattern_array(offset + 5);
					send_to_row <= "11011111";
				when 6 =>
					send_to_column <= pattern_array(offset + 6);
					send_to_row <= "10111111";
				when 7 =>
					send_to_column <= pattern_array(offset + 7);
					send_to_row <= "01111111";
			end case;
			
	end process;
	
FRAME_CHANGE:

	process(Frame_rate)
	
	begin
		if rising_edge(Frame_rate) then
				if(offset > 31) then
					offset <= 0;
				else
					offset <= offset + 8;
				end if;
			end if;
	end process;
	
end Behavior;
