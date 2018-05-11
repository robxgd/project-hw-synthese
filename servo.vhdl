library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--this entity will tell the motor what to do
entity servo is
    port(
        rst : in std_logic;
        clk : in std_logic;
        sc: in std_logic;
        set  : in std_logic;
        data  : in std_logic_vector; --data and address
        pwm : out std_logic    
    );
end entity;

architecture behaviour of servo is 
    signal pwm_timer : integer := O;
begin 
    process(clk)
    begin 
        --what to do here?
    end process;

    process(sc)
    begin

        --check how long sc was high to give right value.
        --We know the SC is 50hz 

    end process;

end architecture;