library IEEE;
use IEEE.std_logic_1164.all;

entity psr_reg is
    port (
        CLK     : in  std_logic;
        RST     : in  std_logic;
        WE      : in  std_logic;
        DATAIN  : in  std_logic_vector(31 downto 0);
        DATAOUT : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of psr_reg is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            DATAOUT <= (others => '0');
        elsif rising_edge(CLK) then
            if WE = '1' then [cite: 3336]
                DATAOUT <= DATAIN; [cite: 3336]
            end if;
        end if;
    end process;
end architecture;