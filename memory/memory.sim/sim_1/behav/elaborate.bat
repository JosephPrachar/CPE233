@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xelab  -wto 7cc2d70655854c79be1de9e7b0311706 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot ScratchPad_TB_behav xil_defaultlib.ScratchPad_TB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
