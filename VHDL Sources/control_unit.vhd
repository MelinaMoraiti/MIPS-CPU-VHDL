Library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port(
        opcode_in : in std_logic_vector(5 downto 0);
        alu_op : out std_logic_vector (1 downto 0);
        clock : in std_logic;
        reg_dst, alu_src, mem_to_reg, reg_write : out std_logic;
        mem_read, mem_write, branch : out std_logic
    );
end control_unit;

architecture my_control_unit of control_unit is
 begin
     WITH opcode_in select 
         alu_op<= 
          "00" after 4 ps when "100011", -- lw
          "00" after 4 ps when "101011", --sw
          "11" after 4 ps when "001000", --addi 
          "10" after 4 ps when "000000", -- add, sub (R-Type Instructions)
          "01" after 4 ps when "000101", -- bne
          "XX" when others;
       WITH opcode_in select 
         mem_read <= 
          '1' after 4 ps when "100011", --lw
          '0' when others;
        WITH opcode_in select 
         mem_write<= 
          '1' after 20 ps when "101011", --sw
          '0' when others;
       WITH opcode_in select 
         reg_write<= 
          ('1' and clock) when "100011", --lw
          ('1' and clock)when "001000", --addi 
          ('1' and clock) when "000000", -- add, sub (R-Type Instructions)
          '0' when others;
       WITH opcode_in select 
         alu_src <= 
          '1' after 4 ps when "100011", --lw
          '1' after 4 ps when "001000", --addi 
          '1' after 4 ps when "101011", -- sw
          '0' when others;
        WITH opcode_in select 
         branch<= 
          '1' when "000101", -- Bne
          '0' when others;
        WITH opcode_in select 
         mem_to_reg<= 
          '1' after 4 ps when "100011", --load word
          '0' when others;
      WITH opcode_in select 
         reg_dst<= 
          '0' when "100011", --load word
          '0' when "001000", --addi 
          '1' when others; 
end my_control_unit;
            
             
