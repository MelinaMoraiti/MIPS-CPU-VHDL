library ieee;
use ieee.std_logic_1164.all;

entity MIPS_Testbench is
end MIPS_Testbench;

architecture My_MIPS_Testbench of MIPS_Testbench is

component MIPS port(
  clock,reset  : in std_logic);
end component;

signal test_clock : std_logic;
signal test_reset : std_logic;

begin
  M1: MIPS PORT MAP (clock=>test_clock,reset=>test_reset);
process
  begin
  -- reset is activated for the first cycle.
   test_reset <= '1'; wait for 400 ps;
  -- Reset is deactivated until the program is executed.
   test_reset <= '0'; wait for 9 ns;
end process;
  -- Clock's Period is 400 ps 
  Clock : process
  begin
    test_clock <= '0';
    wait for  200 ps ;
    test_clock<= '1';
    wait for 200 ps;
  end process Clock;
end My_MIPS_Testbench;