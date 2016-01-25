@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xsim Lab5WrapperTB_behav -key {Behavioral:sim_1:Functional:Lab5WrapperTB} -tclbatch Lab5WrapperTB.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
