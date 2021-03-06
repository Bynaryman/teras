--------------------------------------------------------------------------------
--                  LZOCShifter_6_to_6_counting_8_F400_uid18
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: I OZb
-- Output signals: Count O

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZOCShifter_6_to_6_counting_8_F400_uid18 is
    port (clk : in std_logic;
          I : in  std_logic_vector(5 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(2 downto 0);
          O : out  std_logic_vector(5 downto 0)   );
end entity;

architecture arch of LZOCShifter_6_to_6_counting_8_F400_uid18 is
signal level3 :  std_logic_vector(5 downto 0);
signal sozb, sozb_d1 :  std_logic;
signal count2, count2_d1 :  std_logic;
signal level2, level2_d1 :  std_logic_vector(5 downto 0);
signal count1, count1_d1 :  std_logic;
signal level1 :  std_logic_vector(5 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(5 downto 0);
signal sCount :  std_logic_vector(2 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sozb_d1 <=  sozb;
            count2_d1 <=  count2;
            level2_d1 <=  level2;
            count1_d1 <=  count1;
         end if;
      end process;
   level3 <= I ;
   sozb<= OZb;
   count2<= '1' when level3(5 downto 2) = (5 downto 2=>sozb) else '0';
   level2<= level3(5 downto 0) when count2='0' else level3(1 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(5 downto 4) = (5 downto 4=>sozb) else '0';
   level1<= level2_d1(5 downto 0) when count1_d1='0' else level2_d1(3 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(5 downto 5) = (5 downto 5=>sozb_d1) else '0';
   level0<= level1(5 downto 0) when count0='0' else level1(4 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count2_d1 & count1_d1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                                Arith_to_S3
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: BSC / UPC - Ledoux Louis
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: arith_i
-- Output signals: S3_o

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Arith_to_S3 is
    port (clk : in std_logic;
          arith_i : in  std_logic_vector(7 downto 0);
          S3_o : out  std_logic_vector(11 downto 0)   );
end entity;

architecture arch of Arith_to_S3 is
   component LZOCShifter_6_to_6_counting_8_F400_uid18 is
      port ( clk : in std_logic;
             I : in  std_logic_vector(5 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(2 downto 0);
             O : out  std_logic_vector(5 downto 0)   );
   end component;

signal sign, sign_d1, sign_d2 :  std_logic;
signal regime_check :  std_logic;
signal remainder :  std_logic_vector(5 downto 0);
signal not_s :  std_logic;
signal zero_NAR :  std_logic;
signal is_NAR, is_NAR_d1, is_NAR_d2 :  std_logic;
signal implicit, implicit_d1, implicit_d2 :  std_logic;
signal neg_count :  std_logic;
signal lzCount :  std_logic_vector(2 downto 0);
signal usefulBits :  std_logic_vector(5 downto 0);
signal extended_neg_count, extended_neg_count_d1 :  std_logic_vector(3 downto 0);
signal comp2_range_count :  std_logic_vector(3 downto 0);
signal fraction, fraction_d1 :  std_logic_vector(4 downto 0);
signal exponent, exponent_d1 :  std_logic_vector(3 downto 0);
signal biased_exponent :  std_logic_vector(3 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sign_d1 <=  sign;
            sign_d2 <=  sign_d1;
            is_NAR_d1 <=  is_NAR;
            is_NAR_d2 <=  is_NAR_d1;
            implicit_d1 <=  implicit;
            implicit_d2 <=  implicit_d1;
            extended_neg_count_d1 <=  extended_neg_count;
            fraction_d1 <=  fraction;
            exponent_d1 <=  exponent;
         end if;
      end process;
sign <= arith_i(7);
regime_check <= arith_i(6);
remainder <= arith_i(5 downto 0);
not_s <= not sign;
zero_NAR <= not regime_check when remainder="000000" else '0';
is_NAR <= zero_NAR and sign;
implicit <= not(zero_NAR and not_s);
neg_count <= not (sign xor regime_check);
   lzoc: LZOCShifter_6_to_6_counting_8_F400_uid18
      port map ( clk  => clk,
                 I => remainder,
                 OZb => regime_check,
                 Count => lzCount,
                 O => usefulBits);
with neg_count  select  extended_neg_count <= 
   "1111" when '1', 
   "0000" when others;
comp2_range_count <= extended_neg_count_d1 xor ("0" & lzCount);
fraction <= usefulBits(4 downto 0);
exponent <= comp2_range_count;
biased_exponent <= exponent_d1 + 6;
S3_o <= is_NAR_d2 & sign_d2 & implicit_d2 & fraction_d1 & biased_exponent;
end architecture;

--------------------------------------------------------------------------------
--              LZOCShifterSticky_32_to_7_counting_64_F400_uid22
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 3 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: I OZb
-- Output signals: Count O Sticky

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZOCShifterSticky_32_to_7_counting_64_F400_uid22 is
    port (clk : in std_logic;
          I : in  std_logic_vector(31 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(5 downto 0);
          O : out  std_logic_vector(6 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of LZOCShifterSticky_32_to_7_counting_64_F400_uid22 is
signal level6 :  std_logic_vector(31 downto 0);
signal sozb, sozb_d1, sozb_d2, sozb_d3 :  std_logic;
signal sticky6 :  std_logic;
signal count5, count5_d1, count5_d2, count5_d3 :  std_logic;
signal level5, level5_d1 :  std_logic_vector(31 downto 0);
signal sticky_high_5 :  std_logic;
signal sticky_low_5 :  std_logic;
signal sticky5, sticky5_d1 :  std_logic;
signal count4, count4_d1, count4_d2 :  std_logic;
signal level4, level4_d1 :  std_logic_vector(30 downto 0);
signal sticky_high_4, sticky_high_4_d1 :  std_logic;
signal sticky_low_4, sticky_low_4_d1 :  std_logic;
signal sticky4, sticky4_d1 :  std_logic;
signal count3, count3_d1, count3_d2 :  std_logic;
signal level3 :  std_logic_vector(14 downto 0);
signal sticky_high_3, sticky_high_3_d1 :  std_logic;
signal sticky_low_3, sticky_low_3_d1 :  std_logic;
signal sticky3 :  std_logic;
signal count2, count2_d1 :  std_logic;
signal level2, level2_d1 :  std_logic_vector(9 downto 0);
signal sticky_high_2 :  std_logic;
signal sticky_low_2 :  std_logic;
signal sticky2, sticky2_d1 :  std_logic;
signal count1, count1_d1 :  std_logic;
signal level1 :  std_logic_vector(7 downto 0);
signal sticky_high_1, sticky_high_1_d1 :  std_logic;
signal sticky_low_1, sticky_low_1_d1, sticky_low_1_d2, sticky_low_1_d3 :  std_logic;
signal sticky1 :  std_logic;
signal count0 :  std_logic;
signal level0 :  std_logic_vector(6 downto 0);
signal sticky_high_0 :  std_logic;
signal sticky_low_0, sticky_low_0_d1, sticky_low_0_d2, sticky_low_0_d3 :  std_logic;
signal sticky0 :  std_logic;
signal sCount :  std_logic_vector(5 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sozb_d1 <=  sozb;
            sozb_d2 <=  sozb_d1;
            sozb_d3 <=  sozb_d2;
            count5_d1 <=  count5;
            count5_d2 <=  count5_d1;
            count5_d3 <=  count5_d2;
            level5_d1 <=  level5;
            sticky5_d1 <=  sticky5;
            count4_d1 <=  count4;
            count4_d2 <=  count4_d1;
            level4_d1 <=  level4;
            sticky_high_4_d1 <=  sticky_high_4;
            sticky_low_4_d1 <=  sticky_low_4;
            sticky4_d1 <=  sticky4;
            count3_d1 <=  count3;
            count3_d2 <=  count3_d1;
            sticky_high_3_d1 <=  sticky_high_3;
            sticky_low_3_d1 <=  sticky_low_3;
            count2_d1 <=  count2;
            level2_d1 <=  level2;
            sticky2_d1 <=  sticky2;
            count1_d1 <=  count1;
            sticky_high_1_d1 <=  sticky_high_1;
            sticky_low_1_d1 <=  sticky_low_1;
            sticky_low_1_d2 <=  sticky_low_1_d1;
            sticky_low_1_d3 <=  sticky_low_1_d2;
            sticky_low_0_d1 <=  sticky_low_0;
            sticky_low_0_d2 <=  sticky_low_0_d1;
            sticky_low_0_d3 <=  sticky_low_0_d2;
         end if;
      end process;
   level6 <= I ;
   sozb<= OZb;
   sticky6 <= '0' ;
   count5<= '1' when level6(31 downto 0) = (31 downto 0=>sozb) else '0';
   level5<= level6(31 downto 0) when count5='0' else (31 downto 0 => '0');
   sticky_high_5<= '0';
   sticky_low_5<= '0';
   sticky5<= sticky6 or sticky_high_5 when count5='0' else sticky6 or sticky_low_5;

   count4<= '1' when level5_d1(31 downto 16) = (31 downto 16=>sozb_d1) else '0';
   level4<= level5_d1(31 downto 1) when count4='0' else level5_d1(15 downto 0) & (14 downto 0 => '0');
   sticky_high_4<= '0'when level5(0 downto 0) = CONV_STD_LOGIC_VECTOR(0,1) else '1';
   sticky_low_4<= '0';
   sticky4<= sticky5_d1 or sticky_high_4_d1 when count4='0' else sticky5_d1 or sticky_low_4_d1;

   count3<= '1' when level4(30 downto 23) = (30 downto 23=>sozb_d1) else '0';
   level3<= level4_d1(30 downto 16) when count3_d1='0' else level4_d1(22 downto 8);
   sticky_high_3<= '0'when level4(15 downto 0) = CONV_STD_LOGIC_VECTOR(0,16) else '1';
   sticky_low_3<= '0'when level4(7 downto 0) = CONV_STD_LOGIC_VECTOR(0,8) else '1';
   sticky3<= sticky4_d1 or sticky_high_3_d1 when count3_d1='0' else sticky4_d1 or sticky_low_3_d1;

   count2<= '1' when level3(14 downto 11) = (14 downto 11=>sozb_d2) else '0';
   level2<= level3(14 downto 5) when count2='0' else level3(10 downto 1);
   sticky_high_2<= '0'when level3(4 downto 0) = CONV_STD_LOGIC_VECTOR(0,5) else '1';
   sticky_low_2<= '0'when level3(0 downto 0) = CONV_STD_LOGIC_VECTOR(0,1) else '1';
   sticky2<= sticky3 or sticky_high_2 when count2='0' else sticky3 or sticky_low_2;

   count1<= '1' when level2(9 downto 8) = (9 downto 8=>sozb_d2) else '0';
   level1<= level2_d1(9 downto 2) when count1_d1='0' else level2_d1(7 downto 0);
   sticky_high_1<= '0'when level2(1 downto 0) = CONV_STD_LOGIC_VECTOR(0,2) else '1';
   sticky_low_1<= '0';
   sticky1<= sticky2_d1 or sticky_high_1_d1 when count1_d1='0' else sticky2_d1 or sticky_low_1_d3;

   count0<= '1' when level1(7 downto 7) = (7 downto 7=>sozb_d3) else '0';
   level0<= level1(7 downto 1) when count0='0' else level1(6 downto 0);
   sticky_high_0<= '0'when level1(0 downto 0) = CONV_STD_LOGIC_VECTOR(0,1) else '1';
   sticky_low_0<= '0';
   sticky0<= sticky1 or sticky_high_0 when count0='0' else sticky1 or sticky_low_0_d3;

   O <= level0;
   sCount <= count5_d3 & count4_d2 & count3_d2 & count2_d1 & count1_d1 & count0;
   Count <= sCount;
   Sticky <= sticky0;
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky8_by_max_8_F400_uid24
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: X S padBit
-- Output signals: R Sticky

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky8_by_max_8_F400_uid24 is
    port (clk : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          S : in  std_logic_vector(3 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(7 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky8_by_max_8_F400_uid24 is
signal ps, ps_d1, ps_d2 :  std_logic_vector(3 downto 0);
signal level4 :  std_logic_vector(7 downto 0);
signal stk3, stk3_d1 :  std_logic;
signal level3, level3_d1 :  std_logic_vector(7 downto 0);
signal stk2 :  std_logic;
signal level2, level2_d1 :  std_logic_vector(7 downto 0);
signal stk1, stk1_d1 :  std_logic;
signal level1, level1_d1, level1_d2 :  std_logic_vector(7 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(7 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ps_d1 <=  ps;
            ps_d2 <=  ps_d1;
            stk3_d1 <=  stk3;
            level3_d1 <=  level3;
            level2_d1 <=  level2;
            stk1_d1 <=  stk1;
            level1_d1 <=  level1;
            level1_d2 <=  level1_d1;
         end if;
      end process;
   ps<= S;
   level4<= X;
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1')   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => padBit) ;
   stk2 <= '1' when (level3_d1(3 downto 0)/="0000" and ps_d1(2)='1') or stk3_d1 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(7 downto 4);
   stk1 <= '1' when (level2_d1(1 downto 0)/="00" and ps_d1(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(7 downto 2);
   stk0 <= '1' when (level1_d2(0 downto 0)/="0" and ps_d2(0)='1') or stk1_d1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(7 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                                    l2a
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Ledoux Louis - BSC / UPC
--------------------------------------------------------------------------------
-- Pipeline depth: 7 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: A isNaN
-- Output signals: arith_o

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity l2a is
    port (clk : in std_logic;
          A : in  std_logic_vector(31 downto 0);
          isNaN : in  std_logic;
          arith_o : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of l2a is
   component LZOCShifterSticky_32_to_7_counting_64_F400_uid22 is
      port ( clk : in std_logic;
             I : in  std_logic_vector(31 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(5 downto 0);
             O : out  std_logic_vector(6 downto 0);
             Sticky : out  std_logic   );
   end component;

   component RightShifterSticky8_by_max_8_F400_uid24 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(7 downto 0);
             S : in  std_logic_vector(3 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(7 downto 0);
             Sticky : out  std_logic   );
   end component;

signal rippled_carry :  std_logic_vector(31 downto 0);
signal count_bit, count_bit_d1, count_bit_d2, count_bit_d3, count_bit_d4, count_bit_d5, count_bit_d6, count_bit_d7 :  std_logic;
signal count_lzoc_o :  std_logic_vector(5 downto 0);
signal frac_lzoc_o :  std_logic_vector(6 downto 0);
signal sticky_lzoc_o, sticky_lzoc_o_d1, sticky_lzoc_o_d2, sticky_lzoc_o_d3 :  std_logic;
signal unbiased_exp :  std_logic_vector(5 downto 0);
signal fraction, fraction_d1, fraction_d2, fraction_d3 :  std_logic_vector(5 downto 0);
signal bin_regime, bin_regime_d1 :  std_logic_vector(3 downto 0);
signal first_regime, first_regime_d1 :  std_logic;
signal regime :  std_logic_vector(3 downto 0);
signal pad :  std_logic;
signal start_regime :  std_logic_vector(1 downto 0);
signal in_shift :  std_logic_vector(7 downto 0);
signal extended_posit :  std_logic_vector(7 downto 0);
signal pre_sticky :  std_logic;
signal truncated_posit, truncated_posit_d1, truncated_posit_d2, truncated_posit_d3 :  std_logic_vector(6 downto 0);
signal lsb, lsb_d1, lsb_d2 :  std_logic;
signal guard, guard_d1, guard_d2 :  std_logic;
signal sticky :  std_logic;
signal round_bit, round_bit_d1 :  std_logic;
signal is_NAR, is_NAR_d1, is_NAR_d2, is_NAR_d3, is_NAR_d4, is_NAR_d5, is_NAR_d6, is_NAR_d7 :  std_logic;
signal rounded_reg_exp_frac :  std_logic_vector(6 downto 0);
signal rounded_posit :  std_logic_vector(7 downto 0);
signal is_zero, is_zero_d1, is_zero_d2, is_zero_d3, is_zero_d4 :  std_logic;
signal rounded_posit_zero :  std_logic_vector(7 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            count_bit_d1 <=  count_bit;
            count_bit_d2 <=  count_bit_d1;
            count_bit_d3 <=  count_bit_d2;
            count_bit_d4 <=  count_bit_d3;
            count_bit_d5 <=  count_bit_d4;
            count_bit_d6 <=  count_bit_d5;
            count_bit_d7 <=  count_bit_d6;
            sticky_lzoc_o_d1 <=  sticky_lzoc_o;
            sticky_lzoc_o_d2 <=  sticky_lzoc_o_d1;
            sticky_lzoc_o_d3 <=  sticky_lzoc_o_d2;
            fraction_d1 <=  fraction;
            fraction_d2 <=  fraction_d1;
            fraction_d3 <=  fraction_d2;
            bin_regime_d1 <=  bin_regime;
            first_regime_d1 <=  first_regime;
            truncated_posit_d1 <=  truncated_posit;
            truncated_posit_d2 <=  truncated_posit_d1;
            truncated_posit_d3 <=  truncated_posit_d2;
            lsb_d1 <=  lsb;
            lsb_d2 <=  lsb_d1;
            guard_d1 <=  guard;
            guard_d2 <=  guard_d1;
            round_bit_d1 <=  round_bit;
            is_NAR_d1 <=  is_NAR;
            is_NAR_d2 <=  is_NAR_d1;
            is_NAR_d3 <=  is_NAR_d2;
            is_NAR_d4 <=  is_NAR_d3;
            is_NAR_d5 <=  is_NAR_d4;
            is_NAR_d6 <=  is_NAR_d5;
            is_NAR_d7 <=  is_NAR_d6;
            is_zero_d1 <=  is_zero;
            is_zero_d2 <=  is_zero_d1;
            is_zero_d3 <=  is_zero_d2;
            is_zero_d4 <=  is_zero_d3;
         end if;
      end process;

   rippled_carry <= A;

--------------- Count 0/1 while shifting and sticky computation ---------------
   count_bit <= rippled_carry(31);
   lzoc_inst: LZOCShifterSticky_32_to_7_counting_64_F400_uid22
      port map ( clk  => clk,
                 I => rippled_carry,
                 OZb => count_bit,
                 Count => count_lzoc_o,
                 O => frac_lzoc_o,
                 Sticky => sticky_lzoc_o);

----------- Compute unbiased exponent from msb weigth and lzoc count -----------
   unbiased_exp <= CONV_STD_LOGIC_VECTOR(19,6) - (count_lzoc_o);
   fraction <= frac_lzoc_o (5 downto 0);
bin_regime<= unbiased_exp(3 downto 0);
first_regime<= unbiased_exp(5);
with first_regime_d1  select  regime <= 
   bin_regime_d1 when '0', 
   not bin_regime_d1 when others;
pad<= not(first_regime_d1 xor count_bit_d4);
with pad  select  start_regime <= 
   "01" when '0', 
   "10" when others; 
in_shift <= start_regime & fraction_d1;
   rshift: RightShifterSticky8_by_max_8_F400_uid24
      port map ( clk  => clk,
                 S => regime,
                 X => in_shift,
                 padBit => pad,
                 R => extended_posit,
                 Sticky => pre_sticky);
truncated_posit<= extended_posit(7 downto 1);
lsb <= extended_posit(1);
guard <= extended_posit(0);
sticky <= fraction_d3(0) or pre_sticky or sticky_lzoc_o_d3;
round_bit<= guard_d2 and (sticky or lsb_d2);
is_NAR<= isNaN;
rounded_reg_exp_frac<= truncated_posit_d3 + round_bit_d1;
rounded_posit <= count_bit_d7 & rounded_reg_exp_frac;
is_zero <= count_lzoc_o(5) when fraction="000000" else '0';
rounded_posit_zero<= rounded_posit when is_zero_d4= '0' else "00000000";
arith_o <= rounded_posit_zero when is_NAR_d7 = '0' else "10000000";
end architecture;

--------------------------------------------------------------------------------
--                          DSPBlock_6x6_F400_uid35
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: X Y
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity DSPBlock_6x6_F400_uid35 is
    port (clk : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          Y : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(11 downto 0)   );
end entity;

architecture arch of DSPBlock_6x6_F400_uid35 is
signal Mint :  std_logic_vector(11 downto 0);
signal M :  std_logic_vector(11 downto 0);
signal Rtmp :  std_logic_vector(11 downto 0);
begin
   Mint <= std_logic_vector(unsigned(X) * unsigned(Y)); -- multiplier
   M <= Mint(11 downto 0);
   Rtmp <= M;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                          IntMultiplier_F400_uid31
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Martin Kumm, Florent de Dinechin, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: X Y
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_F400_uid31 is
    port (clk : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          Y : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(11 downto 0)   );
end entity;

architecture arch of IntMultiplier_F400_uid31 is
   component DSPBlock_6x6_F400_uid35 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(11 downto 0)   );
   end component;

signal XX_m32 :  std_logic_vector(5 downto 0);
signal YY_m32 :  std_logic_vector(5 downto 0);
signal tile_0_X :  std_logic_vector(5 downto 0);
signal tile_0_Y :  std_logic_vector(5 downto 0);
signal tile_0_output :  std_logic_vector(11 downto 0);
signal tile_0_filtered_output :  std_logic_vector(11 downto 0);
signal bh33_w0_0 :  std_logic;
signal bh33_w1_0 :  std_logic;
signal bh33_w2_0 :  std_logic;
signal bh33_w3_0 :  std_logic;
signal bh33_w4_0 :  std_logic;
signal bh33_w5_0 :  std_logic;
signal bh33_w6_0 :  std_logic;
signal bh33_w7_0 :  std_logic;
signal bh33_w8_0 :  std_logic;
signal bh33_w9_0 :  std_logic;
signal bh33_w10_0 :  std_logic;
signal bh33_w11_0 :  std_logic;
signal tmp_bitheapResult_bh33_11 :  std_logic_vector(11 downto 0);
signal bitheapResult_bh33 :  std_logic_vector(11 downto 0);
begin
   XX_m32 <= X ;
   YY_m32 <= Y ;
   tile_0_X <= X(5 downto 0);
   tile_0_Y <= Y(5 downto 0);
   tile_0_mult: DSPBlock_6x6_F400_uid35
      port map ( clk  => clk,
                 X => tile_0_X,
                 Y => tile_0_Y,
                 R => tile_0_output);

tile_0_filtered_output <= tile_0_output(11 downto 0);
   bh33_w0_0 <= tile_0_filtered_output(0);
   bh33_w1_0 <= tile_0_filtered_output(1);
   bh33_w2_0 <= tile_0_filtered_output(2);
   bh33_w3_0 <= tile_0_filtered_output(3);
   bh33_w4_0 <= tile_0_filtered_output(4);
   bh33_w5_0 <= tile_0_filtered_output(5);
   bh33_w6_0 <= tile_0_filtered_output(6);
   bh33_w7_0 <= tile_0_filtered_output(7);
   bh33_w8_0 <= tile_0_filtered_output(8);
   bh33_w9_0 <= tile_0_filtered_output(9);
   bh33_w10_0 <= tile_0_filtered_output(10);
   bh33_w11_0 <= tile_0_filtered_output(11);

   -- Adding the constant bits
      -- All the constant bits are zero, nothing to add

   tmp_bitheapResult_bh33_11 <= bh33_w11_0 & bh33_w10_0 & bh33_w9_0 & bh33_w8_0 & bh33_w7_0 & bh33_w6_0 & bh33_w5_0 & bh33_w4_0 & bh33_w3_0 & bh33_w2_0 & bh33_w1_0 & bh33_w0_0;
   bitheapResult_bh33 <= tmp_bitheapResult_bh33_11;
   R <= bitheapResult_bh33(11 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                     LeftShifter12_by_max_31_F400_uid38
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: X S padBit
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LeftShifter12_by_max_31_F400_uid38 is
    port (clk : in std_logic;
          X : in  std_logic_vector(11 downto 0);
          S : in  std_logic_vector(4 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(42 downto 0)   );
end entity;

architecture arch of LeftShifter12_by_max_31_F400_uid38 is
signal ps, ps_d1 :  std_logic_vector(4 downto 0);
signal level0 :  std_logic_vector(11 downto 0);
signal level1, level1_d1 :  std_logic_vector(12 downto 0);
signal level2 :  std_logic_vector(14 downto 0);
signal level3 :  std_logic_vector(18 downto 0);
signal level4 :  std_logic_vector(26 downto 0);
signal level5 :  std_logic_vector(42 downto 0);
signal padBit_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ps_d1 <=  ps;
            level1_d1 <=  level1;
            padBit_d1 <=  padBit;
         end if;
      end process;
   ps<= S;
   level0<= X;
   level1<= level0 & (0 downto 0 => '0') when ps(0)= '1' else     (0 downto 0 => padBit) & level0;
   level2<= level1_d1 & (1 downto 0 => '0') when ps_d1(1)= '1' else     (1 downto 0 => padBit_d1) & level1_d1;
   level3<= level2 & (3 downto 0 => '0') when ps_d1(2)= '1' else     (3 downto 0 => padBit_d1) & level2;
   level4<= level3 & (7 downto 0 => '0') when ps_d1(3)= '1' else     (7 downto 0 => padBit_d1) & level3;
   level5<= level4 & (15 downto 0 => '0') when ps_d1(4)= '1' else     (15 downto 0 => padBit_d1) & level4;
   R <= level5(42 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                                   s3fdp
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Ledoux Louis - BSC / UPC
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: S3_x S3_y FTZ EOB
-- Output signals: A EOB_Q isNaN

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity s3fdp is
    port (clk, rst : in std_logic;
          S3_x : in  std_logic_vector(11 downto 0);
          S3_y : in  std_logic_vector(11 downto 0);
          FTZ : in  std_logic;
          EOB : in  std_logic;
          A : out  std_logic_vector(31 downto 0);
          EOB_Q : out  std_logic;
          isNaN : out  std_logic   );
end entity;

architecture arch of s3fdp is
   component IntMultiplier_F400_uid31 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(11 downto 0)   );
   end component;

   component LeftShifter12_by_max_31_F400_uid38 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(11 downto 0);
             S : in  std_logic_vector(4 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(42 downto 0)   );
   end component;

signal sign_X :  std_logic;
signal sign_Y :  std_logic;
signal sign_M, sign_M_d1 :  std_logic;
signal isNaN_X :  std_logic;
signal isNaN_Y :  std_logic;
signal isNaN_M, isNaN_M_d1 :  std_logic;
signal significand_X :  std_logic_vector(5 downto 0);
signal significand_Y :  std_logic_vector(5 downto 0);
signal significand_product :  std_logic_vector(11 downto 0);
signal scale_X_biased :  std_logic_vector(3 downto 0);
signal scale_Y_biased :  std_logic_vector(3 downto 0);
signal scale_product_twice_biased :  std_logic_vector(4 downto 0);
signal significand_product_cpt1 :  std_logic_vector(11 downto 0);
signal shift_value :  std_logic_vector(4 downto 0);
signal shifted_significand :  std_logic_vector(42 downto 0);
signal too_small, too_small_d1 :  std_logic;
signal too_big, too_big_d1 :  std_logic;
signal ext_summand1c :  std_logic_vector(31 downto 0);
signal not_ftz, not_ftz_d1 :  std_logic;
signal EOB_internal, EOB_internal_d1, EOB_internal_d2 :  std_logic;
signal not_ftz_sync :  std_logic;
signal carry_0_sync :  std_logic;
signal EOB_internal_delayed :  std_logic;
signal isNaN_M_sync :  std_logic;
signal too_big_sync :  std_logic;
signal isNaN_o, isNaN_o_d1 :  std_logic;
signal isNaN_delayed :  std_logic;
signal carry_0 :  std_logic;
signal summand_0 :  std_logic_vector(31 downto 0);
signal summand_and_carry_0 :  std_logic_vector(32 downto 0);
signal acc_0, acc_0_d1 :  std_logic_vector(32 downto 0);
signal acc_0_q :  std_logic_vector(32 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sign_M_d1 <=  sign_M;
            isNaN_M_d1 <=  isNaN_M;
            too_small_d1 <=  too_small;
            too_big_d1 <=  too_big;
            not_ftz_d1 <=  not_ftz;
            EOB_internal_d1 <=  EOB_internal;
            EOB_internal_d2 <=  EOB_internal_d1;
         end if;
      end process;
   process(clk, rst)
      begin
         if rst = '1' then
            isNaN_o_d1 <=  '0';
            acc_0_d1 <=  (others => '0');
         elsif clk'event and clk = '1' then
            isNaN_o_d1 <=  isNaN_o;
            acc_0_d1 <=  acc_0;
         end if;
      end process;
--------------------------- sign product processing ---------------------------
   sign_X <= S3_x(10);
   sign_Y <= S3_y(10);
   sign_M <= sign_X xor sign_Y;

---------------------------- NaN product processing ----------------------------
   isNaN_X <= S3_x(11);
   isNaN_Y <= S3_y(11);
   isNaN_M <= isNaN_X or isNaN_Y;

---------------------------- significand processing ----------------------------
   significand_X <= S3_x(9 downto 4);
   significand_Y <= S3_y(9 downto 4);
   significand_product_inst: IntMultiplier_F400_uid31
      port map ( clk  => clk,
                 X => significand_X,
                 Y => significand_Y,
                 R => significand_product);

------------------------------- scale processing -------------------------------
   scale_X_biased <= S3_x(3 downto 0);
   scale_Y_biased <= S3_y(3 downto 0);
   scale_product_twice_biased <= ("0" & scale_X_biased) + ("0" & scale_Y_biased);

--------------------------- pre-shift xoring (cpt1) ---------------------------
   significand_product_cpt1 <= significand_product when sign_M='0' else not(significand_product);

------------------------- significand product shifting -------------------------
   shift_value <= (scale_product_twice_biased) - (-1);
   significand_product_shifter_inst: LeftShifter12_by_max_31_F400_uid38
      port map ( clk  => clk,
                 S => shift_value,
                 X => significand_product_cpt1,
                 padBit => sign_M,
                 R => shifted_significand);

-------------- detect too low scale for this specific scratchpad --------------
   too_small <= '1' when (shift_value(4)='1') else '0';

-------------- detect too big scale for this specific scratchpad --------------
   too_big <= '1' when (unsigned(shift_value) > 24 and too_small='0') else '0';

--------------- shifted significand part select to form summand ---------------
   ext_summand1c <= "00000000000000000000000000000000" when too_small_d1='1' else shifted_significand(42 downto 11);
----------------------------- Syncing some signals -----------------------------
   not_ftz <= not FTZ;
   EOB_internal <= EOB;
   not_ftz_sync <= not_ftz_d1;
   carry_0_sync <= sign_M_d1;
   EOB_internal_delayed <= EOB_internal_d2;
   isNaN_M_sync <= isNaN_M_d1;
   too_big_sync <= too_big_d1;

------------------------------ Output isNaN latch ------------------------------
   isNaN_o <= (too_big_sync or isNaN_M_sync or isNaN_delayed) when not_ftz_sync='1' else '0';
   isNaN_delayed <= isNaN_o_d1;

---------------------------- Carry Save Accumulator ----------------------------
   -- DQ logic
   acc_0_q <= acc_0_d1;

   -- sequential addition logic
   carry_0 <= carry_0_sync;
   summand_0 <= ext_summand1c(31 downto 0);
   summand_and_carry_0 <= ("0" & summand_0) + carry_0;
   acc_0 <= (("0" & acc_0_q(31 downto 0)) + summand_and_carry_0) when (not_ftz_sync='1') else
            summand_and_carry_0;

-------------------------------- Output Compose --------------------------------
   A <= acc_0_q(31 downto 0);

   EOB_Q <= EOB_internal_delayed;
   isNaN <= isNaN_delayed;
end architecture;

--------------------------------------------------------------------------------
--                                   PE_S3
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Ledoux Louis - BSC / UPC
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: s3_row_i_A s3_col_j_B C_out SOB EOB
-- Output signals: s3_row_im1_A s3_col_jm1_B SOB_Q EOB_Q C_out_Q

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PE_S3 is
    port (clk, rst : in std_logic;
          s3_row_i_A : in  std_logic_vector(11 downto 0);
          s3_col_j_B : in  std_logic_vector(11 downto 0);
          C_out : in  std_logic_vector(32 downto 0);
          SOB : in  std_logic;
          EOB : in  std_logic;
          s3_row_im1_A : out  std_logic_vector(11 downto 0);
          s3_col_jm1_B : out  std_logic_vector(11 downto 0);
          SOB_Q : out  std_logic;
          EOB_Q : out  std_logic;
          C_out_Q : out  std_logic_vector(32 downto 0)   );
end entity;

architecture arch of PE_S3 is
   component s3fdp is
      port ( clk, rst : in std_logic;
             S3_x : in  std_logic_vector(11 downto 0);
             S3_y : in  std_logic_vector(11 downto 0);
             FTZ : in  std_logic;
             EOB : in  std_logic;
             A : out  std_logic_vector(31 downto 0);
             EOB_Q : out  std_logic;
             isNaN : out  std_logic   );
   end component;

signal s3_row_i_A_q :  std_logic_vector(11 downto 0);
signal s3_col_j_B_q :  std_logic_vector(11 downto 0);
signal sob_delayed :  std_logic;
signal eob_delayed :  std_logic;
signal mux_C_out, mux_C_out_d1, mux_C_out_d2 :  std_logic_vector(32 downto 0);
signal mux_C_out_HSSD :  std_logic_vector(32 downto 0);
signal isNaN_s3fdp :  std_logic;
signal EOB_s3fdp :  std_logic;
signal A_s3fdp :  std_logic_vector(31 downto 0);
signal s3_row_i_A_d1 :  std_logic_vector(11 downto 0);
signal s3_col_j_B_d1 :  std_logic_vector(11 downto 0);
signal SOB_d1 :  std_logic;
signal EOB_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            mux_C_out_d1 <=  mux_C_out;
            mux_C_out_d2 <=  mux_C_out_d1;
            s3_row_i_A_d1 <=  s3_row_i_A;
            s3_col_j_B_d1 <=  s3_col_j_B;
            SOB_d1 <=  SOB;
            EOB_d1 <=  EOB;
         end if;
      end process;
------------------------ Functional delay z-1 of inputs ------------------------
   s3_row_i_A_q <= s3_row_i_A_d1;
   s3_col_j_B_q <= s3_col_j_B_d1;

------------------------- DQ flip flop for SOB and EOB -------------------------
   sob_delayed <= SOB_d1;
   eob_delayed <= EOB_d1;

----------------------------- Half Speed Sink Down -----------------------------
   with EOB_s3fdp  select  mux_C_out <= 
        (isNaN_s3fdp & A_s3fdp) when '1', 
        C_out when others;
   mux_C_out_HSSD <= mux_C_out_d2;

---------------------------- Instantiates the S3FDP ----------------------------
   s3fdp_inst: s3fdp
      port map ( clk => clk,
                 rst  => rst,
                 EOB => EOB,
                 FTZ => SOB,
                 S3_x => s3_row_i_A,
                 S3_y => s3_col_j_B,
                 A => A_s3fdp,
                 EOB_Q => EOB_s3fdp,
                 isNaN => isNaN_s3fdp);

------------------------- Compose the outputs signals -------------------------
   s3_row_im1_A <= s3_row_i_A_q;
   s3_col_jm1_B <= s3_col_j_B_q;
   SOB_Q <= sob_delayed;
   EOB_Q <= eob_delayed;
   C_out_Q <= mux_C_out_HSSD;
end architecture;

--------------------------------------------------------------------------------
--                            SystolicArrayKernel
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Ledoux Louis - BSC / UPC
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: rowsA colsB SOB EOB
-- Output signals: colsC EOB_Q_o

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity SystolicArrayKernel is
    port (clk, rst : in std_logic;
          rowsA : in  std_logic_vector(35 downto 0);
          colsB : in  std_logic_vector(35 downto 0);
          SOB : in  std_logic;
          EOB : in  std_logic;
          colsC : out  std_logic_vector(98 downto 0);
          EOB_Q_o : out  std_logic   );
end entity;

architecture arch of SystolicArrayKernel is
   component PE_S3 is
      port ( clk, rst : in std_logic;
             s3_row_i_A : in  std_logic_vector(11 downto 0);
             s3_col_j_B : in  std_logic_vector(11 downto 0);
             C_out : in  std_logic_vector(32 downto 0);
             SOB : in  std_logic;
             EOB : in  std_logic;
             s3_row_im1_A : out  std_logic_vector(11 downto 0);
             s3_col_jm1_B : out  std_logic_vector(11 downto 0);
             SOB_Q : out  std_logic;
             EOB_Q : out  std_logic;
             C_out_Q : out  std_logic_vector(32 downto 0)   );
   end component;

type T_2D_LAICPT2_np1_m is array(3 downto 0, 2 downto 0) of std_logic_vector(32 downto 0);
type T_2D_n_mp1 is array(2 downto 0, 3 downto 0) of std_logic_vector(11 downto 0);
type T_2D_np1_m is array(3 downto 0, 2 downto 0) of std_logic_vector(11 downto 0);
type T_2D_np1_m_logic is array(3 downto 0, 2 downto 0) of std_logic;
signal systolic_wires_rows_2D : T_2D_n_mp1;
signal systolic_wires_cols_2D : T_2D_np1_m;
signal systolic_sob_2D : T_2D_np1_m_logic;
signal systolic_eob_2D : T_2D_np1_m_logic;
signal systolic_C_out_2D : T_2D_LAICPT2_np1_m;
begin

----------------- Connect bus of B columns to top edges SA PEs -----------------
   cols_in: for JJ in 0 to 2 generate
      systolic_wires_cols_2D(0,JJ) <= colsB(((JJ+1)*12)-1 downto (JJ*12));
   end generate;

------------------ Connect bus of A rows to left edges SA PEs ------------------
   rows_in: for II in 0 to 2 generate
      systolic_wires_rows_2D(II,0) <= rowsA(((II+1)*12)-1 downto (II*12));
   end generate;

-------------- Connect the Start of Block signals of the TOP PEs --------------
   systolic_sob_2D(0,0) <= SOB;
   sob_1st_row: for JJ in 1 to 2 generate
      systolic_sob_2D(0,JJ) <= systolic_sob_2D(1,JJ-1);
   end generate;

--------------- Connect the End of Block signals of the TOP PEs ---------------
   systolic_eob_2D(0,0) <= EOB;
   eob_1st_row: for JJ in 1 to 2 generate
      systolic_eob_2D(0,JJ) <= systolic_eob_2D(1,JJ-1);
   end generate;

----------- Connect with 0s the input C carry out scheme of TOP PEs -----------
   C_out_input_1st_row: for JJ in 0 to 2 generate
      systolic_C_out_2D(0,JJ) <= "000000000000000000000000000000000";
   end generate;

------------------------- Connect PEs locally together -------------------------
   rows: for II in 0 to 2 generate
      cols: for JJ in 0 to 2 generate
         PE_ij: PE_S3
            port map ( clk => clk,
                       rst => rst,
                       s3_row_i_A => systolic_wires_rows_2D(II,JJ),
                       s3_col_j_B => systolic_wires_cols_2D(II,JJ),
                       SOB => systolic_sob_2D(II,JJ),
                       SOB_Q => systolic_sob_2D(II+1,JJ),
                       EOB => systolic_eob_2D(II,JJ),
                       EOB_Q => systolic_eob_2D(II+1,JJ),
                       C_out => systolic_C_out_2D(II,JJ),
                       C_out_Q => systolic_C_out_2D(II+1,JJ),
                       s3_row_im1_A => systolic_wires_rows_2D(II,JJ+1),
                       s3_col_jm1_B => systolic_wires_cols_2D(II+1,JJ));
      end generate;
   end generate;

------------------ Connect last row output C to output C bus ------------------
   cols_C_out: for JJ in 0 to 2 generate
      colsC(((JJ+1)*33)-1 downto (JJ*33)) <= systolic_C_out_2D(3,JJ);
   end generate;

------ Connect PE(N-1,M-1) EOB_Q to out world for valid data computation ------
   EOB_Q_o <= systolic_eob_2D(3,2);

end architecture;

--------------------------------------------------------------------------------
--                               SystolicArray
--               (SA_orthogonal_3w3h_posit_8_0_HSSD_F400_uid2)
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Ledoux Louis - BSC / UPC
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: rowsA colsB SOB EOB
-- Output signals: colsC EOB_Q_o

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity SystolicArray is
    port (clk, rst : in std_logic;
          rowsA : in  std_logic_vector(23 downto 0);
          colsB : in  std_logic_vector(23 downto 0);
          SOB : in  std_logic;
          EOB : in  std_logic;
          colsC : out  std_logic_vector(23 downto 0);
          EOB_Q_o : out  std_logic   );
end entity;

architecture arch of SystolicArray is
   component Arith_to_S3 is
      port ( clk : in std_logic;
             arith_i : in  std_logic_vector(7 downto 0);
             S3_o : out  std_logic_vector(11 downto 0)   );
   end component;

   component l2a is
      port ( clk : in std_logic;
             A : in  std_logic_vector(31 downto 0);
             isNaN : in  std_logic;
             arith_o : out  std_logic_vector(7 downto 0)   );
   end component;

   component SystolicArrayKernel is
      port ( clk, rst : in std_logic;
             rowsA : in  std_logic_vector(35 downto 0);
             colsB : in  std_logic_vector(35 downto 0);
             SOB : in  std_logic;
             EOB : in  std_logic;
             colsC : out  std_logic_vector(98 downto 0);
             EOB_Q_o : out  std_logic   );
   end component;

type array_M_dense is array(2 downto 0) of std_logic_vector(7 downto 0);
type array_M_s3 is array(2 downto 0) of std_logic_vector(11 downto 0);
type array_N_dense is array(2 downto 0) of std_logic_vector(7 downto 0);
type array_N_s3 is array(2 downto 0) of std_logic_vector(11 downto 0);
signal arith_in_row_0 :  std_logic_vector(7 downto 0);
signal arith_in_row_0_q0 :  std_logic_vector(7 downto 0);
signal arith_in_row_1, arith_in_row_1_d1 :  std_logic_vector(7 downto 0);
signal arith_in_row_1_q1 :  std_logic_vector(7 downto 0);
signal arith_in_row_2, arith_in_row_2_d1, arith_in_row_2_d2 :  std_logic_vector(7 downto 0);
signal arith_in_row_2_q2 :  std_logic_vector(7 downto 0);
signal arith_in_col_0 :  std_logic_vector(7 downto 0);
signal arith_in_col_0_q0 :  std_logic_vector(7 downto 0);
signal arith_in_col_1, arith_in_col_1_d1 :  std_logic_vector(7 downto 0);
signal arith_in_col_1_q1 :  std_logic_vector(7 downto 0);
signal arith_in_col_2, arith_in_col_2_d1, arith_in_col_2_d2 :  std_logic_vector(7 downto 0);
signal arith_in_col_2_q2 :  std_logic_vector(7 downto 0);
signal colsC_LAICPT2 :  std_logic_vector(98 downto 0);
signal SOB_select, SOB_select_d1, SOB_select_d2 :  std_logic;
signal SOB_q2 :  std_logic;
signal EOB_select, EOB_select_d1, EOB_select_d2 :  std_logic;
signal EOB_q2 :  std_logic;
signal LAICPT2_to_arith :  std_logic_vector(23 downto 0);
signal arith_out_col_out_0, arith_out_col_out_0_d1, arith_out_col_out_0_d2 :  std_logic_vector(7 downto 0);
signal arith_out_col_out_0_q2 :  std_logic_vector(7 downto 0);
signal arith_out_col_out_1, arith_out_col_out_1_d1 :  std_logic_vector(7 downto 0);
signal arith_out_col_out_1_q1 :  std_logic_vector(7 downto 0);
signal arith_out_col_out_2 :  std_logic_vector(7 downto 0);
signal arith_out_col_out_2_q0 :  std_logic_vector(7 downto 0);
signal rows_i_arith : array_N_dense;
signal rows_i_s3 :  std_logic_vector(35 downto 0);
signal cols_j_arith : array_M_dense;
signal cols_j_s3 :  std_logic_vector(35 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            arith_in_row_1_d1 <=  arith_in_row_1;
            arith_in_row_2_d1 <=  arith_in_row_2;
            arith_in_row_2_d2 <=  arith_in_row_2_d1;
            arith_in_col_1_d1 <=  arith_in_col_1;
            arith_in_col_2_d1 <=  arith_in_col_2;
            arith_in_col_2_d2 <=  arith_in_col_2_d1;
            SOB_select_d1 <=  SOB_select;
            SOB_select_d2 <=  SOB_select_d1;
            EOB_select_d1 <=  EOB_select;
            EOB_select_d2 <=  EOB_select_d1;
            arith_out_col_out_0_d1 <=  arith_out_col_out_0;
            arith_out_col_out_0_d2 <=  arith_out_col_out_0_d1;
            arith_out_col_out_1_d1 <=  arith_out_col_out_1;
         end if;
      end process;
------------ Delay depending on row index incoming dense arithmetic ------------
   arith_in_row_0 <= rowsA(7 downto 0);
   arith_in_row_0_q0 <= arith_in_row_0;
   arith_in_row_1 <= rowsA(15 downto 8);
   arith_in_row_1_q1 <= arith_in_row_1_d1;
   arith_in_row_2 <= rowsA(23 downto 16);
   arith_in_row_2_q2 <= arith_in_row_2_d2;

------------ Delay depending on col index incoming dense arithmetic ------------
   arith_in_col_0 <= colsB(7 downto 0);
   arith_in_col_0_q0 <= arith_in_col_0;
   arith_in_col_1 <= colsB(15 downto 8);
   arith_in_col_1_q1 <= arith_in_col_1_d1;
   arith_in_col_2 <= colsB(23 downto 16);
   arith_in_col_2_q2 <= arith_in_col_2_d2;

--------------- Delay SOB/EOB with Arith_to_S3 delay to feed SAK ---------------
   SOB_select <= SOB;
   SOB_q2 <= SOB_select_d2;
   EOB_select <= EOB;
   EOB_q2 <= EOB_select_d2;

--------------- Delay outgoing arithmetic depending on col index ---------------
   arith_out_col_out_0 <= LAICPT2_to_arith(7 downto 0);
   arith_out_col_out_0_q2 <= arith_out_col_out_0_d2;
   arith_out_col_out_1 <= LAICPT2_to_arith(15 downto 8);
   arith_out_col_out_1_q1 <= arith_out_col_out_1_d1;
   arith_out_col_out_2 <= LAICPT2_to_arith(23 downto 16);
   arith_out_col_out_2_q0 <= arith_out_col_out_2;

---------------- Generate Arith_to_S3 for rows and connect them ----------------
   rows_i_arith(0) <= arith_in_row_0_q0;
   rows_i_arith(1) <= arith_in_row_1_q1;
   rows_i_arith(2) <= arith_in_row_2_q2;
   rows_a2s3: for II in 0 to 2 generate
      a2s3_i: Arith_to_S3
         port map ( clk => clk,
                    arith_i => rows_i_arith(II),
                    s3_o => rows_i_s3(((II+1)*12)-1 downto II*12));
   end generate;

---------------- Generate Arith_to_S3 for cols and connect them ----------------
   cols_j_arith(0) <= arith_in_col_0_q0;
   cols_j_arith(1) <= arith_in_col_1_q1;
   cols_j_arith(2) <= arith_in_col_2_q2;
   cols_a2s3: for JJ in 0 to 2 generate
      a2s3_j: Arith_to_S3
         port map ( clk => clk,
                    arith_i => cols_j_arith(JJ),
                    s3_o => cols_j_s3(((JJ+1)*12)-1 downto JJ*12));
   end generate;

-------------------- Instantiate the Systolic Array Kernel --------------------
   sak: SystolicArrayKernel
      port map ( clk => clk,
                 rst => rst,
                 rowsA => rows_i_s3,
                 colsB => cols_j_s3,
                 SOB => SOB_q2,
                 EOB => EOB_q2,
                 EOB_Q_o => EOB_Q_o,
                 colsC => colsC_LAICPT2 );

-------------------------- Generate LAICPT2_to_arith --------------------------
   cols_l2a: for JJ in 0 to 2 generate
      l2a_i: l2a
         port map ( clk => clk,
                    A => colsC_LAICPT2(((JJ+1)*33)-1-1-0 downto JJ*33),
                    isNaN => colsC_LAICPT2(((JJ+1)*33)- 1),
                    arith_o => LAICPT2_to_arith(((JJ+1)*8)-1 downto JJ*8));
   end generate;

-------- Connect outgoing delayed dense arith words to colsC output bus --------
   colsC(7 downto 0) <= arith_out_col_out_0_q2;
   colsC(15 downto 8) <= arith_out_col_out_1_q1;
   colsC(23 downto 16) <= arith_out_col_out_2_q0;

end architecture;

