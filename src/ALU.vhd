----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;


entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
begin

process(i_A, i_B, i_op)
    variable A_s, B_s : signed(7 downto 0);
    variable res_s    : signed(7 downto 0);
    variable ext_u    : unsigned(8 downto 0); -- for carry
begin
    -- convert inputs
    A_s := signed(i_A);
    B_s := signed(i_B);

    -- defaults
    res_s := (others => '0');
    ext_u := (others => '0');

    case i_op is

        -- =========================
        -- ADD
        -- =========================
        when "000" =>
            res_s := A_s + B_s;

            -- 9-bit unsigned add for carry
            ext_u := resize(unsigned(i_A), 9) + resize(unsigned(i_B), 9);

            o_flags(1) <= ext_u(8); -- Carry

        -- =========================
        -- SUB
        -- =========================
        when "001" =>
            res_s := A_s - B_s;

            -- Carry
            if unsigned(i_A) >= unsigned(i_B) then
                o_flags(1) <= '1';
            else
                o_flags(1) <= '0';
            end if;


        -- AND
        when "010" =>
            res_s := A_s and B_s;
            o_flags(1) <= '0';

        -- OR
        when "011" =>
            res_s := A_s or B_s;
            o_flags(1) <= '0';

        when others =>
            res_s := (others => '0');
            o_flags(1) <= '0';
    end case;

    -- output result
    o_result <= std_logic_vector(res_s);

    -- =========================
    -- FLAGS
    -- =========================

    -- Negative
    o_flags(3) <= res_s(7);

    -- Zero
    if res_s = 0 then
        o_flags(2) <= '1';
    else
        o_flags(2) <= '0';
    end if;

    -- Overflow (signed)
    if (i_op = "000" and (A_s(7) = B_s(7)) and (res_s(7) /= A_s(7))) or
       (i_op = "001" and (A_s(7) /= B_s(7)) and (res_s(7) /= A_s(7))) then
        o_flags(0) <= '1';
    else
        o_flags(0) <= '0';
    end if;

end process;

end Behavioral;
  
