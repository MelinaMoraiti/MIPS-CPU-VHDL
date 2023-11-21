LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
entity register_file_tb is

end register_file_tb ;

architecture test_r of register_file_tb is
 signal reset_t :  std_logic;
 signal  reg_in1_t :  std_logic_vector(4 downto 0);
  signal   reg_in2_t  :  std_logic_vector(4 downto 0);
  signal   reg_write_in_t  :  std_logic_vector(4 downto 0);
  signal   data_write_in_t  : std_logic_vector(31 downto 0);
  signal   reg_write_t  :  std_logic;
  signal   reg_out1_t : std_logic_vector(31 downto 0);
  signal   reg_out2_t  : std_logic_vector(31 downto 0);

component registers
port (   
    reset: in std_logic;
    reg_in1 : in std_logic_vector(4 downto 0);
    reg_in2 : in std_logic_vector(4 downto 0);
    reg_write_in : in std_logic_vector(4 downto 0);
    data_write_in : in std_logic_vector(31 downto 0);
    reg_write : in std_logic;
    reg_out1: out std_logic_vector(31 downto 0);
    reg_out2 : out std_logic_vector(31 downto 0));
end component;


begin

M2: registers 
PORT MAP
(reset=>reset_t,reg_in1=>reg_in1_t,reg_in2=>reg_in2_t, reg_write_in => reg_write_in_t,
data_write_in=>data_write_in_t,reg_write=>reg_write_t,reg_out1=>reg_out1_t,reg_out2=>reg_out2_t);
process
begin
  
    reset_t<='1' ; wait for 200 ps;
    reset_t<='0';
    reg_write_t <= '1';
  reg_in1_t<=std_logic_vector(to_signed(8,5));
  reg_in2_t<=std_logic_vector(to_signed(11,5));
  reg_write_in_t <=std_logic_vector(to_signed(11,5));
  data_write_in_t <= std_logic_vector(to_signed(1,32));
  wait for 300 ps;
  
  end process;
end test_r;

