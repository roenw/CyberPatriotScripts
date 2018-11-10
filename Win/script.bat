@echo off
echo Checking if script contains Administrative rights...

if %errorLevel% == 0 (
  echo The script has elevated permissions. Now proceeding.
) else (
  echo ERROR: Not run with elevated permissions. Please run again as administrator.
  pause
  exit
)
