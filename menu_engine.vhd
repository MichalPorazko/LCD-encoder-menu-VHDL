

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity menu_engine is

port(
      Clock100MHz          : in  std_logic;

     
      Encoder_A        : in  std_logic;
      Encoder_B        : in  std_logic;
      reset      : in  std_logic;

     

      RS, E   : OUT std_logic;
      lcd_data  : out std_logic_vector(3 downto 0)
      
     
   );

end menu_engine;

architecture Behavioral of menu_engine is

  signal menu_option_menu_engine: std_logic_vector(1 downto 0);
  

begin

    encoder : entity work.rotary_encoder
       port map(
          Clock100MHz      => Clock100MHz,
          Encoder_A        => Encoder_A,
          Encoder_B        => Encoder_B,
          menu_option        =>  menu_option_menu_engine
    );
   
    lcd_controller: entity work.lcd_controller
        port map(
            Clock100MHz      => Clock100MHz,
            reset => reset,
            RS => RS,
            E => E,
            lcd_data => lcd_data,
            menu_option => menu_option_menu_engine
     );


end Behavioral;
