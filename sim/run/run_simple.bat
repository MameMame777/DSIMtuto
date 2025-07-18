set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"
dsim ..\..\rtl\interfaces\axi4_interface.sv ..\..\verification\testbench\simple_tb_top.sv +acc -waves ..\output\waves.mxd

exit
