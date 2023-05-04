###############################################################################
#
# Created by PrimeTime write_sdc on Fri Apr 16 14:28:56 2021
#
###############################################################################

set sdc_version 1.8

set_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm
###############################################################################
#  
# Units
# capacitive_load_unit           : 1 pF
# current_unit                   : 0.001 A
# resistance_unit                : 1 kOhm
# time_unit                      : 1 ns
# voltage_unit                   : 1 V
###############################################################################
set_operating_conditions -analysis_type on_chip_variation  -min_library [get_libs \
 {fast.db:fast}]  -max_library [get_libs {slow.db:slow}]  -min fast  -max slow 
###############################################################################
# Clock Related Information
###############################################################################
create_clock -name clk_48Mhz -period 40 -waveform { 0 20 } [get_ports \
 {clk_48Mhz}]
set_propagated_clock [get_clocks {clk_48Mhz}]
set_clock_uncertainty  0.5 [get_clocks {clk_48Mhz}]
###############################################################################
# External Delay Information
###############################################################################
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[7]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[6]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[5]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[4]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[3]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[2]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[1]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_in[0]}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_byte_valid}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {plain_finish}]
set_input_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports {empty}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[7]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[6]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[5]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[4]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[3]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[2]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[1]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_out[0]}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports \
 {cipher_byte_valid}]
set_output_delay  20 -clock [get_clocks {clk_48Mhz}] -max [get_ports {trig}]
set_max_transition  2 [current_design]
set_drive -rise -min  1 [get_ports {plain_byte_in[7]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[7]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[7]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[7]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[6]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[6]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[6]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[6]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[5]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[5]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[5]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[5]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[4]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[4]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[4]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[4]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[3]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[3]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[3]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[3]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[2]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[2]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[2]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[2]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[1]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[1]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[1]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[1]}]
set_drive -rise -min  1 [get_ports {plain_byte_in[0]}]
set_drive -fall -min  1 [get_ports {plain_byte_in[0]}]
set_drive -rise -max  1 [get_ports {plain_byte_in[0]}]
set_drive -fall -max  1 [get_ports {plain_byte_in[0]}]
set_drive -rise -min  1 [get_ports {plain_byte_valid}]
set_drive -fall -min  1 [get_ports {plain_byte_valid}]
set_drive -rise -max  1 [get_ports {plain_byte_valid}]
set_drive -fall -max  1 [get_ports {plain_byte_valid}]
set_drive -rise -min  1 [get_ports {plain_finish}]
set_drive -fall -min  1 [get_ports {plain_finish}]
set_drive -rise -max  1 [get_ports {plain_finish}]
set_drive -fall -max  1 [get_ports {plain_finish}]
set_drive -rise -min  1 [get_ports {empty}]
set_drive -fall -min  1 [get_ports {empty}]
set_drive -rise -max  1 [get_ports {empty}]
set_drive -fall -max  1 [get_ports {empty}]
set_load -pin_load  2 [get_ports {cipher_byte_out[7]}]
set_load -pin_load  2 [get_ports {trig}]
set_load -pin_load  2 [get_ports {cipher_byte_valid}]
set_load -pin_load  2 [get_ports {cipher_byte_out[1]}]
set_load -pin_load  2 [get_ports {cipher_byte_out[0]}]
set_load -pin_load  2 [get_ports {cipher_byte_out[6]}]
set_load -pin_load  2 [get_ports {cipher_byte_out[5]}]
set_load -pin_load  2 [get_ports {cipher_byte_out[4]}]
set_load -pin_load  2 [get_ports {cipher_byte_out[2]}]
set_load -pin_load  2 [get_ports {cipher_byte_out[3]}]
