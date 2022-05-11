set_property PACKAGE_PIN E26 [get_ports {seg[7]}]
set_property PACKAGE_PIN J26 [get_ports {seg[6]}]
set_property PACKAGE_PIN H26 [get_ports {seg[5]}]
set_property PACKAGE_PIN H21 [get_ports {seg[4]}]
set_property PACKAGE_PIN G21 [get_ports {seg[3]}]
set_property PACKAGE_PIN H23 [get_ports {seg[2]}]
set_property PACKAGE_PIN H24 [get_ports {seg[1]}]
set_property PACKAGE_PIN J21 [get_ports {seg[0]}]
set_property PACKAGE_PIN E10 [get_ports clk]
set_property PACKAGE_PIN F8 [get_ports rst]                 ; ## SW16
set_property PACKAGE_PIN AF12 [get_ports btn]

set_property IOSTANDARD LVCMOS18 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports rst]
set_property IOSTANDARD LVCMOS18 [get_ports btn]

set_property PACKAGE_PIN A23 [get_ports {seg_sel_n[15]}]
set_property PACKAGE_PIN A24 [get_ports {seg_sel_n[14]}]
set_property PACKAGE_PIN D26 [get_ports {seg_sel_n[13]}]
set_property PACKAGE_PIN C26 [get_ports {seg_sel_n[12]}]
set_property PACKAGE_PIN A20 [get_ports {seg_sel_n[11]}]
set_property PACKAGE_PIN J25 [get_ports {seg_sel_n[10]}]
set_property PACKAGE_PIN J24 [get_ports {seg_sel_n[9]}]
set_property PACKAGE_PIN H22 [get_ports {seg_sel_n[8]}]
set_property PACKAGE_PIN K21 [get_ports {seg_sel_n[7]}]
set_property PACKAGE_PIN L23 [get_ports {seg_sel_n[6]}]
set_property PACKAGE_PIN B25 [get_ports {seg_sel_n[5]}]
set_property PACKAGE_PIN B26 [get_ports {seg_sel_n[4]}]
set_property PACKAGE_PIN C24 [get_ports {seg_sel_n[3]}]
set_property PACKAGE_PIN D21 [get_ports {seg_sel_n[2]}]
set_property PACKAGE_PIN C22 [get_ports {seg_sel_n[1]}]
set_property PACKAGE_PIN B20 [get_ports {seg_sel_n[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {seg_sel_n[0]}]

## clock
create_clock -period 10.000 -name sysClk -waveform {0.000 5.000} [get_ports clk]