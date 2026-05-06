----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2025 09:31:30 PM
-- Design Name: 
-- Module Name: sevenseg_decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenseg_decoder is
    Port ( 
        i_Hex   : in  STD_LOGIC_VECTOR (3 downto 0);
        o_seg_n : out STD_LOGIC_VECTOR (6 downto 0)
    );
end sevenseg_decoder;

architecture Behavioral of sevenseg_decoder is
begin

    -- Active LOW (a b c d e f g)
    with i_Hex select
    o_seg_n <=
        "1000000" when x"0", -- 0
        "1111001" when x"1", -- 1
        "0100100" when x"2", -- 2
        "0110000" when x"3", -- 3
        "0011001" when x"4", -- 4
        "0010010" when x"5", -- 5
        "0000010" when x"6", -- 6
        "1111000" when x"7", -- 7
        "0000000" when x"8", -- 8
        "0010000" when x"9", -- 9

        "0111111" when x"A", -- dash (-)
        "0000011" when x"B", -- b  
        "1000110" when x"C", -- C
        "0100001" when x"D", -- d
        "0000110" when x"E", -- E
        "1111111" when x"F", -- blank

        "1111111" when others;

end Behavioral;
