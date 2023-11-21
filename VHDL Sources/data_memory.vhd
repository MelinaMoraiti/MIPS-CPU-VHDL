
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is port(
  mem_write,mem_read,clock,reset : in std_logic;
  in_ram_addr,write_data : in std_logic_vector(31 downto 0);
  out_ram : out std_logic_vector(31 downto 0)
);
end data_memory;

architecture my_data_memory of data_memory is
  type data_mem is array (0 to 15) of std_logic_vector (31 downto 0);
  signal RAM: data_mem :=((others=> (others=>'0')));
begin
  process(clock)
    begin
      if rising_edge(clock) then
        if (mem_write = '1') then
         RAM (to_integer(unsigned(in_ram_addr))) <= write_data;
        end if;
      end if;
      if (mem_read='1') then
        out_ram<=RAM(to_integer(unsigned(in_ram_addr))) ;
      end if;
  end process;  
end my_data_memory;