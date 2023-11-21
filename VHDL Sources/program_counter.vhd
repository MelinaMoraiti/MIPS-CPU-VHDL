library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------
entity program_counter is port (
        in_pc : in std_logic_vector(31 downto 0);
        out_pc : out std_logic_vector(31 downto 0);
        clock : in std_logic;
        reset : in std_logic);
end program_counter;
----------------------------------------------------
architecture behavior of program_counter is
begin
  process(reset,clock)
  begin
    if rising_edge (clock) then
      out_pc <= in_pc;
    end if;
    if (reset='1') then 
      out_pc <= std_logic_vector(to_signed(-1,32));
    end if;
end process;
end behavior;
------------------------------------------------------