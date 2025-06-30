library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity encoder_signal is

    generic (
        CLK_FREQ_HZ : integer;
        DEBOUNCE_MS : integer
    );
    port (
        Clock100MHz : in std_logic;
        noisy_in : in std_logic;
        clean_out: out std_logic
    );

end encoder_signal;

architecture Behavioral of encoder_signal is

    constant COUNT_MAX : integer := (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
    signal count : integer range 0 to COUNT_MAX := 0;
    signal stable_signal : std_logic := '0';
    
begin

    process(Clock100MHz)
    begin
        if rising_edge(Clock100MHz) then


            if noisy_in /= stable_signal then
                count <= count + 1; 
                if count = COUNT_MAX then
                    stable_signal <= noisy_in;
                    count <= 0;
                End if;
            Else
                count <= 0;
            End if;
        End if;
    End process;

    clean_out <= stable_signal;


end Behavioral;
