library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_file is
    port (
        CLK   : in  std_logic;
        Reset : in  std_logic; -- Actif à l'état haut [cite: 3151]
        W     : in  std_logic_vector(31 downto 0);
        RA    : in  std_logic_vector(3  downto 0);
        RB    : in  std_logic_vector(3  downto 0);
        RW    : in  std_logic_vector(3  downto 0);
        WE    : in  std_logic;
        A     : out std_logic_vector(31 downto 0);
        B     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of reg_file is
    type table is array (15 downto 0) of std_logic_vector(31 downto 0); [cite: 3182]
    
    function init_banc return table is
        variable result : table;
    begin
        for i in 14 downto 0 loop [cite: 3186]
            result(i) := (others => '0'); [cite: 3187]
        end loop;
        result(15) := X"00000030"; -- R15 initialisé selon consigne 
        return result;
    end function;

    signal Banc : table := init_banc; [cite: 3193]
begin
    -- Lecture Asynchrone 
    A <= Banc(to_integer(unsigned(RA))); [cite: 3168]
    B <= Banc(to_integer(unsigned(RB))); [cite: 3169]

    -- Écriture Synchrone [cite: 3170]
    process(CLK, Reset)
    begin
        if Reset = '1' then
            Banc <= init_banc;
        elsif rising_edge(CLK) then [cite: 3170]
            if WE = '1' then [cite: 3171, 3172]
                Banc(to_integer(unsigned(RW))) <= W; [cite: 3172]
            end if;
        end if;
    end process;
end architecture;