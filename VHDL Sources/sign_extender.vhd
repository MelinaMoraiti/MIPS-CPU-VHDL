
library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is port(
  sign_ext_in : in std_logic_vector(15 downto 0);
  sign_ext_out : out std_logic_vector(31 downto 0)
);
end sign_extender;

architecture my_sign_extender of sign_extender is
begin
  sign_ext_out<="0000000000000000" & sign_ext_in when sign_ext_in(15)='0' else
                "1111111111111111" & sign_ext_in when sign_ext_in(15)='1';
end my_sign_extender;