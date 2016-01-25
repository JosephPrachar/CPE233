@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xelab  -wto a6b9c7e149c44f89b56229ef88a53f2c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot Lab5WrapperTB_behav xil_defaultlib.Lab5WrapperTB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
