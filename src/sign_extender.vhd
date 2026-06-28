library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extender is
    generic ( N : integer := 8 ); -- Taille de l'entrée générique [cite: 3232]
    port (
        E : in  std_logic_vector(N-1 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of sign_extender is
begin
    S <= std_logic_vector(resize(signed(E), 32)); [cite: 3232]
end architecture;
