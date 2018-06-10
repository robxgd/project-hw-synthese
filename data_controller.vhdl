
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_controller is
    generic(
		controller_address : std_logic_vector
	);

    port(
        rst : in std_logic;
        clk : in std_logic;
        -- sc: in std_logic;
        set  : in std_logic;
        data_bus  : in std_logic_vector(7 downto 0); --data and address is shared on this bus
        data_out : out std_logic_vector(7 downto 0) := (others => '0');
        done : out std_logic := '1'
        );
end entity;

architecture behaviour of data_controller is
    --we have three types of states
    type state is (idle, readAddress, readData);
    signal currentState : state := idle;
    signal nextState    : state;

begin
    process(clk)
    begin
        --check reset
        if (rst = '1') then
            --servo to 0 rad ==> data is 127
            data_out <= "01111111";
        elsif rising_edge (clk) then
            if (set = '1') then
                --change the state
                currentState <= nextState;
            end if;
        end if;
    end process;

    process(currentState, nextState)
    begin
        --TODO: check if this is not to late ant if we should work with variables?
        case currentState is
            when idle =>
                nextState <= readAddress;
                done <= '1';
            when readAddress =>
                
                if(data_bus =controller_address) then
                    nextState <= readData;
                else
                    nextState <= idle;
                end if ;
            when readData =>
                done <= '0';
                data_out <= data_bus;
                nextState <= idle;
            end case;
    end process;
end architecture;
