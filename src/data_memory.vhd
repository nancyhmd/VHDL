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

    function init_mem return mem_array is
        variable result : mem_array;
    begin
        for i in 63 downto 0 loop
            result(i) := (others => '0');
        end loop;

        for i in 0 to 9 loop
            result(16 + i) := std_logic_vector(to_unsigned(i + 1, 32)); 
        end loop;

        return result;
    end function;

    signal mem : mem_array := init_mem;
begin

    DataOut <= mem(to_integer(unsigned(Addr)));


    process(CLK, Reset)
    begin
        if Reset = '1' then
            mem <= init_mem;
        elsif rising_edge(CLK) then
            if WrEn = '1' then
                mem(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;
end architecture;