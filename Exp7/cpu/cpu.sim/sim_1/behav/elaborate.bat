@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xelab  -wto d768b64b69af4fe484c95d7b85f0593e -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot StackPointerTB_behav xil_defaultlib.StackPointerTB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
