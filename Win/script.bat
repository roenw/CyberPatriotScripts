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

echo [ INFO ] Disabling shutdown without logon...
REGEDIT.EXE  /S  "%~dp0\bundle\Disable_Shutdown_without_Logon.reg"

if ERRORLEVEL 1 (
  echo [ FAIL ] Executing premade regedit file to disable shutdown without logon failed.
  timeout 30 >nul
  exit
)

echo [ OK ] Shutdown without logon disabled.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Changing all user passwords except self...
setlocal
for /f "delims=" %%u in ('cscript //NoLogo %~dp0\bundle\GetLocalUsers.vbs') do (
  net user "%%u" "kalaheo 5up3r53cur3pa55w0rD$~"
)

if ERRORLEVEL 1 (
  echo [ FAIL ] Changing passwords failed.
  timeout 30 >nul
  exit
)

echo [ OK ] All user passwords except self have been changed.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------


cls
echo [ OK ] The script has finished executing with no errors. Hope it helped your score out a bit!
echo [ INFO ] Click any key to exit...
pause >nul
