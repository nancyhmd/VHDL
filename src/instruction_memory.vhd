library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_memory is
    port(
        PC          : in  std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of instruction_memory is
    type RAM64x32 is array (0 to 63) of std_logic_vector(31 downto 0);

    function init_mem return RAM64x32 is
        variable result : RAM64x32;
    begin
        for i in 63 downto 0 loop
            result(i) := (others => '0');
        end loop;

        result(0) := x"E3A01010"; -- main: MOV R1, #0x10 
        result(1) := x"E3A02000"; --       MOV R2, #0    
        result(2) := x"E4110000"; -- loop: LDR R0, 0(R1) 
        result(3) := x"E0822000"; --       ADD R2, R2, R0
        result(4) := x"E2811001"; --       ADD R1, R1, #1
        result(5) := x"E351001A"; --       CMP R1, #0x1A  
        result(6) := x"BAFFFFFB"; --       BLT loop      
        result(7) := x"E4012000"; --       STR R2, 0(R1)  
        result(8) := x"EAFFFFF7"; --       BAL main      

        return result;
    end function;

    signal mem : RAM64x32 := init_mem;
begin
    Instruction <= mem(to_integer(unsigned(PC)));
end architecture;