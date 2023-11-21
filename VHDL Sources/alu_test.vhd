library ieee;
use ieee.std_logic_1164.all;

entity alu_test is
end alu_test;

architecture my_alu_test of alu_test is
    
  signal clock : std_logic;
  signal reset : std_logic;
  signal operand1_test : std_logic_vector (31 downto 0);
  signal operand2_test : std_logic_vector (31 downto 0);
  signal opcode_test : std_logic_vector (3 downto 0);
  signal out_test : std_logic_vector (31 downto 0);
  signal zero_test : std_logic;
  
  component alu port(
    operand1 : in std_logic_vector(31 downto 0);
    operand2 : in std_logic_vector(31 downto 0);
    operation_code : in std_logic_vector(3 downto 0);
    alu_output : out std_logic_vector(31 downto 0); 
    zero : out std_logic);
  end component;
  signal count_period: integer :=0;
  
begin
  AT: ALU port map(operand1=>operand1_test,operand2=>operand2_test,
  operation_code=>opcode_test,alu_output=>out_test,zero=>zero_test);
  process 
    begin
        operand1_test <= "00000000000000000000000000000011"; --3
        operand2_test <= "00000000000000000000000000000111"; --7
        opcode_test <= "0010"; -- 3-7=-4
        wait for 400 ps;
        opcode_test <= "0001"; -- 3+7=10
        wait for 200 ps;
        opcode_test <= "0011"; -- BNE
        wait for 200 ps;
  end process;
  
end my_alu_test;
