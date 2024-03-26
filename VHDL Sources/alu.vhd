library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-----------------------------------------------------------
entity alu is port (
    operand1 : in std_logic_vector(31 downto 0);
    operand2 : in std_logic_vector(31 downto 0);
    operation_code : in std_logic_vector(3 downto 0);
    alu_output : out std_logic_vector(31 downto 0); 
    zero : out std_logic);
end alu;

-----------------------------------------------------------
-- OPERATION CODES
-- "0000" NOTHING
-- "0001" ADD
-- "0010" SUB
-- "0011" check if not  equal
-- "0100" ADDI  

architecture my_alu of alu is    
signal ALU_Result : std_logic_vector (31 downto 0);
component full_adder_n 
  GENERIC(N : INTEGER:=32 );
  port(
   Cin : IN STD_LOGIC;
   X : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   Y : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   S : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   Cout : OUT STD_LOGIC);
end component;
  signal sum : std_logic_vector(31 downto 0);
  signal carry_out : std_logic;
  signal unknown_operation : std_logic_vector(31 downto 0) := (others=>'U');
begin 
  
FA1: full_adder_n 
generic map(N=>32)
port map(Cin=>'0', X=>operand1,Y => operand2,S => sum, Cout =>carry_out);

with operation_code select
 alu_result <= sum when "0001", --add
               operand1-operand2 when "0010", -- sub
               sum when "0100", --addi
               unknown_operation when others; 
zero <='1' when ((operand1 /= operand2)and (operation_code = "0011")) else '0'; --bne
alu_output <= alu_result;
end my_alu;
  
