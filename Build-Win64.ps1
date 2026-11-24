[CmdletBinding()]
param(
    [string]$Compiler,
    [string]$DSPackRoot = "$PSScriptRoot\Build\Dependencies\DSPack",
    [string]$BassRuntime = "$PSScriptRoot\Build\Dependencies\BASS-x64",
    [string]$Win32Filter
)

$ErrorActionPreference = 'Stop'
if (!$Compiler) {
    $Compiler = (Get-Command dcc64.exe -CommandType Application).Source
}

$Compiler = (Resolve-Path -LiteralPath $Compiler).Path
$delphiRoot = Split-Path -Parent (Split-Path -Parent $Compiler)
$rtl = Join-Path $delphiRoot 'lib\win64\release'
$baseClasses = Join-Path (Resolve-Path -LiteralPath $DSPackRoot).Path 'src\DSPack'
$directX = Join-Path (Resolve-Path -LiteralPath $DSPackRoot).Path 'src\DirectX9'
$runtimePath = (Resolve-Path -LiteralPath $BassRuntime).Path

function Assert-PEMachine([string]$Path, [int]$Machine) {
    $reader = New-Object IO.BinaryReader ([IO.File]::OpenRead($Path))
    try {
        if ($reader.ReadUInt16() -ne 0x5A4D) { throw "Invalid executable image: $Path" }
        $reader.BaseStream.Position = 0x3C
        $reader.BaseStream.Position = $reader.ReadUInt32()
        if ($reader.ReadUInt32() -ne 0x4550 -or $reader.ReadUInt16() -ne $Machine) {
            throw ('Expected PE machine 0x{0:X4}: {1}' -f $Machine, $Path)
        }
    } finally {
        $reader.Dispose()
    }
}

$runtimeFiles = @(
    'bass.dll', 'bass_aac.dll', 'bassalac.dll', 'bassape.dll', 'basscd.dll',
    'bassflac.dll', 'bass_mpc.dll', 'bass_ofr.dll', 'OptimFROG.dll',
    'bassopus.dll', 'bass_tta.dll', 'basswv.dll'
) | ForEach-Object { Join-Path $runtimePath $_ }
foreach ($file in $runtimeFiles) { Assert-PEMachine $file 0x8664 }

$binary = Join-Path $PSScriptRoot 'Binary'
if ($Win32Filter) {
    $Win32Filter = (Resolve-Path -LiteralPath $Win32Filter).Path
    Assert-PEMachine $Win32Filter 0x014C
    $runtime32 = @(
        'bass.dll', 'bass_aac.dll', 'bass_alac.dll', 'bass_ape.dll', 'basscd.dll',
        'bassflac.dll', 'bass_mpc.dll', 'bass_ofr.dll', 'OptimFROG.dll',
        'bassopus.dll', 'bass_tak.dll', 'tak_deco_lib.dll', 'bass_tta.dll', 'basswv.dll'
    ) | ForEach-Object { Join-Path $binary $_ }
    foreach ($file in $runtime32) { Assert-PEMachine $file 0x014C }
}

$source = Join-Path $PSScriptRoot 'Source'
$output = Join-Path $PSScriptRoot 'Build\Win64'
$units = Join-Path $PSScriptRoot 'Build\Win64-DCU'
New-Item -ItemType Directory -Force -Path $output, $units | Out-Null

Push-Location -LiteralPath $source
try {
    & $Compiler -Q --no-config -B "-U$rtl;$baseClasses;$directX" "-I$baseClasses;$directX" `
        '-NSSystem;System.Win;Winapi;Vcl;Vcl.Imaging;Vcl.Samples;Data' `
        '-DWITH_PROPERTY_PAGE' "-E$output" "-NU$units" 'DCBassSourceMod.dpr'
    if ($LASTEXITCODE -ne 0) { throw "Win64 build failed (dcc64 exit code $LASTEXITCODE)." }
} finally {
    Pop-Location
}

$filter = Join-Path $output 'DCBassSourceMod.ax'
Assert-PEMachine $filter 0x8664
Copy-Item -LiteralPath $runtimeFiles -Destination $output -Force
foreach ($name in 'Formats.ini', 'Formats_LAV.ini') {
    $lines = Get-Content -LiteralPath (Join-Path $binary $name) |
        Where-Object { $_ -notmatch '^\s*tak\s*=' }
    [IO.File]::WriteAllLines((Join-Path $output $name), [string[]]$lines)
}
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Installer\Register-Win64.cmd'), `
    (Join-Path $PSScriptRoot 'Installer\Unregister-Win64.cmd') -Destination $output -Force

Write-Output $filter

if ($Win32Filter) {
    $dual = Join-Path $PSScriptRoot 'Build\Dual'
    $dualRuntime64 = Join-Path $dual 'x64'
    New-Item -ItemType Directory -Force -Path $dualRuntime64 | Out-Null
    Copy-Item -LiteralPath $Win32Filter -Destination (Join-Path $dual 'DCBassSourceMod.ax') -Force
    Copy-Item -LiteralPath $filter -Destination (Join-Path $dual 'DCBassSourceMod64.ax') -Force
    Copy-Item -LiteralPath $runtime32 -Destination $dual -Force
    Copy-Item -LiteralPath $runtimeFiles -Destination $dualRuntime64 -Force
    Copy-Item -LiteralPath (Join-Path $binary 'Formats.ini'), (Join-Path $binary 'Formats_LAV.ini') `
        -Destination $dual -Force
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Installer\Register-Both.cmd'), `
        (Join-Path $PSScriptRoot 'Installer\Unregister-Both.cmd') -Destination $dual -Force
    Write-Output $dual
}
