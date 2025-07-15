set_property -quiet CLOCK_PERIOD_OOC_TARGET 125.000 [get_ports -no_traverse -quiet icap_clk]
set_property -quiet IS_IP_OOC_CELL TRUE [get_cells -of [get_ports -no_traverse -quiet fecc_crcerr]]
