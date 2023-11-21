library ieee;
use ieee.std_logic_1164.all;

entity left_shift_2bit is port(
  shift_in : in std_logic_vector(31 downto 0);
  shift_out : out std_logic_vector(31 downto 0)
);
end left_shift_2bit;

architecture my_left_shift_2bit of left_shift_2bit is
Signal sout : std_logic_vector(31 downto 0);
begin
	shift_out(31 DOWNTO 2) <= shift_in(29 DOWNTO 0);
	shift_out(1 DOWNTO 0) <= (OTHERS => '0');
end my_left_shift_2bit;

