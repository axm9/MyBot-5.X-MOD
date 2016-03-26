@ECHO OFF
::Set the working directory
set "workingdir=%~dp0"
::Switch to working directory

set prgf=%ProgramFiles%

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set prgf=%ProgramFiles(x86)%
if "%PROCESSOR_ARCHITEW6432%"=="AMD64" set prgf=%ProgramFiles(x86)%
if "%PROCESSOR_ARCHITECTURE%"=="IA64" set prgf=%ProgramFiles(x86)%
if "%PROCESSOR_ARCHITEW6432%"=="IA64" set prgf=%ProgramFiles(x86)%

title CsvInstaller By Terrorix97(Modified by Jack795)
echo Please make sure bluestack is running..
pause

echo Installing CSV MODs...

echo.
del /Q C:\ProgramData\BlueStacks\UserData\SharedFolder\*.*
REM copy "%~dp0conf\logic\*.csv" C:\ProgramData\BlueStacks\UserData\SharedFolder\
copy "%~dp0conf\csv\*.csv" C:\ProgramData\BlueStacks\UserData\SharedFolder\
echo.

"%prgf%"\BlueStacks\hd-adb shell su -c "mkdir /data/data/com.supercell.clashofclans/update/"
"%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/"
"%prgf%"\BlueStacks\hd-adb shell su -c "mkdir /data/data/com.supercell.clashofclans/update/csv"
"%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/csv"
REM "%prgf%"\BlueStacks\hd-adb shell su -c "mkdir /data/data/com.supercell.clashofclans/update/logic"
REM "%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/logic"

choice /c yn /m "Copy file into COC?"
REM "%prgf%"\BlueStacks\hd-adb shell su -c "cp /storage/sdcard/windows/BstSharedFolder/buildings.csv /data/data/com.supercell.clashofclans/update/logic"
REM "%prgf%"\BlueStacks\hd-adb shell su -c "cp /storage/sdcard/windows/BstSharedFolder/traps.csv /data/data/com.supercell.clashofclans/update/logic"
"%prgf%"\BlueStacks\hd-adb shell su -c "cp /storage/sdcard/windows/BstSharedFolder/client_globals.csv /data/data/com.supercell.clashofclans/update/csv"
"%prgf%"\BlueStacks\hd-adb shell su -c "cp /storage/sdcard/windows/BstSharedFolder/texts.csv /data/data/com.supercell.clashofclans/update/csv"

"%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/csv/texts.csv"
"%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/csv/client_globals.csv"
REM "%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/logic/traps.csv"
REM "%prgf%"\BlueStacks\hd-adb shell su -c "chmod -R 777 /data/data/com.supercell.clashofclans/update/logic/buildings.csv"

echo.
echo Csv Mods installation completed.
echo If you got this far, everything is complete. 
echo.

Pause