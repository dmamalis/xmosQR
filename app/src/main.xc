#include <platform.h>
#include <xs1.h>
#include "uart_tx.h"
#include "i2c.h"
#include "xassert.h"
#include "uart_rx.h"
#include "debug_print.h"
#include "analog_tile_support.h"

in buffered port:1 p_uart_rx = XS1_PORT_1A;

out port p_uart_tx = XS1_PORT_1A;

r_i2c i2c_if = {on tile[0]:"<assign port here>", on tile[0]:"<assign port here>", 1000};

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
