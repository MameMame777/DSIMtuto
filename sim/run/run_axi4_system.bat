@echo off
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"

echo Compiling AXI4 system with interfaces...
dsim ..\..\rtl\interfaces\axi4_if.sv ..\..\rtl\axi4_reg_mem.sv ..\..\verification\testbench\axi4_system_tb.sv +acc -waves ..\output\axi4_system_waves.mxd

exit
