LIBRARY ieee ;
USE ieee.std_logic_1164.all;

-------------------------------------------------------------
entity mux_2to1_n is
generic(mux_length : INTEGER := 32);
port
(mux_in1, mux_in2: in std_logic_vector(mux_length-1 downto 0);
mux_out: out std_logic_vector(mux_length-1 downto 0);
 s : in std_logic
);
end  mux_2to1_n;

--------------------------------------------------------------
ARCHITECTURE dataflow OF mux_2to1_n IS
BEGIN
 mux_out<= mux_in1 WHEN s='0' ELSE mux_in2 ;
END dataflow;

