library IEEE;
use IEEE.std_logic_1164.all;

entity processing_unit is
    port (
        CLK        : in  std_logic;
        RST        : in  std_logic;
        RegWr      : in  std_logic;
        RW         : in  std_logic_vector(3 downto 0);
        RA         : in  std_logic_vector(3 downto 0);
        RB         : in  std_logic_vector(3 downto 0);
        ALUSrc     : in  std_logic;
        ALUCtr     : in  std_logic_vector(1 downto 0);
        MemWr      : in  std_logic;
        MemtoReg   : in  std_logic;
        Immediat   : in  std_logic_vector(7 downto 0);
        Flags_NZ   : out std_logic_vector(1 downto 0);
        BusW_out   : out std_logic_vector(31 downto 0);
        BusB_out   : out std_logic_vector(31 downto 0) 
    );
end entity;

architecture Structural of processing_unit is
    signal busA, busB, busB_mux, alu_out, data_out, busW : std_logic_vector(31 downto 0);
    signal imm_ext : std_logic_vector(31 downto 0);
begin
    REG_FILE_INST : entity work.reg_file
        port map (CLK => CLK, Reset => RST, W => busW, RA => RA, RB => RB, RW => RW, WE => RegWr, A => busA, B => busB);

    IMM_EXT_INST : entity work.sign_extender
        generic map (N => 8)
        port map (E => Immediat, S => imm_ext);

    MUX_ALU_SRC : entity work.mux2x1
        generic map (N => 32)
        port map (A => busB, B => imm_ext, COM => ALUSrc, S => busB_mux);

    ALU_INST : entity work.alu
        port map (OP => ALUCtr, A => busA, B => busB_mux, S => alu_out, N => Flags_NZ(1), Z => Flags_NZ(0));

    DATA_MEM_INST : entity work.data_memory
        port map (CLK => CLK, Reset => RST, DataIn => busB, Addr => alu_out(5 downto 0), WrEn => MemWr, DataOut => data_out);

    MUX_MEM_TO_REG : entity work.mux2x1
        generic map (N => 32)
        port map (A => alu_out, B => data_out, COM => MemtoReg, S => busW);

    BusW_out <= busW;
    BusB_out <= busB; 
end architecture;