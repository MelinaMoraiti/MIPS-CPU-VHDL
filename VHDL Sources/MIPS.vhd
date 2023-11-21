library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------

ENTITY MIPS IS port(
   clock,reset  : in std_logic);
end MIPS;

------------------------------------------------------

architecture MY_MIPS of MIPS is
------------------ All Mips Units-------------------
  COMPONENT full_adder_n 
  GENERIC(N : INTEGER := 32);  
  port(Cin : IN STD_LOGIC;
       X,Y : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       S : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       Cout : OUT STD_LOGIC);
  end component;
  
  component program_counter port (
        in_pc : in std_logic_vector(31 downto 0);
        out_pc : out std_logic_vector(31 downto 0);
        clock : in std_logic;
        reset : in std_logic);
  end component; 
  
  component instruction_memory 
    generic ( bits : natural := 32;
    size : natural := 16);
    port( in_IM: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0));
  end component;
  
  component mux_2to1_32bit
    generic(mux_length : INTEGER := 32);
    port(mux_in1, mux_in2: in std_logic_vector(mux_length-1 downto 0);
     mux_out: out std_logic_vector(mux_length-1 downto 0);
     s : in std_logic);
  end component;
  
  component mux_2to1_5bit
    generic(mux_length : INTEGER := 5);
    port(mux_in1, mux_in2: in std_logic_vector(mux_length-1 downto 0);
     mux_out: out std_logic_vector(mux_length-1 downto 0);
     s : in std_logic);
  end component;
  
  component control_unit
        port(opcode_in : in std_logic_vector(5 downto 0);
        alu_op : out std_logic_vector (1 downto 0);
        clock : in std_logic;
        reg_dst, alu_src, mem_to_reg, reg_write : out std_logic;
        mem_read, mem_write, branch : out std_logic);
   end component;
   
   component alu_control 
     port (alu_op : in std_logic_vector(1 downto 0);
     instruction_funct : in std_logic_vector (5 downto 0);
     alu_control_out : out std_logic_vector (3 downto 0));
   end component;
  
  component alu port (
    operand1 : in std_logic_vector(31 downto 0);
    operand2 : in std_logic_vector(31 downto 0);
    operation_code : in std_logic_vector(3 downto 0);
    alu_output : out std_logic_vector(31 downto 0); 
    zero : out std_logic);
  end component;
  
  component registers
    port (
    reset,clock : in std_logic;
    reg_in1 : in std_logic_vector(4 downto 0);
    reg_in2 : in std_logic_vector(4 downto 0);
    reg_write_in : in std_logic_vector(4 downto 0);
    data_write_in : in std_logic_vector(31 downto 0);
    reg_write : in std_logic;
    reg_out1: out std_logic_vector(31 downto 0);
    reg_out2 : out std_logic_vector(31 downto 0));
  end component;
  
  component sign_extender 
    port(sign_ext_in : in std_logic_vector(15 downto 0);
    sign_ext_out : out std_logic_vector(31 downto 0));
  end component;
  
  component left_shift_2bit 
    port(shift_in : in std_logic_vector(31 downto 0);
    shift_out : out std_logic_vector(31 downto 0));
  end component;
  
  component data_memory
    port(mem_write,mem_read,clock,reset : in std_logic;
    in_ram_addr,write_data : in std_logic_vector(31 downto 0);
    out_ram : out std_logic_vector(31 downto 0));
  end component;
  
----------------------All Intermediate Signals (Wires)--------------------------------

signal reg_write, alu_source, mem_write, mem_read, mem_to_reg,reg_dest,jump: std_logic;
signal zero,branch,and_gate_out : std_logic;  

signal PC_FA_IM,FA_PC_OUT : std_logic_vector(31 downto 0);
signal IM_OUT :  std_logic_vector(31 downto 0);
signal ONE : std_logic_vector(31 downto 0); -- signal one in 32 bits to increase the pc  
signal ALU_OUT : std_logic_vector(31 downto 0);
signal alu_op : std_logic_vector(1 downto 0);
signal reg_out1,reg_out2 : std_logic_vector(31 downto 0);
signal alu_control_out : std_logic_vector(3 downto 0);

signal data_write_in :std_logic_vector(31 downto 0);

signal mux_reg_out : std_logic_vector(4 downto 0);
signal mux_alu_out : std_logic_vector(31 downto 0);
signal sign_extender_out : std_logic_vector(31 downto 0);
signal data_memory_out : std_logic_vector(31 downto 0);

