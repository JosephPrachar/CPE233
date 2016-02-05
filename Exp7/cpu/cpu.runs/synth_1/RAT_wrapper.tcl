# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.cache/wt} [current_project]
set_property parent.project_path {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
read_vhdl -library xil_defaultlib {
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/counter/counter/counter.srcs/sources_1/new/programCounter.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/memory/RegisterFile.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/counter/counter/counter.srcs/sources_1/new/counter.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.srcs/sources_1/new/ControlUnit.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.srcs/sources_1/new/FlagReg.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/ALU/ALU.srcs/sources_1/new/ALU.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.srcs/sources_1/new/prog_rom.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.srcs/sources_1/new/RAT_CPU.vhd}
  {C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/cpu.srcs/sources_1/new/RAT_Wrapper.vhd}
}
read_xdc {{C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/Basys3_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/joseph/Documents/Cal Poly/Year 2/Winter/CPE 233/Git/Exp7/cpu/Basys3_Master.xdc}}]

synth_design -top RAT_wrapper -part xc7a35tcpg236-1
write_checkpoint -noxdef RAT_wrapper.dcp
catch { report_utilization -file RAT_wrapper_utilization_synth.rpt -pb RAT_wrapper_utilization_synth.pb }
