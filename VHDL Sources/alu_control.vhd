library ieee;
use ieee.std_logic_1164.all;

entity alu_control is port (
  alu_op : in std_logic_vector(1 downto 0);
  instruction_funct : in std_logic_vector (5 downto 0);
  alu_control_out : out std_logic_vector (3 downto 0)
  );
end alu_control;

--ALUOP
-- "0001" ADD
-- "0010" SUB
-- "0011" check if not  equal
-- "0100" ADDI  
architecture my_alu_control of alu_control is
signal tmp_alu_control_out1: std_logic_vector(3 downto 0):=(others=>'0');
signal tmp_alu_control_out2: std_logic_vector(3 downto 0):=(others=>'0');
   begin
     with instruction_funct select
       tmp_alu_control_out1 <= 
         "0001" when "100000" , -- 0x20 add
         "0010" WHEN "100010",  --0x22 sub
         "1111" when others;
      with alu_op select
        tmp_alu_control_out2 <= 
          "0001" when "00", -- lw,sw (add)
          "0011" when "01", --bne
          "0100" when "11", -- addi
          "1111" when others;
      with alu_op select 
         alu_control_out <=  
          tmp_alu_control_out1 when "10",
          tmp_alu_control_out2 when others;
end my_alu_control;
        
        
        
        
        