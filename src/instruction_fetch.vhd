library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_fetch is
    port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        nPCsel      : in  std_logic;
        Offset      : in  std_logic_vector(23 downto 0);
        Instruction : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of instruction_fetch is
    signal PC_reg    : std_logic_vector(31 downto 0) := (others => '0');
    signal PC_next   : std_logic_vector(31 downto 0);
    signal offset_ext: std_logic_vector(31 downto 0);
begin
    -- Extension de signe de l'offset 24 bits [cite: 3302]
    offset_ext <= std_logic_vector(resize(signed(Offset), 32));

    -- Logique de calcul du PC Suivant [cite: 3302]
    process(PC_reg, nPCsel, offset_ext)
    begin
        if nPCsel = '0' then
            PC_next <= std_logic_vector(unsigned(PC_reg) + 1); -- PC = PC + 1 [cite: 3303]
        else
            PC_next <= std_logic_vector(unsigned(PC_reg) + 1 + unsigned(offset_ext)); -- PC = PC + 1 + SignExt(Offset) [cite: 3304]
        end if;
    end process;

    -- Registre PC synchrone [cite: 3301]
    process(CLK, RST)
    begin
        if RST = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(CLK) then
            PC_reg <= PC_next;
        end if;
    end process;

    -- Instanciation de la mémoire d'instructions (fournie) [cite: 3299]
    INST_MEM : entity work.instruction_memory
        port map (PC => PC_reg, Instruction => Instruction); [cite: 3525]
end architecture;