================================================================
    DC-Bass Source Mod - BASS based DirectShow Audio Decoder

    Version 1.5.2.1

    (C) 2003-2010 Milenko Mitrovic
    mail     : dcoder@dsp-worx.de
    web      : http://www.dsp-worx.de
    update by: Reino Wijnsma
    web      : http://reino.degeelebosch.nl
================================================================

[DESCRIPTION]
 DCBass is a BASS-based audio source filter for DirectShow media players. This
 project continues DC-Bass Source Mod by Reino Wijnsma, a fork of the original
 DC-Bass Source Filter written by Milenko Mitrovic (DCoder) at DSP-worx.
 Project source and build instructions are at https://github.com/bLightZP/DCBass.

 It currently supports the following audio formats:

 [Sample audio]                                                  [Tracker audio]
  - MPEG-1 Layer 2 & 3                  (.mp2, .mp3)              - Impulse Tracker Module                 (.it)
  - Other MPEG audio                    (.mpa, .m1a, .m2a)        - Tracker Module with MP3 or OGG samples (.mo3)
  - Vorbis                              (.ogg, .oga)              - Tracker Module                         (.mod)
  - Opus                                (.opus)                   - Multi Tracker Module                   (.mtm)
  - Advanced Audio Coding               (.aac, .m4a, .m4b)        - Scream Tracker 3 Module                (.s3m)
  - MusePack                            (.mpc)                    - Unreal Tournament music package        (.umx)
                                                                  - Fast Tracker 2 Extended Module         (.xm)
  - Waveform Audio File Format          (.wav)
  - Audio Interchange File Format       (.aif, .aifc, .aiff)  
  - Compact Disc Audio track            (.cda)                   [SHOUTcast/Icecast (live audio streams)]
                                                                  - MP3
  - Apple Lossless Audio Codec          (.alac, .m4a)             - OGG
  - Monkey's Audio                      (.ape)                    - AAC
  - Free Lossless Audio Codec           (.flac)                   - OPUS
  - OptimFROG                           (.ofr, .ofs)           
  - Tom's verlustfreier Audiokompressor (.tak)                 
  - True Audio                          (.tta)                 
  - WavPack                             (.wv)

 SHOUTcast/Icecast Streams can be saved from within the PropertyPage or by using the IDCBassSource Interface.
 SHOUTcast/Icecast Tags can be read using the IAMMediaContent or IDCBassSource Interface.


[INSTALL/UNINSTALL]
 The installer "DCBassSourceMod_1.5.2.1.exe" lets you choose the Win32 and Win64 filters separately.
 Both checkboxes are selected by default on x64 Windows.
 The Win32 filter and its DLLs are in the installation folder alongside the Win64 filter.
 The Win64 DLLs are in the x64 subfolder. TAK is available through the Win32 filter.
 On 32-bit Windows the installer installs and registers the Win32 filter.
 Both filters use Formats.ini. Setup preserves existing format settings when upgrading.
 To uninstall, use "Add or Remove Programs" or run "Uninstall.exe" in the installation directory.

 For a portable package, keep the DLLs next to the matching filter. The
 combined package keeps the Win64 DLLs in x64. Run the registration script
 for the installed architecture as administrator to register the filter.

 Formats.ini controls which extensions are registered. WAV and AIFF are
 disabled by default. Choose your settings before registration. The alternate
 Formats_LAV.ini can be used as a starting point when using LAV Filters.

 The filter opens standalone audio files, tracker modules and supported live
 audio streams. Audio tracks inside video containers use the player's splitter
 and audio decoder.

[LICENSE]
 This software is released together with the Source Code under the 
 GNU GENERAL PUBLIC LICENSE VERSION 2

 For more Information about this License read the attached 
 "License.txt" File or enter the following Link into your Web Browser:

 http://www.gnu.org/copyleft/gpl.html


[LINKS]
 BASS audio library
  http://www.un4seen.com/

 Extended Tag support for Windows Media Player
  http://wmptagext.sourceforge.net/


[CHANGELOG]
 Win64 port (2026-11-24)
  - Added Delphi Rio Win64 support while keeping the Win32 build.
  - Updated the BASS callbacks and Unicode handling.
  - Added a combined installer with separate Win32 and Win64 options.

 v1.5.2.1 (30092015)
  -fixed: BASS (add-ons) updated to version 2.4.11.0
  -fixed: TAK Decoder Library updated to version 2.3.0.0

 v1.5.2.0 (24022013)
  -fixed: BASS (add-ons) updated to version 2.4.10.0
  -fixed: now only original filename BASS add-ons accepted
  -fixed: extension list updated and extended
  -added: support for Waveform Audio File Format (.wav)
  -added: support for Audio Interchange File Format (.aif, .aifc, .aiff)
  -fixed: double registry folder
  -added: uninstall now also removes registry settings

 v1.5.1.0 (23082012)
  -fixed: BASS add-ons updated, specifically BASSOPUS:
   BASSOPUS 2.4.0.1 fixes a channel order issue

 v1.5.0.0 (27072012)
  -fixed: BASS (add-ons) updated to version 2.4.9.0
  -added: support for the brand-new IETF Opus audio codec (.opus)

 v1.4.0.0 (20022012)
  -fixed: BASS (add-ons) updated to version 2.4.8.1
  -added: support for MPEG-1 Layer 2 (.mp2)
  -added: support for Compact Disc Audio track (.cda)
  -added: support for Tom's verlustfreier Audiokompressor (.tak)
  -fixed: cursor on About-tab on Properties page
 ---------------------------------------------------------

 v1.3.0
  -fixed: updated to BASS and plugins version 2.4.6
  -added: support for OptimFROG
  -added: support for OGG Vorbis
  -fixed: plugins can be loaded from unicode directories
  -added: support for unicode URL's

 v1.2.1
  -fixed: updated to BASS and plugins version 2.4.2

 v1.2.0
  -fixed: updated to BASS and plugins version 2.4.1
  -fixed: Unicode filenames were not working

 v1.1.1
  -fixed: debug log files will not be created anymore

 v1.1.0
  -added: tag detection for ICY/HTTP headers
  -fixed: wrong Memoryallocation for Metadata
  -added: option for Shoutcast buffersize
  -added: tag based stream writing
  -added: only extension with available plugins will be registered
  -added: support for ICYX:// protocol
  -fixed: no connect to waveout renderer with 8 channel flac
  -added: ini file to choose what extensions to register

 v1.0.0
  -initial Release
