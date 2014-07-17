#include <platform.h>
#include <xs1.h>
#include "uart_tx.h"
#include "i2c.h"
#include "xassert.h"
#include "uart_rx.h"
#include "debug_print.h"
#include "analog_tile_support.h"

out port gpio0 = XS1_PORT_1J;
out port gpio1 = XS1_PORT_1K;
out port gpio2 = XS1_PORT_1M;
out port gpio3 = XS1_PORT_1N;
out port gpio4 = XS1_PORT_1L;
out port gpio5 = XS1_PORT_1I;
out port gpio6 = XS1_PORT_1O;
out port gpio7 = XS1_PORT_1P;

in buffered port:1 p_uart_rx = XS1_PORT_1F;

out port p_uart_tx = XS1_PORT_1H;

r_i2c i2c_if = {on tile[0]:XS1_PORT_1G, on tile[0]:XS1_PORT_1E, 1000};

int main() {
    chan c_rx_uart;
    chan c_tx_uart;
    par {
        on tile[0]:
        {
            unsigned char rx_buffer[64];
            uart_rx(p_uart_rx, rx_buffer, 8, 115200, 8, UART_RX_PARITY_EVEN, 1, c_rx_uart);
        }
        on tile[0]:
        {
            unsigned char tx_buffer[64];
            uart_tx(p_uart_tx, tx_buffer, 8, 115200, 8, UART_TX_PARITY_EVEN, 1, c_tx_uart);
        }
    }
    return 0;
}