--signal shift_jump2mux_jump:std_logic_vector(31 downto 0);
signal  mux_jump2pc : std_logic_vector(31 downto 0);
--signal mux_branch2mux_jump : std_logic_vector(31 downto 0);
signal alu_branch_out : std_logic_vector(31 downto 0);
signal sign_extender_out_aligned : std_logic_vector(31 downto 0);

 BEGIN 
   ONE <= std_logic_vector(to_unsigned(1,32));
    --adder calculates pc address
   FA_PC1: full_adder_n port map(
     X => PC_FA_IM,
     Y => ONE,
     Cin => '0',
     S=>FA_PC_OUT);
     
   -- If a bne instruction will be executed
   -- left shift by 2 bit (multiply by 4) the instruction's offset is unnecessary
   --  because the instruction memory has WORD (32-bit) lines. We need to shift by 0...
   --  So the left shifter by 2 bits unit is unnecessary. 
     
    -- LShift2: left_shift_2bit PORT MAP (
    --   shift_in => sign_extender_out,
    --  shift_out =>sign_extender_out_aligned
    -- );
    
    --Adder calculates branch address
    FA_BRANCH: full_adder_n 
    port map(
      X => FA_PC_OUT,
      Y => sign_extender_out, -- Gets branch address directly from the sign extender's output.
      Cin => '0',
      S => alu_branch_out);
	  
    -- Synchronous Unit 
	--Register that assigns to the output the address of the next instruction.
    PC: program_counter port map (
      in_pc => mux_jump2pc,
      out_pc =>PC_FA_IM, 
      clock => clock,
      reset =>  reset);
    -- ROM that stores instructions (assembly source code) hardcoded.
    IM: instruction_memory port map(
        in_im => PC_FA_IM,
        instruction => IM_OUT );
    -- Synchronous unit, similar to RAM stores registers' values.
    REGF: registers port map(
      reset=>reset,clock=>clock,
      reg_in1 => IM_OUT(25 DOWNTO 21),
      reg_in2 => IM_OUT(20 DOWNTO 16),
      reg_write_in => mux_reg_out,
      data_write_in => data_write_in,
      reg_write => reg_write,
      reg_out1 => reg_out1,
      reg_out2 => reg_out2); 
      
	 -- Decodes the instruction and sets its datapath with nine signals
     CU: control_unit port map (
        opcode_in =>  IM_OUT(31 DOWNTO 26),
        alu_op => alu_op,
        clock => clock,
        reg_dst => reg_dest, alu_src=>alu_source, mem_to_reg=>mem_to_reg, reg_write=>reg_write, 
        mem_read=>mem_read, mem_write=>mem_write, branch=>branch );
     -- Unit that helps ALU.
     AC: alu_control port map (
         alu_op => alu_op, 
         instruction_funct => IM_OUT (5 DOWNTO 0),
         alu_control_out => alu_control_out );
    -- Arithmetic and logic Unit, does arithmetic operations and alu_output is the result.
    A: alu port map (
       operand1 => reg_out1,
       operand2 => mux_alu_out,
       operation_code =>  alu_control_out,
       alu_output => ALU_OUT,
       zero =>zero);
	 -- Synchronous unit
     -- RAM Memory stores the program's data 
     DM : data_memory port map(
        mem_write => mem_write ,mem_read => mem_read,clock=>clock,reset => reset,
        in_ram_addr=> ALU_OUT,write_data => reg_out2,
        out_ram => data_memory_out  );
    -- MUX (8) selects the address of the register that will be written in regfile.
     MUX_REGS: mux_2to1_5bit PORT MAP(
      mux_in1=>IM_OUT(20 DOWNTO 16) ,
      mux_in2 => IM_OUT(15 DOWNTO 11) ,
      mux_out => mux_reg_out,
      s => reg_dest);
     -- MUX (10) before ALU chooses, the second operand of ALU.
     MUX_ALU:  mux_2to1_32bit PORT MAP(
      mux_in1=> reg_out2,
      mux_in2 =>  sign_extender_out,
      mux_out => mux_alu_out,
      s => alu_source);
     -- MUX (11) chooses the data that is written in the regfile.
     MUX_RAM:  mux_2to1_32bit PORT MAP(
      mux_in1=> alu_out,
      mux_in2 => data_memory_out,
      mux_out => data_write_in,
      s => mem_to_reg);
    
      and_gate_out<= branch and zero; 
	-- MUX (12) chooses the address of the next instruction
      MUX_JUMP  : mux_2to1_32bit PORT MAP(
         mux_in1=> FA_PC_OUT,
         mux_in2 => alu_BRANCH_out,
         mux_out =>mux_jump2PC,
         s => and_gate_out);
      -- Extends the instruction's offset from 16 to 32 bits so that other units (adder, mux...) can use it.
      SE: sign_extender PORT MAP  (
        sign_ext_in => IM_OUT(15 DOWNTO 0) ,
        sign_ext_out =>  sign_extender_out);
   
end MY_MIPS;