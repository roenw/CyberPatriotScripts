@echo off
echo [ INFO ] Performing premilinary checks...

echo [ INFO ] Checking if script is running as Administrator...
if %ERRORLEVEL% EQU 0 (
  echo [ OK ] Script is running with elevated permissions
) else (
  cls
  echo [ FAIL ] Script is not running as administrator
  timeout 30 >nul
  exit
)

echo [ INFO ] Checking if computer has working internet connection...
ping roen.us -n 3 -w 1000
if %ERRORLEVEL% EQU 1 (
  cls
  echo [ FAIL ] Not connected to the internet
  timeout 30 >nul
  exit
) else (
  echo [ OK ] Connected to the internet
)

cls
echo [ OK ] All preliminary checks have passed.
pause

