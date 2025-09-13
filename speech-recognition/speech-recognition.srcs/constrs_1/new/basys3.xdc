set_property PACKAGE_PIN W5 [get_ports {i_clk}]      
    set_property IOSTANDARD LVCMOS33 [get_ports {i_clk}]

# Onboard USB-UART
# B18 is the line from FTDI -> FPGA
set_property PACKAGE_PIN B18 [get_ports {i_rx_serial}]
    set_property IOSTANDARD LVCMOS33 [get_ports {i_rx_serial}]

set_property PACKAGE_PIN J1 [get_ports {o_tx_serial}]
    set_property IOSTANDARD LVCMOS33 [get_ports {o_tx_serial}]