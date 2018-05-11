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
begin 
    
end architecture;