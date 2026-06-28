library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity solomono_processor is
    port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        RegAff_Out  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Structural of solomono_processor is
    signal instruction : std_logic_vector(31 downto 0);
    signal nPCsel      : std_logic;
    signal offset24    : std_logic_vector(23 downto 0);
    
    signal psr_in      : std_logic_vector(31 downto 0);
    signal psr_out     : std_logic_vector(31 downto 0);
    
    signal regWr       : std_logic;
    signal aluSrc      : std_logic;
    signal aluCtr      : std_logic_vector(1 downto 0);
    signal psrEn       : std_logic;
    signal memWr       : std_logic;
    signal memtoReg    : std_logic;
    signal regSel      : std_logic;
    signal regAff      : std_logic;
    
    signal rn          : std_logic_vector(3 downto 0);
    signal rm          : std_logic_vector(3 downto 0);
    signal rd          : std_logic_vector(3 downto 0);
    signal imm8        : std_logic_vector(7 downto 0);
    
    signal ra_mux      : std_logic_vector(3 downto 0);
    signal rb_mux      : std_logic_vector(3 downto 0);
    
    signal busW_out    : std_logic_vector(31 downto 0);
    signal busB_out    : std_logic_vector(31 downto 0); 
    signal flags_nz    : std_logic_vector(1 downto 0);

    signal reg_aff_reg : std_logic_vector(31 downto 0) := (others => '0');

begin

    FETCH_UNIT : entity work.instruction_fetch
        port map (
            CLK         => CLK,
            RST         => RST,
            nPCsel      => nPCsel,
            Offset      => offset24,
            Instruction => instruction
        );

    DECODER_UNIT : entity work.instruction_decoder
        port map (
            Instruction => instruction,
            PSR_in      => psr_out,
            nPCSel      => nPCsel,
            RegWr       => regWr,
            ALUSrc      => aluSrc,
            ALUCtr      => aluCtr,
            PSREn       => psrEn,
            MemWr       => memWr,
            MemtoReg    => memtoReg,
            RegSel      => regSel,
            RegAff      => regAff,
            Rn          => rn,
            Rm          => rm,
            Rd          => rd,
            Imm8        => imm8,
            Offset24    => offset24
        );

    ra_mux <= rn;
    rb_mux <= rd when regSel = '1' else rm;

    PROCESSING_UNIT : entity work.processing_unit
        port map (
            CLK        => CLK,
            RST        => RST,
            RegWr      => regWr,
            RW         => rd,
            RA         => ra_mux,
            RB         => rb_mux,
            ALUSrc     => aluSrc,
            ALUCtr     => aluCtr,
            MemWr      => memWr,
            MemtoReg   => memtoReg,
            Immediat   => imm8,
            Flags_NZ   => flags_nz,
            BusW_out   => busW_out,
            BusB_out   => busB_out 
        );

    psr_in <= flags_nz & x"0000000" & "00";

    PSR_REG_INST : entity work.psr_reg
        port map (
            CLK     => CLK,
            RST     => RST,
            WE      => psrEn,
            DATAIN  => psr_in,
            DATAOUT => psr_out
        );


    process(CLK, RST)
    begin
        if RST = '1' then
            reg_aff_reg <= (others => '0');
        elsif rising_edge(CLK) then
            if memWr = '1' then
                reg_aff_reg <= busB_out; 
            end if;
        end if;
    end process;

    RegAff_Out <= reg_aff_reg;

end architecture;