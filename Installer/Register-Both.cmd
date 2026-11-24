@echo off
setlocal
set "reg32=%SystemRoot%\SysWOW64\regsvr32.exe"
set "reg64=%SystemRoot%\System32\regsvr32.exe"
if exist "%SystemRoot%\Sysnative\regsvr32.exe" set "reg64=%SystemRoot%\Sysnative\regsvr32.exe"

if not exist "%reg32%" (
    echo This package requires 64-bit Windows.
    exit /b 1
)
if not exist "%~dp0DCBassSourceMod.ax" exit /b 1
if not exist "%~dp0DCBassSourceMod64.ax" exit /b 1

"%reg32%" /s "%~dp0DCBassSourceMod.ax"
if errorlevel 1 (
    echo Win32 registration failed. Run this script as administrator.
    exit /b 1
)
"%reg64%" /s "%~dp0DCBassSourceMod64.ax"
if errorlevel 1 (
    echo Win64 registration failed. Win32 registration succeeded.
    exit /b 1
)
