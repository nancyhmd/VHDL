library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_solomono_processor is
end entity;

architecture Test of tb_solomono_processor is
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal reg_aff_s  : std_logic_vector(31 downto 0);
    constant CLK_PERIOD : time := 10 ns;
begin
    UUT : entity work.solomono_processor
        port map (CLK => clk, RST => rst, RegAff_Out => reg_aff_s);

    clk <= not clk after CLK_PERIOD / 2;

    process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0'; 

        wait for 1 us;

        assert (reg_aff_s = x"00000037")
            report "Erreur : RegAff_Out ne contient pas la somme attendue (0x37)"
            severity error;

        assert false report "Fin de la simulation programmee" severity failure;
    end process;
end architecture;