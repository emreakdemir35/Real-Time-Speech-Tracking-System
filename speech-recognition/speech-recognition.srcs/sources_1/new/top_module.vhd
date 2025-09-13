library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_forwarder is
    port (
        i_clk       : in  std_logic;    -- FPGA clock
        i_rx_serial : in  std_logic;    -- UART RX from PC/microcontroller
        o_tx_serial : out std_logic     -- UART TX to Arduino
    );
end uart_forwarder;

architecture rtl of uart_forwarder is

    constant CLKS_PER_BIT : integer := 10416;  -- 100MHz clock / 9600 baud

    signal rx_dv   : std_logic;
    signal rx_byte : std_logic_vector(7 downto 0);
    signal tx_active : std_logic;
    signal tx_done   : std_logic;
    signal tx_dv     : std_logic;
    signal tx_byte   : std_logic_vector(7 downto 0);

begin

    -- Instantiate UART RX
    UART_RX_INST : entity work.uart_rx
        generic map ( g_CLKS_PER_BIT => CLKS_PER_BIT )
        port map (
            i_clk       => i_clk,
            i_rx_serial => i_rx_serial,
            o_rx_dv     => rx_dv,
            o_rx_byte   => rx_byte
        );

    -- Instantiate UART TX
    UART_TX_INST : entity work.uart_tx
        generic map ( g_CLKS_PER_BIT => CLKS_PER_BIT )
        port map (
            i_clk       => i_clk,
            i_tx_dv     => tx_dv,
            i_tx_byte   => tx_byte,
            o_tx_active => tx_active,
            o_tx_serial => o_tx_serial,
            o_tx_done   => tx_done
        );

    -- RX → TX forward logic
    process(i_clk)
begin
    if rising_edge(i_clk) then
        if rx_dv = '1' and tx_active = '0' then
            tx_byte <= rx_byte;
            tx_dv   <= '1';  -- start transmission
        elsif tx_done = '1' then
            tx_dv <= '0';   -- clear after done
        end if;
    end if;
end process;


end rtl;
