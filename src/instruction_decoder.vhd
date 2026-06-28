library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_decoder is
    port (
        Instruction : in  std_logic_vector(31 downto 0);
        PSR_in      : in  std_logic_vector(31 downto 0);
        nPCSel      : out std_logic;
        RegWr       : out std_logic;
        ALUSrc      : out std_logic;
        ALUCtr      : out std_logic_vector(1 downto 0);
        PSREn       : out std_logic;
        MemWr       : out std_logic;
        MemtoReg    : out std_logic;
        RegSel      : out std_logic;
        RegAff      : out std_logic;
        Rn          : out std_logic_vector(3 downto 0);
        Rm          : out std_logic_vector(3 downto 0);
        Rd          : out std_logic_vector(3 downto 0);
        Imm8        : out std_logic_vector(7 downto 0);
        Offset24    : out std_logic_vector(23 downto 0)
    );
end entity;

architecture Behavioral of instruction_decoder is
    type enum_instruction is (MOV, ADDI, ADDr, CMP, LDR, STR, BAL, BLT); 
    signal instr_courante : enum_instruction; 
    
    signal opcode : std_logic_vector(3 downto 0);
    signal cond   : std_logic_vector(3 downto 0);
    signal bit_I  : std_logic;
begin
    cond   <= Instruction(31 downto 28); 
    bit_I  <= Instruction(25);          
    opcode <= Instruction(24 downto 21); 

    Rn     <= Instruction(19 downto 16); 
    Rd     <= Instruction(15 downto 12); 
    Rm     <= Instruction(3 downto 0);  
    Imm8   <= Instruction(7 downto 0);   
    Offset24 <= Instruction(23 downto 0); 


    process(Instruction, cond, opcode, bit_I)
    begin
        if cond = "1110" then 
            if Instruction(27 downto 26) = "00" then 
                case opcode is
                    when "1101" => instr_courante <= MOV; 
                    when "1010" => instr_courante <= CMP;  
                    when "0100" =>
                        if bit_I = '1' then instr_courante <= ADDI;
                        else instr_courante <= ADDr; end if;
                    when others => instr_courante <= MOV;
                end case;
            elsif Instruction(27 downto 26) = "01" then 
                if Instruction(20) = '1' then instr_courante <= LDR; 
                else instr_courante <= STR; end if;
            elsif Instruction(27 downto 25) = "101" then 
                instr_courante <= BAL;
            end if;
        elsif cond = "1011" then 
            instr_courante <= BLT;
        else
            instr_courante <= MOV;
        end if;
    end process;


    process(instr_courante, PSR_in)
    begin
        
        nPCSel   <= '0'; RegWr    <= '0'; ALUSrc   <= '0'; ALUCtr   <= "00";
        PSREn    <= '0'; MemWr    <= '0'; MemtoReg <= '0'; RegSel   <= '0'; RegAff   <= '0';

        case instr_courante is
            when ADDI => RegWr  <= '1'; ALUSrc <= '1';
            when ADDr => RegWr  <= '1';
            when BAL  => nPCSel <= '1';
            when BLT  => nPCSel <= PSR_in(31);
            when CMP  => ALUCtr <= "10"; PSREn  <= '1'; RegSel <= '1';
            when LDR  => RegWr  <= '1'; ALUSrc <= '1'; MemtoReg <= '1';
            when MOV  => RegWr  <= '1'; ALUSrc <= '1'; ALUCtr   <= "01";
            when STR  => MemWr  <= '1'; ALUSrc <= '1'; RegSel   <= '1'; RegAff <= '1';
        end case;
    end process;
end architecture;