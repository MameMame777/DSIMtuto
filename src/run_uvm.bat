@echo off
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"

echo Compiling UVM testbench...
dsim -uvm 1.2 ..\tb\interfaces\axi4_interface.sv ..\tb\tests\axi4_base_test.sv ..\tb\top\tb_top.sv +acc -waves waves.mxd +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=Axi4_Base_Test

exit
