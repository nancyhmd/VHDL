library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
    port (
        MAX10_CLK1_50 : in  std_logic; 
        KEY           : in  std_logic_vector(1 downto 0); 
        

        HEX0          : out std_logic_vector(6 downto 0);
        HEX1          : out std_logic_vector(6 downto 0);
        HEX2          : out std_logic_vector(6 downto 0);
        HEX3          : out std_logic_vector(6 downto 0)
    );
end entity;

architecture Behavioral of top_level is
    signal reg_aff_data : std_logic_vector(31 downto 0);
    signal rst_intern   : std_logic;
begin

    rst_intern <= not KEY(0);

    CPU : entity work.solomono_processor
        port map (
            CLK        => MAX10_CLK1_50, 
            RST        => rst_intern, 
            RegAff_Out => reg_aff_data
        );


    SEG0 : entity work.dec_7seg port map (hex_val => reg_aff_data(3  downto 0),  seg_out => HEX0);
    SEG1 : entity work.dec_7seg port map (hex_val => reg_aff_data(7  downto 4),  seg_out => HEX1);
    SEG2 : entity work.dec_7seg port map (hex_val => reg_aff_data(11 downto 8),  seg_out => HEX2);
    SEG3 : entity work.dec_7seg port map (hex_val => reg_aff_data(15 downto 12), seg_out => HEX3);

end architecture;