@echo off
setlocal
set "regsvr=%SystemRoot%\System32\regsvr32.exe"
if exist "%SystemRoot%\Sysnative\regsvr32.exe" set "regsvr=%SystemRoot%\Sysnative\regsvr32.exe"
set "filter=%~dp0DCBassSourceMod64.ax"
if not exist "%filter%" set "filter=%~dp0DCBassSourceMod.ax"
"%regsvr%" /u "%filter%"
