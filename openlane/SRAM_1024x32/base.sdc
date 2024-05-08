# Clock network

set clk_input $::env(CLOCK_PORT)
create_clock [get_ports $clk_input] -name clk -period $::env(CLOCK_PERIOD)
puts "\[INFO\]: Creating clock {clk} for port $clk_input with period: $::env(CLOCK_PERIOD)"

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL)] } {
	set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)
}
if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL_PIN)] } {
	set ::env(SYNTH_CLK_DRIVING_CELL_PIN) $::env(SYNTH_DRIVING_CELL_PIN)
}

# Clock non-idealities
set_propagated_clock [all_clocks]
set_clock_uncertainty 0.1 [get_clocks {clk}]
puts "\[INFO\]: Setting clock uncertainity to: 0.1"

# Maximum transition time for the design nets
set_max_transition 1.5 [current_design]
puts "\[INFO\]: Setting maximum transition to: 1.5"

# Maximum fanout
set_max_fanout 15 [current_design]
puts "\[INFO\]: Setting maximum fanout to: 15"

# Timing paths delays derate
set_timing_derate -early [expr {1-0.05}]
set_timing_derate -late [expr {1+0.05}]
puts "\[INFO\]: Setting timing derate to: [expr {0.05 * 100}] %"

# Reset input delay
set_input_delay [expr $::env(CLOCK_PERIOD) * 0.5] -clock [get_clocks {clk}] [get_ports {wb_rst_i}]

# Multicycle paths
set_multicycle_path -setup 2 -through [get_ports {wbs_ack_o}]
set_multicycle_path -hold 1  -through [get_ports {wbs_ack_o}]
set_multicycle_path -setup 2 -through [get_ports {wbs_cyc_i}]
set_multicycle_path -hold 1  -through [get_ports {wbs_cyc_i}]
set_multicycle_path -setup 2 -through [get_ports {wbs_stb_i}]
set_multicycle_path -hold 1  -through [get_ports {wbs_stb_i}]

#------------------------------------------#
# Retrieved Constraints from caravel
#------------------------------------------#

# Clock source latency
set usr_clk_max_latency 4.57
set usr_clk_min_latency 4.11
set clk_max_latency 5.57
set clk_min_latency 4.65
set_clock_latency -source -max $clk_max_latency [get_clocks {clk}]
set_clock_latency -source -min $clk_min_latency [get_clocks {clk}]
puts "\[INFO\]: Setting clock latency range: $clk_min_latency : $clk_max_latency"

# Clock input Transition
set usr_clk_tran 0.13
set clk_tran 0.61
set_input_transition $clk_tran [get_ports $clk_input]
puts "\[INFO\]: Setting clock transition: $clk_tran"

# Input delays
set_input_delay -max 3.17 -clock [get_clocks {clk}] [get_ports {wbs_sel_i[*]}]
set_input_delay -max 3.74 -clock [get_clocks {clk}] [get_ports {wbs_we_i}]
set_input_delay -max 3.89 -clock [get_clocks {clk}] [get_ports {wbs_adr_i[*]}]
set_input_delay -max 4.13 -clock [get_clocks {clk}] [get_ports {wbs_stb_i}]
set_input_delay -max 4.61 -clock [get_clocks {clk}] [get_ports {wbs_dat_i[*]}]
set_input_delay -max 4.74 -clock [get_clocks {clk}] [get_ports {wbs_cyc_i}]
set_input_delay -min 0.79 -clock [get_clocks {clk}] [get_ports {wbs_adr_i[*]}]
set_input_delay -min 1.04 -clock [get_clocks {clk}] [get_ports {wbs_dat_i[*]}]
set_input_delay -min 1.19 -clock [get_clocks {clk}] [get_ports {wbs_sel_i[*]}]
set_input_delay -min 1.65 -clock [get_clocks {clk}] [get_ports {wbs_we_i}]
set_input_delay -min 1.69 -clock [get_clocks {clk}] [get_ports {wbs_cyc_i}]
set_input_delay -min 1.86 -clock [get_clocks {clk}] [get_ports {wbs_stb_i}]

# Input Transition
set_input_transition -max 0.14  [get_ports {wbs_we_i}]
set_input_transition -max 0.15  [get_ports {wbs_stb_i}]
set_input_transition -max 0.17  [get_ports {wbs_cyc_i}]
set_input_transition -max 0.18  [get_ports {wbs_sel_i[*]}]
set_input_transition -max 0.84  [get_ports {wbs_dat_i[*]}]
set_input_transition -max 0.92  [get_ports {wbs_adr_i[*]}]
set_input_transition -min 0.07  [get_ports {wbs_adr_i[*]}]
set_input_transition -min 0.07  [get_ports {wbs_dat_i[*]}]
set_input_transition -min 0.09  [get_ports {wbs_cyc_i}]
set_input_transition -min 0.09  [get_ports {wbs_sel_i[*]}]
set_input_transition -min 0.09  [get_ports {wbs_we_i}]
set_input_transition -min 0.15  [get_ports {wbs_stb_i}]

# Output delays
set_output_delay -max 3.62 -clock [get_clocks {clk}] [get_ports {wbs_dat_o[*]}]
set_output_delay -max 8.41 -clock [get_clocks {clk}] [get_ports {wbs_ack_o}]
set_output_delay -min 1.13 -clock [get_clocks {clk}] [get_ports {wbs_dat_o[*]}]
set_output_delay -min 1.37 -clock [get_clocks {clk}] [get_ports {wbs_ack_o}]

# Output loads
set_load 0.19 [all_outputs]
