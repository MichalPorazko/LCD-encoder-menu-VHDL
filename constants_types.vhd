library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




package constants_types is


   constant SYS_CLK_HZ : integer := 100_000_000;
   
   constant DIV_10K: integer := (SYS_CLK_HZ / 10_000);
   constant DIV_1M: integer := (SYS_CLK_HZ / 1_000_000);
   
   
   constant CYCLES_10MS : integer := SYS_CLK_HZ / 100; -- 10 ms
   constant CYCLES_45MS : integer := SYS_CLK_HZ / 1000 * 45; -- 45 ms
   constant CYCLES_5MS : integer := SYS_CLK_HZ / 200; -- 5 ms
   
   constant CYCLES_40MS : integer := SYS_CLK_HZ / 25; -- 40 ms   
   constant CYCLES_4_1MS: integer := DIV_10K*41;
   constant CYCLES_100US: integer := DIV_10K;
   constant CYCLES_1_6MS : integer := DIV_10K * 16; -- 1.6 ms
   constant CYCLES_37US : integer := DIV_1M * 37; 
   constant CYCLES_40US : integer := SYS_CLK_HZ / 25_000; 
   constant CYCLES_10NS: integer := SYS_CLK_HZ / 100_000_000;
   constant CYCLES_1US : integer := DIV_1M; 
   
   
   TYPE state_t IS (power_up1, power_up2, power_up3, power_up4,
                    function_set, display_off, display_clear, display_on, entry_mode_set,
                    line1,   
                    write_char,     
                    line2,          
                    idle, 
                    send_hi, wait_hi, send_lo, wait_lo);
                    
                    
   type option_t is (MI_NAME, MI_INDEX, MI_MAJOR);
   
   subtype LETTER is STD_LOGIC_VECTOR(7 downto 0);
   
   constant CHAR_I : LETTER := "01001001";
   constant CHAR_M : LETTER := "01001101";
   constant CHAR_E : LETTER := "01000101";
   constant CHAR_SPACJA : LETTER := "00100000";
   constant CHAR_N : LETTER := "01001110";
   constant CHAR_A : LETTER := "01000001";
   constant CHAR_Z : LETTER := "01011010";
   constant CHAR_W : LETTER := "01010111";
   constant CHAR_S : LETTER := "01010011";
   constant CHAR_K : LETTER := "01001011";
   constant CHAR_O : LETTER := "01001111";
   constant CHAR_D : LETTER := "01000100";
   constant CHAR_L : LETTER := "01001100";
   constant CHAR_J : LETTER := "01001010";
   constant CHAR_P : LETTER := "01010000";
   constant CHAR_T : LETTER := "01010100";
   constant CHAR_Y : LETTER := "01011001";
   constant CHAR_G : LETTER := "01000111";
   constant CHAR_C : LETTER := "01000011";
   constant CHAR_R : LETTER := "01010010";
   constant CHAR_U : LETTER := "01010101";
   constant CHAR_H : LETTER := "01001000";

   constant CHAR_0 : LETTER := "00110000";
   constant CHAR_1 : LETTER := "00110001";
   constant CHAR_2 : LETTER := "00110010";
   constant CHAR_3 : LETTER := "00110011";
   constant CHAR_4 : LETTER := "00110100";
   constant CHAR_5 : LETTER := "00110101";
   constant CHAR_6 : LETTER := "00110110";
   constant CHAR_7 : LETTER := "00110111";
   constant CHAR_8 : LETTER := "00111000";
   constant CHAR_9 : LETTER := "00111001";
   
   
   type LINE_TEXT is array (0 to 15) of LETTER; 
   
   constant LINE_IMIE_I_NAZWISKO : LINE_TEXT := (
      CHAR_I, CHAR_M, CHAR_I, CHAR_E, CHAR_SPACJA,
      CHAR_N, CHAR_A, CHAR_Z, CHAR_W, CHAR_I,
      CHAR_S, CHAR_K, CHAR_O, CHAR_SPACJA, CHAR_SPACJA, CHAR_SPACJA
   );

   constant LINE_INDEKS : LINE_TEXT := (
      CHAR_I, CHAR_N, CHAR_D, CHAR_E, CHAR_K, CHAR_S, others => 
      CHAR_SPACJA
   );

   constant LINE_KIERUNEK : LINE_TEXT := (
      CHAR_K, CHAR_I, CHAR_E, CHAR_R, CHAR_U,
      CHAR_N, CHAR_E, CHAR_K, 
      others => CHAR_SPACJA
   );

   constant LINE_MICHAL_PORAZKO : LINE_TEXT := (
      CHAR_M, CHAR_I, CHAR_C, CHAR_H, CHAR_A, CHAR_L,
      CHAR_SPACJA,
      CHAR_P, CHAR_O, CHAR_R, CHAR_A, CHAR_Z, CHAR_K, CHAR_O,
      others => CHAR_SPACJA
   );

   constant LINE_268557 : LINE_TEXT := (
      CHAR_2, CHAR_6, CHAR_8, CHAR_5, CHAR_5, CHAR_7,
      others => CHAR_SPACJA
   );

   constant LINE_IEA : LINE_TEXT := (
      CHAR_I, CHAR_E, CHAR_A,
      others => CHAR_SPACJA
   );
   
   constant LINE_POWROT : LINE_TEXT := (
        CHAR_P, CHAR_O, CHAR_W, CHAR_R, CHAR_O, CHAR_T,
        others => CHAR_SPACJA
   );
   
   type menu_option_t is record
       option : option_t;
       option_name : LINE_TEXT;
       option_value: LINE_TEXT;
    end record;
    
    
   
   constant MENU_SIZE : integer := 3;

   type menu_items_array_t is array (0 to MENU_SIZE -1) of menu_option_t; 
      

   constant MENU_TEXT : menu_items_array_t := (
      (option => MI_NAME, option_name => LINE_IMIE_I_NAZWISKO, option_value => LINE_MICHAL_PORAZKO),
      (option => MI_INDEX, option_name => LINE_INDEKS, option_value => LINE_268557),
      (option => MI_MAJOR, option_name => LINE_KIERUNEK, option_value => LINE_IEA)
   );

end constants_types;

package body constants_types is
 
end constants_types;
