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
    -- Instanciation du processeur
    UUT : entity work.solomono_processor
        port map (CLK => clk, RST => rst, RegAff_Out => reg_aff_s);

    -- Génération de l'horloge
    clk <= not clk after CLK_PERIOD / 2;

    -- Process de Stimulus
    process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0'; -- Lancement de l'exécution
        
        -- On laisse tourner la simulation pour que la boucle s'exécute
        wait for 500 ns;
        
        assert false report "Fin de la simulation programmée" severity failure;
    end process;
end architecture;