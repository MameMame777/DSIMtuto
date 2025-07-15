set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"
dsim ..\tb\interfaces\axi4_interface.sv ..\tb\top\simple_tb_top.sv +acc -waves waves.vcd

exit
