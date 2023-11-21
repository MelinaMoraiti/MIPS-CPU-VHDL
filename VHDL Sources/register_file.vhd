library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is port (
    reset,clock: in std_logic;
    reg_in1 : in std_logic_vector(4 downto 0);
    reg_in2 : in std_logic_vector(4 downto 0);
    reg_write_in : in std_logic_vector(4 downto 0);
    data_write_in : in std_logic_vector(31 downto 0);
    reg_write : in std_logic;
    reg_out1: out std_logic_vector(31 downto 0);
    reg_out2 : out std_logic_vector(31 downto 0)
);
end registers;

architecture my_registers of registers is
type registers is array (0 to 15) of std_logic_vector(31 downto 0);
signal regs : registers := (others=>(others=>'0'));
signal reg_write_delayed: std_logic;

begin
  regs(0) <= (others=>'0');
  process(clock,reset)
   begin
     reg_write_delayed <= transport reg_write after 2 ps;
    if (clock'event and clock='1') then
     if (reg_write_delayed = '1'  )then
      regs(to_integer(unsigned(reg_write_in))) <=  data_write_in ;
     end if;
    end if;
    if (reset='1') then 
     regs <= (others=>(others=>'0'));
    END IF;
    reg_out1 <= regs(to_integer(unsigned(reg_in1)));
    reg_out2 <= regs(to_integer(unsigned(reg_in2)));
end process;
end my_registers; 
