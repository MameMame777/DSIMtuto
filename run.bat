@echo off
REM ================================================================================
REM Root Directory Test Runner - Wrapper for sim/run/run.bat
REM ================================================================================
REM This script allows running tests from the root directory
REM All arguments are passed through to the main run.bat script
REM ================================================================================

REM Change to sim/run directory and execute the main script
cd sim\run
call run.bat %*
cd ..\..

REM Exit with the same code as the main script
exit /b %ERRORLEVEL%
