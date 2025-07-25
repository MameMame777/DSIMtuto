@echo off
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"

echo Running AXI4 Register Memory Basic Test...
dsim -uvm 1.2 ..\..\rtl\interfaces\axi4_if.sv ..\..\rtl\axi4_reg_mem.sv ..\..\verification\common\axi4_reg_mem_basic_test.sv ..\..\verification\testbench\axi4_reg_mem_tb.sv +acc -waves ..\output\axi4_reg_mem_waves.mxd +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=Axi4_Reg_Mem_Basic_Test

exit
