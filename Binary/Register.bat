@echo off
setlocal
set "regsvr=%SystemRoot%\System32\regsvr32.exe"
if exist "%SystemRoot%\SysWOW64\regsvr32.exe" set "regsvr=%SystemRoot%\SysWOW64\regsvr32.exe"
"%regsvr%" "%~dp0DCBassSourceMod.ax"
