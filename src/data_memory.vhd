library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_memory is
    port (
        CLK     : in  std_logic;
        Reset   : in  std_logic;
        DataIn  : in  std_logic_vector(31 downto 0);
        Addr    : in  std_logic_vector(5 downto 0); 
        WrEn    : in  std_logic;
        DataOut : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of data_memory is
    type mem_array is array (0 to 63) of std_logic_vector(31 downto 0);
    signal mem : mem_array := (others => (others => '0'));
begin

    DataOut <= mem(to_integer(unsigned(Addr)));

    
    process(CLK, Reset)
    begin
        if Reset = '1' then
            mem <= (others => (others => '0'));
        elsif rising_edge(CLK) then 
            if WrEn = '1' then 
                mem(to_integer(unsigned(Addr))) <= DataIn; 
            end if;
        end if;
    end process;
end architecture;
