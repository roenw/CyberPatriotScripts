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
ping roen.us -n 2 -w 1000
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
echo [ INFO ] The script will start in 5 seconds. Click [ X ] if you wish to abort.
timeout 5 >nul
cls

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Disabling Guest account...
net user Guest /active:no

if ERRORLEVEL 1 (
  echo [ FAIL ] Disabling Guest Account failed.
  timeout 30 >nul
  exit
)

echo [ OK ] Guest account disabled
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Disabling Admin account...
net user Administrator /active:no

if ERRORLEVEL 1 (
  echo [ FAIL ] Disabling Admin Account failed.
  timeout 30 >nul
  exit
)

echo [ OK ] Admin account disabled
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Setting MAXPWAGE to 14 days...
net accounts /maxpwage:14

if ERRORLEVEL 1 (
  echo [ FAIL ] Setting MAXPWAGE failed.
  timeout 30 >nul
  exit
)

echo [ OK ] MAXPWAGE set to 14 days
timeout 5 >nul

pause
