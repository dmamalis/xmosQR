#include <platform.h>
#include <xs1.h>
#include <stdio.h>
#include "uart_tx.h"
#include "i2c.h"
#include "xassert.h"
#include "uart_rx.h"
#include "debug_print.h"
#include "analog_tile_support.h"

/*
 * PORT DEFINITIONS
 */
out port gpio0 = XS1_PORT_1J;               //J7_10
out port gpio1 = XS1_PORT_1K;               //J7_11
out port gpio2 = XS1_PORT_1M;               //J7_15
out port gpio3 = XS1_PORT_1N;               //J7_17
out port gpio4 = XS1_PORT_1L;               //J7_19
out port gpio5 = XS1_PORT_1I;               //J7_20
out port gpio6 = XS1_PORT_1O;               //J7_21
out port gpio7 = XS1_PORT_1P;               //J7_23

in buffered port:1 p_uart_rx = XS1_PORT_1F; //J7_01

out port p_uart_tx = XS1_PORT_1H;           //J7_02

r_i2c i2c_if = {on tile[0]:XS1_PORT_1G,     //J7_03
                on tile[0]:XS1_PORT_1E,     //J7_04
                1000
};

/*
 * IMPL
 */

//delay in ms
void delay(int ms){
    int time;
    timer t;
    t:>time;
    t when timerafter(time+ms*10000) :> void;
}

//application
int app(chanend c_rx_uart, chanend c_tx_uart, out port gpio0){
    int i = 0;
    while(1){
        printf("Heartbeat: %d\n",i++);
        gpio0 <: 1;
        delay(10);
        gpio0 <: 0;
        delay(10);
    }
    return 0;
}

int main() {
    chan c_rx_uart;
    chan c_tx_uart;
    par {
        on tile[0]: app(c_rx_uart,c_tx_uart, gpio0);
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
