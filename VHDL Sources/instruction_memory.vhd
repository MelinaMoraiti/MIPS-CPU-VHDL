library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------------
entity instruction_memory is
  generic ( 
   bits : natural := 32;
   size : natural := 16);
 port( 
    in_IM: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0));
end instruction_memory;
----------------------------------------------------------------------------

architecture my_instruction_memory of instruction_memory is
type IMArray is array(0 to size-1) of std_logic_vector(bits-1 downto 0);

signal instruction_counter: integer;

-- addi $0, $0, 0 # ?? ?????????? (?? ??????????? ????? ??????????)
-- addi $2, $2, 0 # ?? ?????????? (?? ??????????? ????? ??????????)
-- addi $2, $4, 0 # ?? ?????????? (?? ??????????? ????? ??????????)
-- addi $3, $0, 1
-- addi $5, $0, 3
-- L1: add $6, $3, $0
-- sw $6, 0($4)
-- addi $3, $3, 1
-- addi $4, $4, 1
-- addi $5, $5, -1
-- bne $5,$0,L1
constant IM_data: IMArray:=(
   "00100000000000110000000000000001",
   "00100000000001010000000000000011",
   "00000000011000000011000000100000",
   "10101100100001100000000000000000",
   "00100000011000110000000000000001",
   "00100000100001000000000000000001",
   "00100000101001011111111111111111",
   "00010100101000001111111111111010",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000"
  );
begin 
instruction_counter <= to_integer(unsigned(in_IM)) when (to_integer(unsigned(in_IM)) < 17) else
           0;

instruction <= IM_data(instruction_counter) when (instruction_counter >=0 and instruction_counter <17) else
               IM_data(0) ;
  
  
end my_instruction_memory;
