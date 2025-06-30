library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity rotary_encoder is

   port (
        Clock100MHz         : in  std_logic;
        Encoder_A  : in  std_logic;  
        Encoder_B  : in  std_logic;  
        menu_option  : out std_logic_vector(1 downto 0)
    );

end rotary_encoder;

architecture Behavioral of rotary_encoder is

   signal A_clean, B_clean : std_logic;
   
   signal menu_option_internal: std_logic_vector(1 downto 0) := (others => '0');
   
begin

    signalA : Entity work.encoder_signal
        generic map (
            CLK_FREQ_HZ => 100_000_000,  
            DEBOUNCE_MS => 3            
        )
        port map (
            Clock100MHz=> Clock100MHz,
            noisy_in  => Encoder_A,
            clean_out => A_clean
        );


    signalB : Entity work.encoder_signal
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            DEBOUNCE_MS => 3
        )
        port map (
            Clock100MHz        => Clock100MHz ,
            noisy_in  => Encoder_B,
            clean_out => B_clean
        );
  
  
  
 process(Clock100MHz)
    variable last_A  : std_logic := '0';
    variable last_B  : std_logic := '0';
begin
    if rising_edge(Clock100MHz) then
        if last_A /= A_clean then
            if A_clean = '1' then 
                if B_clean = '0' then
                    menu_option_internal <= menu_option_internal + '1';
                else
                    menu_option_internal <= menu_option_internal + '1';
                end if;
            end if;
        end if;
        
        if menu_option_internal = "11" then
                menu_option_internal <= (others => '0');
        end if;
        
        last_A := A_clean;
        last_B := B_clean;
        
        menu_option <= menu_option_internal;
    end if;
end process;


end Behavioral;
