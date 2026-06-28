library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
    port (
        FPGA_CLK : in  std_logic;
        FPGA_RST : in  std_logic;
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture Behavioral of top_level is
    signal reg_aff_data : std_logic_vector(31 downto 0);
begin
    -- Instanciation du Cœur de Processeur
    CPU : entity work.solomono_processor
        port map (CLK => FPGA_CLK, RST => FPGA_RST, RegAff_Out => reg_aff_data);

    -- Instanciation des 4 Décodeurs 7 Segments pour les 16 bits de poids faible [cite: 3454]
    SEG0 : entity work.dec_7seg port map (hex_val => reg_aff_data(3  downto 0),  seg_out => HEX0);
    SEG1 : entity work.dec_7seg port map (hex_val => reg_aff_data(7  downto 4),  seg_out => HEX1);
    SEG2 : entity work.dec_7seg port map (hex_val => reg_aff_data(11 downto 8),  seg_out => HEX2);
    SEG3 : entity work.dec_7seg port map (hex_val => reg_aff_data(15 downto 12), seg_out => HEX3);
end architecture;