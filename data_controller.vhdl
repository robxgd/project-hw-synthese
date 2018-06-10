<<<<<<< HEAD

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_controller is
    generic(
		controller_address : std_logic_vector(7 downto 0) 
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
    type state is (idle, readAddress, wachtstaat, temp);
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
                if(set='1') then
                    
                    nextState<=temp;
                end if;

                done <= '1';
            when temp =>
                    staat <= "11";
                nextState<= wachtstaat;
            when wachtstaat =>
                staat <= "01";
                if(to_integer(unsigned(data_bus)) = to_integer(unsigned(controller_address))) then
                    nextState <= readAddress;
                else 
                    nextState <= idle;
                end if;
            when readAddress =>
                staat <= "10";
                done <= '0';
                nextState <= idle;
                
                        
            end case;
    end process;
end architecture;
=======

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--use work.std_logic_arith.all;

entity data_controller is
    generic(
		controller_address : std_logic_vector(7 downto 0)
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

begin
    -- process(clk, rst)
    -- begin
    --     --check reset
    --     if (rst = '1') then
    --         --servo to 0 rad ==> data is 127
    --         data_out <= "01111111";
    --         currentState <= idle;
    --     elsif rising_edge (clk) then
    --         --change the state
    --         currentState <= nextState;
    --     end if;
    -- end process;

    process(clk)
    begin
      if (rst = '1') then
          --servo to 0 rad ==> data is 127
          data_out <= "01111111";
          currentState <= idle;
      else
        case currentState is
            when idle =>
                staat <= "00";
                if(set = '1') then
                    if(data_bus= controller_address) then
                        currentState <= readAddress;
                        done <= '0';
                    end if;
                else
                  done <= '1';
                end if;
            when readAddress =>
                staat <= "01";
                data_out <= data_bus;
                currentState <= idle;

            end case;
        end if;
    end process;
end architecture;
>>>>>>> b1ad8ff165e25d57126be1c6233ecf318d38f350
