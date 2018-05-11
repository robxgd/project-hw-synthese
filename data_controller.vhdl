
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
        data  : in std_logic_vector; --data and address
        pwm : out std_logic;
        done : out std_logic);
end entity;

architecture behaviour of servo is
    type state is (idle, readAddress, readData);
    signal currentState : state; 
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
                currentState := nextState
            end if;
        end if;
    end process;

    process(currentState, nextState)
    begin
        case currentState is
            when idle =>
              if (readInstr = '1') then
                nextState <= readingMemory;
              else
                nextState <= idle;
              end if;
            when readingMemory =>
              if (memReady = '1') then
                nextstate <= incrPC;
              else
                nextState <= readingMemory;
              end if;
            when incrPC =>
              if (readInstr = '1') then
                nextState <= readingMemory;
              else
                nextState <= idle;
              end if;
            end case;
    end process;

end architecture;

    