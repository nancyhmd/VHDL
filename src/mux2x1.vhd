library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
    generic ( N : integer := 32 ); 
    port (
        A   : in  std_logic_vector(N-1 downto 0);
        B   : in  std_logic_vector(N-1 downto 0);
        COM : in  std_logic;
        S   : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of mux2x1 is
begin
    S <= A when COM = '0' else B; 
end architecture;