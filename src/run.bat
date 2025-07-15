@echo off
setlocal enabledelayedexpansion

REM ================================================================================
REM Unified Test Execution Script for DSIM Simulation
REM ================================================================================
REM Usage: run.bat [TEST_NAME]
REM   TEST_NAME: Name of test configuration from test_config.cfg
REM   If no TEST_NAME provided, shows available tests
REM
REM Examples:
REM   run.bat axi4_reg_mem_basic    - Run AXI4 register memory basic test
REM   run.bat axi4_system           - Run AXI4 system integration test
REM   run.bat uvm_base              - Run UVM base framework test
REM   run.bat                       - Show available test configurations
REM ================================================================================

REM DSIM Environment Setup
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"

REM Configuration file path
set "CONFIG_FILE=test_config.cfg"

REM Check if configuration file exists
if not exist "%CONFIG_FILE%" (
    echo ERROR: Configuration file %CONFIG_FILE% not found!
    exit /b 1
)

REM Parse command line arguments
set "TEST_NAME=%1"

REM If no test name provided, show available tests
if "%TEST_NAME%"=="" (
    echo Available test configurations:
    echo ================================================================================
    for /f "tokens=1,2 delims=|" %%a in ('type "%CONFIG_FILE%" ^| findstr /v "^#" ^| findstr /v "^$"') do (
        echo   %%a - %%b
    )
    echo ================================================================================
    echo Usage: run.bat [TEST_NAME]
    exit /b 0
)

REM Search for test configuration
set "FOUND=0"
for /f "tokens=1,2,3,4,5,6 delims=|" %%a in ('type "%CONFIG_FILE%" ^| findstr /v "^#" ^| findstr /v "^$"') do (
    if "%%a"=="%TEST_NAME%" (
        set "FOUND=1"
        set "DESCRIPTION=%%b"
        set "FILELIST=%%c"
        set "UVM_TESTNAME=%%d"
        set "WAVES_FILE=%%e"
        set "UVM_VERBOSITY=%%f"
        goto :run_test
    )
)

REM Test not found
if "%FOUND%"=="0" (
    echo ERROR: Test configuration '%TEST_NAME%' not found in %CONFIG_FILE%
    echo.
    echo Available test configurations:
    for /f "tokens=1,2 delims=|" %%a in ('type "%CONFIG_FILE%" ^| findstr /v "^#" ^| findstr /v "^$"') do (
        echo   %%a - %%b
    )
    exit /b 1
)

:run_test
echo ================================================================================
echo Running Test: %TEST_NAME%
echo Description: %DESCRIPTION%
echo Filelist: %FILELIST%
echo Waves File: %WAVES_FILE%
if not "%UVM_TESTNAME%"=="" (
    echo UVM Test: %UVM_TESTNAME%
    echo UVM Verbosity: %UVM_VERBOSITY%
)
echo ================================================================================

REM Check if filelist exists
if not exist "%FILELIST%" (
    echo ERROR: Filelist file %FILELIST% not found!
    exit /b 1
)

REM Build DSIM command
set "DSIM_CMD=dsim"

REM Add UVM support if UVM test
if not "%UVM_TESTNAME%"=="" (
    set "DSIM_CMD=!DSIM_CMD! -uvm 1.2"
)

REM Add filelist
set "DSIM_CMD=!DSIM_CMD! -f %FILELIST%"

REM Add common options
set "DSIM_CMD=!DSIM_CMD! +acc -waves %WAVES_FILE%"

REM Add UVM specific options if UVM test
if not "%UVM_TESTNAME%"=="" (
    set "DSIM_CMD=!DSIM_CMD! +UVM_TESTNAME=%UVM_TESTNAME%"
    if not "%UVM_VERBOSITY%"=="" (
        set "DSIM_CMD=!DSIM_CMD! +UVM_VERBOSITY=%UVM_VERBOSITY%"
    )
)

REM Execute DSIM command
echo Executing: !DSIM_CMD!
echo.
!DSIM_CMD!

REM Check execution result
if %ERRORLEVEL% equ 0 (
    echo.
    echo ================================================================================
    echo Test '%TEST_NAME%' completed successfully!
    echo Waveform saved to: %WAVES_FILE%
    echo ================================================================================
) else (
    echo.
    echo ================================================================================
    echo Test '%TEST_NAME%' failed with error code %ERRORLEVEL%
    echo ================================================================================
    exit /b %ERRORLEVEL%
)

exit /b 0
