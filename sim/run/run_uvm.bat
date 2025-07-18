@echo off
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"

echo Compiling UVM testbench...
dsim -uvm 1.2 ..\..\rtl\interfaces\axi4_interface.sv ..\..\verification\common\axi4_base_test.sv ..\..\verification\testbench\tb_top.sv +acc -waves ..\output\waves.mxd +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=Axi4_Base_Test

exit
