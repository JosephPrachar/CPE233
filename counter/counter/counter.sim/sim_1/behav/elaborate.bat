@echo off
set xv_path=C:\\Xilinx\\Vivado\\2014.4\\bin
call %xv_path%/xelab  -wto 13768df7f99448768a2dfc6339ca1f04 -m64 --debug typical --relax -L xil_defaultlib -L secureip --snapshot counter_test_behav xil_defaultlib.counter_test -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
