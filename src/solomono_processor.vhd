library IEEE;
use IEEE.std_logic_1164.all;

entity solomono_processor is
    port (
        CLK      : in  std_logic;
        RST      : in  std_logic;
        RegAff_Out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Structural of solomono_processor is

    signal instruction : std_logic_vector(31 downto 0);
    signal psr_out     : std_logic_vector(31 downto 0);
    signal flags_nz    : std_logic_vector(1 downto 0);
    signal psr_in      : std_logic_vector(31 downto 0) := (others => '0');

    signal nPCSel, RegWr, ALUSrc, PSREn, MemWr, MemtoReg, RegSel, RegAff : std_logic;
    signal ALUCtr : std_logic_vector(1 downto 0);

    signal rn, rm, rd, rb_mux : std_logic_vector(3 downto 0);
    signal imm8   : std_logic_vector(7 downto 0);
    signal offset24 : std_logic_vector(23 downto 0);
    signal busW   : std_logic_vector(31 downto 0);
begin

    FETCH_UNIT : entity work.instruction_fetch
        port map (CLK => CLK, RST => RST, nPCsel => nPCSel, Offset => offset24, Instruction => instruction);

   
    DECODER_UNIT : entity work.instruction_decoder
        port map (
            Instruction => instruction, PSR_in => psr_out, nPCSel => nPCSel, RegWr => RegWr,
            ALUSrc => ALUSrc, ALUCtr => ALUCtr, PSREn => PSREn, MemWr => MemWr, MemtoReg => MemtoReg,
            RegSel => RegSel, RegAff => RegAff, Rn => rn, Rm => rm, Rd => rd, Imm8 => imm8, Offset24 => offset24
        );


    MUX_REG_SEL : entity work.mux2x1
        generic map (N => 4)
        port map (A => rm, B => rd, COM => RegSel, S => rb_mux);


    PROCESSING_UNIT_INST : entity work.processing_unit
        port map (
            CLK => CLK, RST => RST, RegWr => RegWr, RW => rd, RA => rn, RB => rb_mux,
            ALUSrc => ALUSrc, ALUCtr => ALUCtr, MemWr => MemWr, MemtoReg => MemtoReg,
            Immediat => imm8, Flags_NZ => flags_nz, BusW_out => busW
        );

    psr_in(31 downto 30) <= flags_nz; 
    PSR_REG_INST : entity work.psr_reg
        port map (CLK => CLK, RST => RST, WE => PSREn, DATAIN => psr_in, DATAOUT => psr_out);

    REG_AFF_INST : entity work.psr_reg
        port map (CLK => CLK, RST => RST, WE => RegAff, DATAIN => busW, DATAOUT => RegAff_Out);
end architecture;