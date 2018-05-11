
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--this file will controll the servo. 

--de servo motor turns in a half circle

--all the way lefts (-pi/2 rad) is 0 on dataline
--all the way right (pi/2 rad) is 255 on dataline


--We have two clocks, the servo clock and the machine clock. 
--The machine has a much lower clock speed 
--one cycle is used to set the addres, one is used to send the data
--The period of the system clock is 20ms -> 50Hz


--states: idle, data, address
entity servo is
    port(
        rst : in std_logic;
        clk : in std_logic;
        sc: in std_logic;
        set  : in std_logic;
        data_bus  : in std_logic_vector(7 downto 0); --data and address
        data_out : out std_logic(7 downto 0) := (others => '0');
        done : out std_logic) := '1';
end entity;

architecture behaviour of servo is
    type state is (idle, readAddress, readData);
    signal currentState : state := idle; 
    signal nextState    : state;

begin
    process(clk)
    begin
        --check reset
        if (rst = '1') then
            --servo to 0 rad ==> data is 127
            d <= std_logic_vector(127);
        elsif rising_edge (clk) then
            if (set = '1') then
                --here we don't know if data on data is addr or data
                --we work with a state machine 

                currentState <= nextState
            end if;
        end if;
    end process;

    process(currentState, nextState)
    begin
        --TODO: check if this is not to late ant if we should work with variables?
        case currentState is
            when idle =>
              nextState <= readData;

              nextState <= idle;
            when readAddress =>
              done <= '0';
              data_out <= data_bus;
              nextState <= readData;
            when readData =>
              data_out <= data_bus;
              nextState <= idle;
            end case;
    end process;

end architecture;

    