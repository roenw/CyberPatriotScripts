@echo off
echo [ INFO ] Performing premilinary checks...

echo [ INFO ] Checking if script is running as Administrator...
net session >nul 2>&1
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
timeout 5 >nul
cls

echo [ INFO ] The script will start within 10 seconds.
echo [ INFO ] If you want to abort, NOW IS THE TIME.
timeout 10 >nul

cls
echo [ INFO ] Disabling Guest account...
net user Guest /active:no
echo [ OK ] Guest account disabled
timeout 5 >nul
pause
