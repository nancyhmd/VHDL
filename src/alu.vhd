library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; -- Permet l'utilisation de '+' et '-' [cite: 35]

entity alu is
    port (
        OP  : in  std_logic_vector(1 downto 0); 
        A   : in  std_logic_vector(31 downto 0); 
        B   : in  std_logic_vector(31 downto 0);
        S   : out std_logic_vector(31 downto 0); 
        N   : out std_logic;
        Z   : out std_logic
    );
end entity;

architecture Behavioral of alu is
    signal res_s : std_logic_vector(31 downto 0);
begin
    process(OP, A, B)
    begin
        case OP is
            when "00" => res_s <= std_logic_vector(signed(A) + signed(B)); -- ADD 
            when "01" => res_s <= B;                                      -- Y = B 
            when "10" => res_s <= std_logic_vector(signed(A) - signed(B)); -- SUB 
            when "11" => res_s <= A;                                      -- Y = A 
            when others => res_s <= (others => '0');
        end case;
    end process;

    S <= res_s;

    -- Gestion des drapeaux (Flags) sans aucun caractère parasite
    N <= '1' when (signed(res_s) < 0) else '0';
    Z <= '1' when (signed(res_s) = 0) else '0'; 
end architecture;