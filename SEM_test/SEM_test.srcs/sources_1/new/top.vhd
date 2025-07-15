----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/15/2025 02:04:18 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        led         : out std_logic_vector(7 downto 0);
        clk         : in  std_logic;                    -- 100 MHz
        inject_btn  : in  std_logic;                    -- Button to trigger injection
        uart_tx     : out std_logic                     -- UART TX output
    );
end top;

architecture Behavioral of top is

    ----------------------------------------------------------------
    -- SEM Signal Declarations
    ----------------------------------------------------------------
    signal status_heartbeat      : std_logic;
    signal status_initialization : std_logic;
    signal status_observation    : std_logic;
    signal status_correction     : std_logic;
    signal status_classification : std_logic;
    signal status_injection      : std_logic;
    signal status_essential      : std_logic;
    signal status_uncorrectable  : std_logic;
    signal inject_strobe         : std_logic := '0';
    signal inject_address        : std_logic_vector(39 downto 0) := x"0000000001";

    signal icap_o       : std_logic_vector(31 downto 0);
    signal icap_csib    : std_logic;
    signal icap_rdwrb   : std_logic;
    signal icap_i       : std_logic_vector(31 downto 0);
    signal icap_clk     : std_logic;

    signal icap_request : std_logic;
    signal icap_grant   : std_logic := '1';

    ----------------------------------------------------------------
    -- UART Transmission Logic
    ----------------------------------------------------------------
    constant CLK_FREQ       : integer := 100_000_000;
    constant BAUD_RATE      : integer := 9600;
    constant BAUD_COUNTER_MAX : integer := CLK_FREQ / BAUD_RATE;

    signal baud_counter     : integer := 0;
    signal uart_clk_en      : std_logic := '0';
    signal uart_tx_reg      : std_logic := '1';
    signal tx_byte          : std_logic_vector(7 downto 0);
    signal tx_busy          : std_logic := '0';
    signal tx_start         : std_logic := '0';
    signal tx_bit_cnt       : integer range 0 to 9 := 0;
    signal tx_shift_reg     : std_logic_vector(9 downto 0);

    ----------------------------------------------------------------
    -- Button Debounce
    ----------------------------------------------------------------
    signal btn_sync     : std_logic_vector(2 downto 0) := (others => '0');
    signal btn_pressed  : std_logic := '0';

    ----------------------------------------------------------------
    -- ICAPE2 Component Declaration
    ----------------------------------------------------------------
    component ICAPE2
        port (
            CLK   : in  std_logic;
            CSB   : in  std_logic;
            RDWRB : in  std_logic;
            I     : in  std_logic_vector(31 downto 0);
            O     : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    ----------------------------------------------------------------
    -- Clock connections
    ----------------------------------------------------------------
    icap_clk <= clk;

    ----------------------------------------------------------------
    -- Button debounce
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            btn_sync <= btn_sync(1 downto 0) & inject_btn;
            btn_pressed <= btn_sync(1) and not btn_sync(2);
        end if;
    end process;

    inject_strobe <= btn_pressed;

    ----------------------------------------------------------------
    -- SEM Instance
    ----------------------------------------------------------------
    sem_inst : entity work.sem_0
        port map (
            status_heartbeat      => status_heartbeat,
            status_initialization => status_initialization,
            status_observation    => status_observation,
            status_correction     => status_correction,
            status_classification => status_classification,
            status_injection      => status_injection,
            status_essential      => status_essential,
            status_uncorrectable  => status_uncorrectable,
            fetch_txdata          => open,
            fetch_txwrite         => open,
            fetch_txfull          => '0',
            fetch_rxdata          => (others => '0'),
            fetch_rxread          => open,
            fetch_rxempty         => '1',
            fetch_tbladdr         => (others => '0'),
            monitor_txdata        => open,
            monitor_txwrite       => open,
            monitor_txfull        => '0',
            monitor_rxdata        => (others => '0'),
            monitor_rxread        => open,
            monitor_rxempty       => '1',
            inject_strobe         => inject_strobe,
            inject_address        => inject_address,
            icap_o                => icap_o,
            icap_csib             => icap_csib,
            icap_rdwrb            => icap_rdwrb,
            icap_i                => icap_i,
            icap_clk              => icap_clk,
            icap_request          => icap_request,
            icap_grant            => icap_grant,
            fecc_crcerr           => '0',
            fecc_eccerr           => '0',
            fecc_eccerrsingle     => '0',
            fecc_syndromevalid    => '0',
            fecc_syndrome         => (others => '0'),
            fecc_far              => (others => '0'),
            fecc_synbit           => (others => '0'),
            fecc_synword          => (others => '0')
        );

    ----------------------------------------------------------------
    -- ICAP Primitive Instance
    ----------------------------------------------------------------
    icap_inst : ICAPE2
    port map (
        CLK   => icap_clk,
        CSIB  => icap_csib,     -- <--- CHANGE CSB to CSIB here
        RDWRB => icap_rdwrb,
        I     => icap_i,
        O     => icap_o
    );


    ----------------------------------------------------------------
    -- Generate UART Clock Enable
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if baud_counter = BAUD_COUNTER_MAX - 1 then
                baud_counter <= 0;
                uart_clk_en <= '1';
            else
                baud_counter <= baud_counter + 1;
                uart_clk_en <= '0';
            end if;
        end if;
    end process;

    ----------------------------------------------------------------
    -- UART TX Logic
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if tx_start = '1' and tx_busy = '0' then
                tx_shift_reg <= '1' & tx_byte & '0'; -- stop + data + start bits
                tx_bit_cnt <= 0;
                tx_busy <= '1';
            elsif uart_clk_en = '1' and tx_busy = '1' then
                uart_tx_reg <= tx_shift_reg(tx_bit_cnt);
                if tx_bit_cnt = 9 then
                    tx_busy <= '0';
                else
                    tx_bit_cnt <= tx_bit_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    uart_tx <= uart_tx_reg;

    ----------------------------------------------------------------
    -- Pack SEM status into UART Byte and trigger TX on inject
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_pressed = '1' then
                tx_byte <= status_heartbeat      &
                           status_initialization &
                           status_observation    &
                           status_correction     &
                           status_classification &
                           status_injection      &
                           status_essential      &
                           status_uncorrectable;
                tx_start <= '1';
            else
                tx_start <= '0';
            end if;
        end if;
    end process;

    ----------------------------------------------------------------
    -- LEDs for SEM Status
    ----------------------------------------------------------------
    led(0) <= status_heartbeat;
    led(1) <= status_initialization;
    led(2) <= status_observation;
    led(3) <= status_correction;
    led(4) <= status_classification;
    led(5) <= status_injection;
    led(6) <= status_essential;
    led(7) <= status_uncorrectable;

end Behavioral;
