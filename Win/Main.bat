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
  echo [ FAIL ] An error occured while setting MAXPWAGE.
  timeout 30 >nul
  exit
)

echo [ OK ] Maximum password life set.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Setting MINPWLENGTH to 10 characters...
net accounts /minpwlen:10

if ERRORLEVEL 1 (
  echo [ FAIL ] An error occured while setting MINPWLENGTH.
  timeout 30 >nul
  exit
)

echo [ OK ] Minimum password length set.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Setting lockout duration to 45 minutes...
net accounts /lockoutduration:45

if ERRORLEVEL 1 (
  echo [ FAIL ] An error occured while setting lockout duration.
  timeout 30 >nul
  exit
)

echo [ OK ] Lockout duration policy is enforced.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Setting lockout threshold to 3 attempts...
net accounts /lockoutthreshold:3

if ERRORLEVEL 1 (
  echo [ FAIL ] An error occured while setting lockout threshold.
  timeout 30 >nul
  exit
)

echo [ OK ] Lockout threshold enforced.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Setting lockout window to 15 minutes...
net accounts /lockoutwindow:15

if ERRORLEVEL 1 (
  echo [ FAIL ] An error occured while setting lockout window.
  timeout 30 >nul
  exit
)

echo [ OK ] Lockout window enforced.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Begin auditing successful and unsuccessful logon/logoff attempts...
auditpol /set /category:"Account Logon" /Success:enable /failure:enable
auditpol /set /category:"Logon/Logoff" /Success:enable /failure:enable
auditpol /set /category:"Account Management" /Success:enable /failure:enable
Auditpol /set /category:"DS Access" /failure:enable
Auditpol /set /category:"Object Access" /failure:enable
Auditpol /set /category:"policy change" /Success:enable /failure:enable
Auditpol /set /category:"Privilege use" /Success:enable /failure:enable
Auditpol /set /category:"System" /failure:enable

if ERRORLEVEL 1 (
  echo [ FAIL ] An error occured while enabling logging for logon and logoff attempts.
  timeout 30 >nul
  exit
)

echo [ OK ] Now logging all logon and logoff attempts.
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

echo [ INFO ] Attempting to force-check for updates and perform updates...
echo [ INFO ] If the computer updates, you will have to restart the script to execute remaining actions.
cscript //NoLogo %~dp0\bundle\UpdateAllSoftware.vbs

if ERRORLEVEL 1 (
  echo [ FAIL ] Error updating Windows automatically.
  timeout 30 >nul
  exit
)

echo [ OK ] Windows updated!
timeout 5 >nul

REM -----------------------------------------------------------------------------------------

echo [ INFO ] Attempting to enable Windows Firewall...
NetSh Advfirewall set allprofiles state on
Netsh Advfirewall show allprofiles

if ERRORLEVEL 1 (
  echo [ FAIL ] Error enabling Windows Firewall.
  timeout 30 >nul
  exit
)

echo [ OK ] Windows Firewall enabled.
timeout 5 >nul

REM -----------------------------------------------------------------------------------------


cls
echo [ OK ] The script has finished executing with no errors. Hope it helped your score out a bit!
echo [ INFO ] Click any key to exit...
pause >nul
