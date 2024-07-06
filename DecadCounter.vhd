  
----------------------------------------------------------------------------------
-------------------------CODE STARTS HERE-------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCD_Counter is

port(CLK_100: in std_logic; 
	SW: in std_logic;
	reset: in std_logic;
	clk_led: out std_logic;
	B: out std_logic_vector(3 downto 0));
	LED_out: out std_logic_vector(6 downto 0);
	Common: out std_logic;
end entity;


architecture Behavior of BCD_Counter is

signal sig_1, CLK_5: std_logic := '0';
signal counter_reg: std_logic_vector(3 downto 0) := "0000";
signal counter_int: integer range 0 to 9 := 0;

begin
	
	DISPLAYS COMMON PIN:
	Common <= '0';
	
	AND_GATE: ------------------------------------------------
	sig_1 <= CLK_100 and SW;
	clk_led <= CLK_5;
	
	CLOCK: ------------------------------------------------
	process(sig_1) 
	
	variable counter: integer := 0;
	
	begin
		
		if rising_edge(sig_1) then		
			if counter < 40000000 then 		
			 counter := counter + 1;			
			else			
			 counter := 0;
			 CLK_5 <= not CLK_5;			
			end if;		
		end if;
		
	end process;
	
	BCD_COUNTER: ------------------------------------------------
	process(CLK_5, reset)
	begin
		if reset = '1' then
            counter_reg <= "0000";  -- Reset the counter to 0
        elsif rising_edge(CLK_5) then
            if counter_int = 9 then
                counter_int <= 0;  -- Reset the counter to 0 when it reaches 9
            else
                counter_int <= counter_int + 1;  -- Increment the counter
            end if;
        end if;
	
	end process;
	B <= std_logic_vector(to_unsigned(counter_int, B'length));
	
	process(B)
		begin
		case B is
			when "0000" => LED_out <= "0000001"; -- "0"
			when "0001" => LED_out <= "1001111"; -- "1"
			when "0010" => LED_out <= "0010010"; -- "2"
			when "0011" => LED_out <= "0000110"; -- "3"
			when "0100" => LED_out <= "1001100"; -- "4"
			when "0101" => LED_out <= "0100100"; -- "5"
			when "0110" => LED_out <= "0100000"; -- "6"
			when "0111" => LED_out <= "0001111"; -- "7"
			when "1000" => LED_out <= "0000000"; -- "8"
			when "1001" => LED_out <= "0000100"; -- "9"
			when others => LED_out <= "0000000";
		end case;
	end process;

end Behavior;

-------------------------CODE ENDS HERE-------------------------
------------------------------------------------------------------
-- For I/O port planning, consider the folloing constraints file 
set_property PACKAGE_PIN J13 [get_ports {B[2]}]
set_property PACKAGE_PIN N14 [get_ports {B[3]}]
set_property PACKAGE_PIN H17 [get_ports {B[0]}]
set_property PACKAGE_PIN K15 [get_ports {B[1]}]
set_property PACKAGE_PIN J15 [get_ports SW]
set_property PACKAGE_PIN L16 [get_ports reset]
set_property PACKAGE_PIN V11 [get_ports clk_led]
set_property PACKAGE_PIN E3 [get_ports CLK_100]
set_property IOSTANDARD LVCMOS33 [get_ports {B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_100]
set_property IOSTANDARD LVCMOS33 [get_ports clk_led]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports SW]
------------------------------------------------------------------


