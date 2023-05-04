########################################################################
# set the power analysis mode
########################################################################

set power_enable_analysis TRUE

set power_analysis_mode time_based

########################################################################
# read and link the gate level netlist
########################################################################

set search_path " ./data "

set link_library "* fast.db"

read_verilog aes_top.v

current_design aes_top

link

########################################################################
# read SDC and set transition time or annotate parasitics
########################################################################

read_sdc ./data/aes_top.sdc -echo

read_parasitics ./data/aes_top.spef

########################################################################
# check, update, or report timing
########################################################################

check_timing

update_timing

report_timing

########################################################################
# read switching activity file
########################################################################

read_vcd ./SwitchFile.vcd -strip_path tb_main/uut

report_switching_activity -list_not_annotated

########################################################################
# check, update, or report power
########################################################################

check_power

set_power_analysis_options -waveform_interval 1 -include top -waveform_format out -waveform_output ./PowerDirs/PowerFile

update_power

report_power -hierarchy 

quit

########################################################################
# finish power analysis
########################################################################