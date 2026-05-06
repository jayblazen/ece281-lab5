library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenseg_decoder_tb is
end sevenseg_decoder_tb;

architecture Behavioral of sevenseg_decoder_tb is

    -- Signals to connect to DUT
    signal i_Hex   : std_logic_vector(3 downto 0);
    signal o_seg_n : std_logic_vector(6 downto 0);

begin

    -- Instantiate DUT
    uut: entity work.sevenseg_decoder
        port map (
            i_Hex   => i_Hex,
            o_seg_n => o_seg_n
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test all values 0 → F
        i_Hex <= "0000"; wait for 10 ns;
        i_Hex <= "0001"; wait for 10 ns;
        i_Hex <= "0010"; wait for 10 ns;
        i_Hex <= "0011"; wait for 10 ns;
        i_Hex <= "0100"; wait for 10 ns;
        i_Hex <= "0101"; wait for 10 ns;
        i_Hex <= "0110"; wait for 10 ns;
        i_Hex <= "0111"; wait for 10 ns;
        i_Hex <= "1000"; wait for 10 ns;
        i_Hex <= "1001"; wait for 10 ns;
        i_Hex <= "1010"; wait for 10 ns;
        i_Hex <= "1011"; wait for 10 ns;
        i_Hex <= "1100"; wait for 10 ns;
        i_Hex <= "1101"; wait for 10 ns;
        i_Hex <= "1110"; wait for 10 ns;
        i_Hex <= "1111"; wait for 10 ns;

        wait; -- stop simulation
    end process;

end Behavioral;