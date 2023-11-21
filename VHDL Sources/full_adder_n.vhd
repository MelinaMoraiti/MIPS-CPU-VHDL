LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder_n IS 
GENERIC(N : INTEGER := 32);  
PORT (
   Cin : IN STD_LOGIC;
   X,Y : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   S : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   Cout : OUT STD_LOGIC);
END full_adder_n;

Architecture behavior of full_adder_n is
begin
process(X,Y,Cin)
 VARIABLE Carry: STD_LOGIC_VECTOR(N DOWNTO 0);
 begin
  Carry(0) := Cin;
  FOR i IN 0 TO N - 1 LOOP
   S(i) <= X(i) XOR Y(i) XOR Carry(i);
   Carry(i+1) := (X(i) AND Y(i)) OR ((X(i) XOR Y(i)) AND Carry(i));
  END LOOP;
  Cout <= Carry(N);
 END PROCESS;
end behavior;
