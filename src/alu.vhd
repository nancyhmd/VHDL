library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Permet l'utilisation de '+' et '-' [cite: 3144]

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
            when "00" => res_s <= std_logic_vector(signed(A) + signed(B)); -- ADD [cite: 3131, 3132, 3133]
            when "01" => res_s <= B;                                      -- Y = B [cite: 3134, 3135]
            when "10" => res_s <= std_logic_vector(signed(A) - signed(B)); -- SUB [cite: 3136, 3137, 3138]
            when "11" => res_s <= A;                                      -- Y = A [cite: 3139, 3140]
            when others => res_s <= (others => '0');
        end case;
    end process;

    S <= res_s;
    -- Gestion des drapeaux (Flags) [cite: 3141]
    N <= '1' when signed(res_s) < 0 else '0'; [cite: 3142]
    Z <= '1' when signed(res_s) = 0 else '0'; [cite: 3143]
end architecture;