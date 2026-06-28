library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_memory is
    port (
        CLK     : in  std_logic;
        Reset   : in  std_logic;
        DataIn  : in  std_logic_vector(31 downto 0);
        Addr    : in  std_logic_vector(5 downto 0); -- 6 bits pour 64 mots [cite: 3237, 3242]
        WrEn    : in  std_logic;
        DataOut : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of data_memory is
    type mem_array is array (0 to 63) of std_logic_vector(31 downto 0);
    signal mem : mem_array := (others => (others => '0'));
begin
    -- Lecture asynchrone [cite: 3243]
    DataOut <= mem(to_integer(unsigned(Addr))); [cite: 3243]

    -- Écriture synchrone [cite: 3244]
    process(CLK, Reset)
    begin
        if Reset = '1' then
            mem <= (others => (others => '0'));
        elsif rising_edge(CLK) then [cite: 3244]
            if WrEn = '1' then [cite: 3245, 3246]
                mem(to_integer(unsigned(Addr))) <= DataIn; [cite: 3246]
            end if;
        end if;
    end process;
end architecture;
