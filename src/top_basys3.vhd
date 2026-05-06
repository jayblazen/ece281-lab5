library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_basys3 is
    port(
        -- CLOCK
        clk     : in std_logic;

        -- INPUTS
        sw      : in std_logic_vector(7 downto 0);
        btnU    : in std_logic;
        btnC    : in std_logic;

        -- OUTPUTS
        led     : out std_logic_vector(15 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        an      : out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is

    -- =================================================
    -- FSM
    -- =================================================
    signal w_cycle : std_logic_vector(3 downto 0);

    -- =================================================
    -- REGISTERS
    -- =================================================
    signal r_A : std_logic_vector(7 downto 0) := (others => '0');
    signal r_B : std_logic_vector(7 downto 0) := (others => '0');

    -- =================================================
    -- ALU
    -- =================================================
    signal w_alu_result : std_logic_vector(7 downto 0);
    signal w_flags      : std_logic_vector(3 downto 0);

    -- =================================================
    -- DISPLAY PIPELINE
    -- =================================================
    signal w_display : std_logic_vector(7 downto 0);

    signal w_sign : std_logic;

    signal w_hund : std_logic_vector(3 downto 0);
    signal w_tens : std_logic_vector(3 downto 0);
    signal w_ones : std_logic_vector(3 downto 0);

    signal w_tdm_data : std_logic_vector(3 downto 0);

    signal w_D3 : std_logic_vector(3 downto 0);
    signal w_D2 : std_logic_vector(3 downto 0);
    signal w_D1 : std_logic_vector(3 downto 0);
    signal w_D0 : std_logic_vector(3 downto 0);

    -- =================================================
    -- BUTTON EDGE DETECT
    -- =================================================
    signal btnC_prev : std_logic := '0';
    signal btnC_edge : std_logic;

    -- =================================================
    -- SIGN DIGIT
    -- =================================================
    signal w_sign_digit : std_logic_vector(3 downto 0);

begin

-- =====================================================
-- BUTTON EDGE DETECTOR
-- =====================================================
process(clk)
begin
    if rising_edge(clk) then
        btnC_prev <= btnC;
    end if;
end process;

btnC_edge <= btnC and not btnC_prev;

-- =====================================================
-- FSM
-- =====================================================
fsm_inst : entity work.controller_fsm
    port map (
        clk     => clk,
        i_reset => btnU,
        i_adv   => btnC_edge,
        o_cycle => w_cycle
    );

-- =====================================================
-- ALU
-- =====================================================
alu_inst : entity work.ALU
    port map (
        i_A      => r_A,
        i_B      => r_B,
        i_op     => sw(2 downto 0),
        o_result => w_alu_result,
        o_flags  => w_flags
    );

-- =====================================================
-- REGISTER LOAD
-- =====================================================
process(clk)
begin
    if rising_edge(clk) then

        if btnU = '1' then
            r_A <= (others => '0');
            r_B <= (others => '0');

        else

            -- LOAD A
            if w_cycle = "0010" then
                r_A <= sw;
            end if;

            -- LOAD B
            if w_cycle = "0100" then
                r_B <= sw;
            end if;

        end if;
    end if;
end process;

-- =====================================================
-- DISPLAY VALUE SELECT
-- =====================================================
process(w_cycle, r_A, r_B, w_alu_result)
begin

    case w_cycle is

        -- LOAD A
        when "0010" =>
            w_display <= r_A;

        -- LOAD B
        when "0100" =>
            w_display <= r_B;

        -- RESULT
        when "1000" =>
            w_display <= w_alu_result;

        -- IDLE / BLANK
        when others =>
            w_display <= (others => '0');

    end case;

end process;

-- =====================================================
-- BINARY TO DECIMAL
-- =====================================================
twos_inst : entity work.twos_comp
    port map (
        i_bin  => w_display,
        o_sign => w_sign,
        o_hund => w_hund,
        o_tens => w_tens,
        o_ones => w_ones
    );

-- =====================================================
-- SIGN DIGIT
-- A = DASH
-- F = BLANK
-- =====================================================
w_sign_digit <= "1010" when w_sign = '1'
                else "1111";

-- =====================================================
-- DISPLAY BLANKING
-- =====================================================
process(w_cycle, w_sign_digit, w_hund, w_tens, w_ones)
begin

    -- BLANK DISPLAY IN IDLE STATE
    if w_cycle = "0001" then

        w_D3 <= "1111";
        w_D2 <= "1111";
        w_D1 <= "1111";
        w_D0 <= "1111";

    else

        w_D3 <= w_sign_digit;
        w_D2 <= w_hund;
        w_D1 <= w_tens;
        w_D0 <= w_ones;

    end if;

end process;

-- =====================================================
-- TDM DISPLAY DRIVER
-- =====================================================
tdm_inst : entity work.TDM4
    generic map (
        k_WIDTH => 4
    )
    port map (
        i_clk   => clk,
        i_reset => btnU,

        i_D3 => w_D3,
        i_D2 => w_D2,
        i_D1 => w_D1,
        i_D0 => w_D0,

        o_data => w_tdm_data,
        o_sel  => an
    );

-- =====================================================
-- SEVEN SEGMENT DECODER
-- =====================================================
sevenseg_inst : entity work.sevenseg_decoder
    port map (
        i_Hex   => w_tdm_data,
        o_seg_n => seg
    );

-- =====================================================
-- LED OUTPUTS
-- =====================================================
led(3 downto 0)   <= w_cycle;
led(15 downto 12) <= w_flags;

end top_basys3_arch;