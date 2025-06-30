LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.constants_types.all;


ENTITY lcd_controller IS
   PORT(
      Clock100MHz : IN  std_logic;
      reset: in std_logic;  

      RS, E   : OUT std_logic;
      lcd_data    : OUT std_logic_vector(3 downto 0);
      
      
      menu_option : IN std_logic_vector(1 downto 0);
      
      a,b,c: out std_logic
      
                
   );
END lcd_controller;


ARCHITECTURE rtl OF lcd_controller IS
   
  SIGNAL counter : natural := 0;

  signal data_buffer  :  std_logic_vector(7 downto 0); 
   
  signal state, next_command         : state_t;
   
  signal clk_count_400hz             : integer range 0 to 50000 := 0;
  signal Clock400Hz            : std_logic;
  
  signal char_index : integer range 0 to 31 := 0;
  signal current_line : std_logic := '0'; 
   
  signal menu_option_internal : std_logic_vector(1 downto 0) := (others => '0');
  signal menu_changed : std_logic := '0'; 
  

 
BEGIN




    process(Clock100MHz)
    begin
        if rising_edge(Clock100MHz) then
            if reset = '0' then
                clk_count_400hz <= 0;
                Clock400Hz <= '0';
            else
                if clk_count_400hz < 50000 then
                    clk_count_400hz <= clk_count_400hz + 1;
                else
                    clk_count_400hz <= 0;
                    Clock400Hz <= not Clock400Hz;
                end if;
            end if;
        end if;
    end process;


   process(Clock400Hz)
   begin
      if rising_edge(Clock400Hz) then
         if reset = '0' then
            menu_option_internal <= (others => '0');
            menu_changed <= '0';
         else
            if menu_option /= menu_option_internal then
               menu_option_internal <= menu_option;
               menu_changed <= '1';
            else
               menu_changed <= '0';
            end if;
         end if;
      end if;
   end process;
   
   

  
  
  
process (Clock400Hz, reset)
begin
        if reset = '0' then
           state <= power_up1;
           data_buffer <= "00110000"; -- RESET
           next_command <= power_up2;
           E <= '1';
           RS <= '0';
           char_index <= 0;
           current_line <= '0';
           lcd_data <= (others => '0');
    
    
    
        elsif rising_edge(Clock400Hz) then
                 
                 case state is                       
                 
                       when power_up1 =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00110000";
                            counter <= counter + 1;
                            if counter = CYCLES_40MS then
                                state <= send_hi;
                                next_command <= power_up2;
                            end if;
                            a <= '0';
                            
                              
                       when power_up2 =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00110000"; 
                            counter <= counter + 1;
                            if counter = CYCLES_4_1MS then
                                state <= send_hi;
                                next_command <= power_up3;
                            end if;
                            
                            
                       when power_up3 =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00110000"; 
                            counter <= counter + 1;
                            if counter = CYCLES_100US then
                                state <= send_hi;
                                next_command <= function_set;
                            end if;
                            
            
                       when function_set => 
                       
                            counter <= 0;    --???           
                            
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00101000";  
                            state <= send_hi;
                            next_command <= display_off;
                            
                             
                       when display_off =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00001000"; 
                            state <= send_hi;
                            next_command <= display_clear;
                           
                           
                       when display_clear =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00000001";  
                            state <= send_hi;
                            next_command <= display_on;
                           
                           
                       when display_on =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00001100";
                            state <= send_hi;
                            next_command <= entry_mode_set ;
                          
                          
                       when entry_mode_set =>
                            E <= '1';
                            RS <= '0';
                            data_buffer <= "00000110"; 
                            state <= send_hi;
                            next_command <= line1; 
                            
                            
                        when line1 =>
                            RS          <= '0';
                            data_buffer <= "10000000";      
                            state       <= send_hi;
                            next_command<= write_char;
                            char_index  <= 0;
                            current_line<= '0';
                        
                        
                        when write_char =>
                            RS <= '1';
                            if current_line = '0' then
                                data_buffer <= MENU_TEXT(to_integer(unsigned(menu_option_internal))).option_name(char_index);
                            else
                                data_buffer <= MENU_TEXT(to_integer(unsigned(menu_option_internal))).option_value(char_index-16);
                            end if;
                        
                        
                            if char_index = 15 then           
                                next_command <= line2;
                            elsif char_index = 31 then        
                                next_command <= idle;
                            else                              
                                next_command <= write_char;
                            end if;
                        
                            
                            if char_index = 31 then
                                char_index <= 0;
                            else
                                char_index <= char_index + 1;
                            end if;
                        
                            E     <= '1';
                            state <= send_hi;                
                            
                            
                        when line2 =>
                            RS          <= '0';
                            data_buffer <= "11000000";      -- 0xC0
                            state       <= send_hi;
                            next_command<= write_char;
                            current_line<= '1';
                        
                        
                        when idle =>
                            E <= '0';
                            if menu_changed = '1' then
                                state <= line1;
                            end if;
                    
                    
                    
                       when SEND_HI =>
                            E <= '1';
                            lcd_data <= data_buffer(7 downto 4);
                            state <= WAIT_HI;
                            
                        when WAIT_HI =>
                            E <= '0';
                            state <= SEND_LO;
                            
                        when SEND_LO =>
                            E <= '1';
                            lcd_data <= data_buffer(3 downto 0);
                            state <= WAIT_LO;
                            
                        when WAIT_LO =>
                            E <= '0';
                            state <= next_command;
                        
                            
                    when others => state <= power_up1;
          end case;     
             
      end if;
      
end process;    

END rtl;
