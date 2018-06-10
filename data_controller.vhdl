
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
        done : out std_logic := '1';
        staat : out std_logic_vector(1 downto 0) := "00"
        );
end entity;

architecture behaviour of data_controller is
    --we have three types of states
    type state is (idle, readAddress);
    signal currentState : state := idle;
    signal nextState    : state;

begin
    process(clk, rst)
    begin
        --check reset
        if (rst = '1') then
            --servo to 0 rad ==> data is 127
            data_out <= "01111111";
            currentState <= idle;
        elsif rising_edge (clk) then
            if (set = '1') then
                --change the state
                currentState <= nextState;
            end if;
        end if;
    end process;

    process(currentState, nextState)
    begin
        case currentState is
            when idle =>
                staat <= "00";
                if(set=1) then
                    if(data_bus = controller_address) then
                        nextState <= readAddress;
                    end if;
                end if;
                done <= '1';
            when readAddress =>
                staat <= "01";
                done <= '0';
                if(data_bus = controller_address) then
                    nextState <= readData;
                else
                    nextState <= idle;
                end if ;
       
            end case;
    end process;
end architecture;
