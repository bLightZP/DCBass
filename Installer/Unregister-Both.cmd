@echo off
setlocal
set "reg32=%SystemRoot%\SysWOW64\regsvr32.exe"
set "reg64=%SystemRoot%\System32\regsvr32.exe"
if exist "%SystemRoot%\Sysnative\regsvr32.exe" set "reg64=%SystemRoot%\Sysnative\regsvr32.exe"

if not exist "%reg32%" (
    echo This package requires 64-bit Windows.
    exit /b 1
)

set "failed=0"
"%reg32%" /s /u "%~dp0DCBassSourceMod.ax"
if errorlevel 1 (
    echo Win32 unregistration failed.
    set "failed=1"
)
"%reg64%" /s /u "%~dp0DCBassSourceMod64.ax"
if errorlevel 1 (
    echo Win64 unregistration failed.
    set "failed=1"
)
exit /b %failed%
