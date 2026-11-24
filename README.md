# DCBass

DCBass is a Windows DirectShow source filter that uses the [BASS audio library](https://www.un4seen.com/bass.html) to open and decode audio in DirectShow-based media players. It supports both 32-bit (x86) and 64-bit (x64) players.

This repository continues **DC-Bass Source Mod**, Reino Wijnsma’s fork of the original **DC-Bass Source Filter** written by Milenko Mitrovic (DCoder) at DSP-worx. The original copyright notices and the Source Mod changelog are included. [Original DSP-worx project page](https://www.dsp-worx.de/index.php?n=15) · [Source Mod announcement](https://forum.doom9.org/archive/index.php/t-164200.html) · [Historical changelog](ReadMe.txt)

## Supported audio

- MP2, MP3, Vorbis, Opus, AAC, ALAC, Musepack, WAV and AIFF.
- FLAC, Monkey’s Audio, WavPack, OptimFROG, True Audio, and audio CD tracks (`.cda`).
- Tracker modules, including IT, MOD, MO3, MTM, S3M, UMX and XM.
- SHOUTcast and Icecast audio streams over HTTP, with metadata display and stream recording.
- TAK (`.tak`) on Win32 only.

## Installation

Build and run `DCBassSourceMod_1.5.2.1.exe` to install and register the filter. On x64 Windows, the Components page offers separate Win32 and Win64 checkboxes, both selected by default. Select the architecture that matches your media player, or install both if you use players of both architectures. On 32-bit Windows, Setup offers the Win32 filter.

The installer places both filters in one folder. The Win32 DLLs sit beside the filters, and the Win64 DLLs go in `x64/`. Both filters use `Formats.ini` to determine which file extensions to register. The default configuration leaves WAV and AIFF registration disabled. Setup preserves existing format settings during upgrades.

To remove the filter, use Windows’ installed apps settings or run `Uninstall.exe` from the installation folder.

## Building from source

The filter builds with Delphi 10.3 Rio for Win32 and Win64. The legacy Delphi 7 project can also build the Win32 filter. The installer uses NSIS 3. See [Dependencies.txt](Dependencies.txt) for the DSPack and BASS runtime setup, compiler commands, and steps to build the combined installer.

## License

The DCBass source is distributed under the GNU General Public License version 2. See [License.txt](License.txt) and the source file notices. BASS and its add-ons have their own licenses and are obtained separately.
