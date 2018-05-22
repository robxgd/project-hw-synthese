library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_servo is
end entity;

architecture test of tb_fetch is
  -- input signalen
  signal clk, rst, sc, set,tc : std_logic;
  signal data : std_logic_vector(8 downto 0);

  -- output signalen
  signal pwm, done : std_logic;

  -- extra
  signal EndOfSim    : boolean := false;
  constant clkPeriod : time := 20 ms;
  constant scPeriod : time := 0.5/255 ms;
  constant testPeriod : time := 0.5/550 ms;
  constant dutyCycle : real := 0.5;

begin
  uut: servo port map (
    -- inputs
    rst    => rst := '0',
    clk    => clk := '0',
    sc     => sc := '0',
    set    => set := '0',
    data   => data := (others <= '0'),
    --outputs
    pwm    => pwm := '0',
    done   => done := '1'
    );

    -- Clock Generation process
    clock: process
    begin
      clk <= '1';
      wait for (1.0 - dutyCycle) * clkPeriod;
      clk <= '0';
      wait for dutyCycle * clkPeriod;
      if EndOfSim then -- The simulation EndOfSims due to event starvation
        wait;
      end if;
    end process;

    -- Servoclock Generation process
    servoclock: process
    begin
      sc <= '1';
      wait for (1.0 - dutyCycle) * scPeriod;
      sc <= '0';
      wait for dutyCycle * scPeriod;
      if EndOfSim then -- The simulation EndOfSims due to event starvation
        wait;
      end if;
    end process;

    --testclock Generation process
    testclock: process
    begin
      tc <= '1';
      wait for (1.0 - dutyCycle) * scPeriod;
      tc <= '0';
      wait for dutyCycle * scPeriod;
      if EndOfSim then -- The simulation EndOfSims due to event starvation
        wait;
      end if;
    end process;

    main: process
    variable i: integer;
    variable aantal: integer
    begin
      i := '0';
      while (i < 256) loop
        wait until rising_edge(clk);
        set <= '1';
        data <= '01010101';
        wait until rising_edge(clk);
        pwm <= std_logic_vector(to_unsigned(i, 8));
        while pwm = '1' loop
          aantal := aantal + 1;
          wait for 0.1 us;
        end loop;
        report "                        VECTOR MISMATCH: Signal (RESULT),"
				& "expected " & integer'image (result_v) & " ,vector = "
				&	integer'image (vector);
        wait until rising_edge(clk);
        set <= '0';
        data <= (others <= 0);
