(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  Copyright (C) 2003-2007 Milenko Mitrovic                                 *
 *  Mail: dcoder@dsp-worx.de                                                 *
 *  Web:  http://www.dsp-worx.de                                             *
 *                                                                           *
 *  This Program is free software; you can redistribute it and/or modify     *
 *  it under the terms of the GNU General Public License as published by     *
 *  the Free Software Foundation; either version 2, or (at your option)      *
 *  any later version.                                                       *
 *                                                                           *
 *  This Program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the             *
 *  GNU General Public License for more details.                             *
 *                                                                           *
 *  You should have received a copy of the GNU General Public License        *
 *  along with GNU Make; see the file COPYING.  If not, write to             *
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.    *
 *  http://www.gnu.org/copyleft/gpl.html                                     *
 *                                                                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
 
{ 2026-11-24: Added the Delphi Rio and Win64 build path. }

library DCBassSourceMod;

uses
{$IFNDEF UNICODE}
  BaseClass in '..\..\DSPack\src\DSPack\BaseClass.pas',
  DXSUtil in '..\..\DSPack\src\DSPack\DXSUtil.pas',
  DXTypes in '..\..\DSPack\src\DirectX9\DXTypes.pas',
  Direct3D9 in '..\..\DSPack\src\DirectX9\Direct3D9.pas',
  DirectDraw in '..\..\DSPack\src\DirectX9\DirectDraw.pas',
  DirectShow9 in '..\..\DSPack\src\DirectX9\DirectShow9.pas',
  DirectSound in '..\..\DSPack\src\DirectX9\DirectSound.pas',
  DxDiag in '..\..\DSPack\src\DirectX9\DxDiag.pas',
  WMF9 in '..\..\DSPack\src\DirectX9\WMF9.pas',
  TntClasses in '..\..\TntUnicodeControls\Source\TntClasses.pas',
  TntFormatStrUtils in '..\..\TntUnicodeControls\Source\TntFormatStrUtils.pas',
  TntSystem in '..\..\TntUnicodeControls\Source\TntSystem.pas',
  TntSysUtils in '..\..\TntUnicodeControls\Source\TntSysUtils.pas',
  TntWideStrings in '..\..\TntUnicodeControls\Source\TntWideStrings.pas',
  TntWideStrUtils in '..\..\TntUnicodeControls\Source\TntWideStrUtils.pas',
  TntWindows in '..\..\TntUnicodeControls\Source\TntWindows.pas',
  pngimage in '..\..\pngimage\pngimage.pas',
  pnglang in '..\..\pngimage\pnglang.pas',
  zlibpas in '..\..\pngimage\zlibpas.pas',
{$ENDIF}
  BassFilter in 'BassFilter.pas',
  BassDecoder in 'BassDecoder.pas',
  DCBassSourceIntf in 'Interface\DCBassSourceIntf.pas',
  formPropAbout in 'PropertyPages\formPropAbout.pas' {frmPropAbout},
  formPropSettings in 'PropertyPages\formPropSettings.pas' {frmPropSettings};

{$E ax}
{$R Version.res}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

begin
end.
