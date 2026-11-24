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

{ 2026-11-24: Updated BASS bindings and runtime loading for Delphi Rio and Win64. }

unit BassDecoder;

{$I Compiler.inc}

interface

uses
  Windows, SysUtils, SyncObjs{$IFNDEF UNICODE}, TntWideStrUtils{$ENDIF};

type
  TBassExtension = record
    Extension: WideString;
    IsMOD: Boolean;
    DLL: WideString;
  end;

const
  BASS_DLL: WideString = 'bass.dll';

{$IFDEF WIN64}
  BASS_EXTENSIONS_COUNT = 31;
  BASS_PLUGINS_COUNT = 10;
  BASS_ALAC_DLL = 'bassalac.dll';
  BASS_APE_DLL = 'bassape.dll';
{$ELSE}
  BASS_EXTENSIONS_COUNT = 32;
  BASS_PLUGINS_COUNT = 11;
  BASS_ALAC_DLL = 'bass_alac.dll';
  BASS_APE_DLL = 'bass_ape.dll';
{$ENDIF}
  BASS_EXTENSIONS: array[0..BASS_EXTENSIONS_COUNT -1] of TBassExtension = (
    (Extension: '.wav';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.aif';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.aicf'; IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.aiff'; IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.cda';  IsMOD: False; DLL: 'basscd.dll'),
    (Extension: '.mpa';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.mp2';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.m1a';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.m2a';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.mp3';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.ogg';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.oga';  IsMOD: False; DLL: 'bass.dll'),
    (Extension: '.opus'; IsMOD: False; DLL: 'bassopus.dll'),
    (Extension: '.m4a';  IsMOD: False; DLL: 'bass_aac.dll'),
    (Extension: '.m4b';  IsMOD: False; DLL: 'bass_aac.dll'),
    (Extension: '.aac';  IsMOD: False; DLL: 'bass_aac.dll'),
    (Extension: '.mpc';  IsMOD: False; DLL: 'bass_mpc.dll'),
    (Extension: '.alac'; IsMOD: False; DLL: BASS_ALAC_DLL),
    (Extension: '.ape';  IsMOD: False; DLL: BASS_APE_DLL),
    (Extension: '.flac'; IsMOD: False; DLL: 'bassflac.dll'),
    (Extension: '.ofr';  IsMOD: False; DLL: 'bass_ofr.dll'),
    (Extension: '.ofs';  IsMOD: False; DLL: 'bass_ofr.dll'),
{$IFNDEF WIN64}
    (Extension: '.tak';  IsMOD: False; DLL: 'bass_tak.dll'),
{$ENDIF}
    (Extension: '.tta';  IsMOD: False; DLL: 'bass_tta.dll'),
    (Extension: '.wv';   IsMOD: False; DLL: 'basswv.dll'),

    (Extension: '.it';   IsMOD: True; DLL: 'bass.dll'),
    (Extension: '.mo3';  IsMOD: True; DLL: 'bass.dll'),
    (Extension: '.mod';  IsMOD: True; DLL: 'bass.dll'),
    (Extension: '.mtm';  IsMOD: True; DLL: 'bass.dll'),
    (Extension: '.s3m';  IsMOD: True; DLL: 'bass.dll'),
    (Extension: '.umx';  IsMOD: True; DLL: 'bass.dll'),
    (Extension: '.xm';   IsMOD: True; DLL: 'bass.dll')
  );

  BASS_PLUGINS: array[0..BASS_PLUGINS_COUNT -1] of WideString = (
    'bass_aac.dll',
    BASS_ALAC_DLL,
    BASS_APE_DLL,
    'basscd.dll',
    'bassflac.dll',
    'bass_mpc.dll',
    'bass_ofr.dll',
    'bassopus.dll',
{$IFNDEF WIN64}
    'bass_tak.dll',
{$ENDIF}
    'bass_tta.dll',
    'basswv.dll'
  );

  BASS_FILE_NAME          = 0;
  BASS_STREAM_DECODE      = $200000;
  BASS_MUSIC_DECODE       = BASS_STREAM_DECODE;
  BASS_MUSIC_RAMP         = $200;
  BASS_MUSIC_POSRESET     = $8000;
  BASS_STREAM_PRESCAN     = $20000;
  BASS_MUSIC_PRESCAN      = BASS_STREAM_PRESCAN;
  BASS_UNICODE            = $80000000;
  BASS_SAMPLE_8BITS       = 1;   // 8 bit
  BASS_SAMPLE_FLOAT       = 256; // 32-bit floating-point
  BASS_SYNC_MIXTIME       = $40000000;
  BASS_SYNC_META          = 4;
  BASS_POS_BYTE           = 0; // byte position

  BASS_CTYPE_STREAM_AAC   = $10B00;    // AAC
  BASS_CTYPE_STREAM_MP4   = $10B01;    // MP4
  BASS_CTYPE_STREAM_MP3   = $10005;
  BASS_CTYPE_STREAM_OGG   = $10002;
  BASS_CTYPE_STREAM_OPUS  = $11200;

  BASS_TAG_HTTP           = 3; // HTTP headers : array of null-terminated strings
  BASS_TAG_ICY            = 4; // ICY headers : array of null-terminated strings
  BASS_TAG_META           = 5; // Shoutcast metadata : ANSI string

  BASS_CONFIG_NET_BUFFER  = 12;
  BASS_CONFIG_NET_PREBUF  = 15;
  BASS_CONFIG_NET_AGENT   = 16;
  BASS_HTTP_AGENT: PAnsiChar = 'DC-Bass Source Mod';

type
  BASS_CHANNELINFO = record
    freq: DWORD;        // default playback rate
    chans: DWORD;       // channels
    flags: DWORD;       // BASS_SAMPLE/STREAM/MUSIC/SPEAKER flags
    ctype: DWORD;       // type of channel
    origres: DWORD;     // original resolution
    plugin: DWORD;      // plugin
    sample: DWORD;      // sample
    filename: PAnsiChar; // filename
  end;

  TShoutcastMetaDataCallback = procedure(AText: String) of Object;
  TShoutcastBufferCallback   = procedure(ABuffer: PByte; ASize: Integer) of Object;

  TBassDownloadProc = procedure(buffer: Pointer; length: DWORD; user: Pointer); stdcall;
  TBassSyncProc = procedure(handle: DWORD; channel, data: DWORD; user: Pointer); stdcall;

  TBassDecoder = class
  protected
    BASS_Init:                  function(device: Integer; freq, flags: DWORD; win: HWND; clsid: PGUID): BOOL; stdcall;
    BASS_Free:                  function: BOOL; stdcall;
    BASS_PluginLoad:            function(filename: Pointer; flags: DWORD): Cardinal; stdcall;
    BASS_MusicLoad:             function(filetype: DWORD; f: Pointer; offset: Int64; length, flags, freq: DWORD): Cardinal; stdcall;
    BASS_StreamCreateURL:       function(url: Pointer; offset, flags: DWORD; proc: TBassDownloadProc; user: Pointer): Cardinal; stdcall;
    BASS_StreamCreateFile:      function(filetype: DWORD; f: Pointer; offset, length: Int64; flags: DWORD): Cardinal; stdcall;
    BASS_MusicFree:             function(handle: Cardinal): BOOL; stdcall;
    BASS_StreamFree:            function(handle: Cardinal): BOOL; stdcall;
    BASS_ChannelGetData:        function(handle: DWORD; buffer: Pointer; length: DWORD): DWORD; stdcall;
    BASS_ChannelGetInfo:        function(handle: DWORD; var info: BASS_CHANNELINFO): BOOL;stdcall;
    BASS_ChannelGetLength:      function(handle, mode: DWORD): Int64; stdcall;
    BASS_ChannelSetPosition:    function(handle: DWORD; pos: Int64; mode: DWORD): BOOL; stdcall;
    BASS_ChannelGetPosition:    function(handle, mode: DWORD): Int64; stdcall;
    BASS_ChannelSetSync:        function(handle: DWORD; type_: DWORD; param: Int64; proc: TBassSyncProc; user: Pointer): DWORD; stdcall;
    BASS_ChannelRemoveSync:     function(handle: DWORD; sync: DWORD): BOOL; stdcall;
    BASS_ChannelGetTags:        function(handle: DWORD; tags: DWORD): PAnsiChar; stdcall;
    BASS_SetConfig:             function(option, value: DWORD): BOOL; stdcall;
    BASS_SetConfigPtr:          function(option: DWORD; value: Pointer): BOOL; stdcall;

    FMetaDataCallback: TShoutcastMetaDataCallback;
    FBufferCallback: TShoutcastBufferCallback;
    FBuffersizeMS: Integer;
    FPrebufferMS: Integer;

    FLibrary: THandle;
    FOFRDLL: THandle;
{$IFNDEF WIN64}
    FTAKDLL: THandle;
{$ENDIF}
    FStream: Cardinal;
    FSync: Cardinal;
    FIsMOD: Boolean;
    FIsURL: Boolean;

    FChannels: Integer;
    FSampleRate: Integer;
    FBytesPerSample: Integer;
    FFloat: Boolean;
    FMSecConv: Int64;
    FIsShoutcast: Boolean;
    FType: Cardinal;

    procedure LoadBASS;
    procedure UnloadBASS;
    procedure LoadPlugins;

    function GetStreamInfos: Boolean;
    procedure GetHTTPInfos;

    function GetDuration: Int64;
    function GetPosition: Int64;
    procedure SetPosition(APositionMS: Int64);
    function GetExtension: WideString;
  public
    constructor Create(AMetaDataCallback: TShoutcastMetaDataCallback; ABufferCallback: TShoutcastBufferCallback; ABuffersizeMS: Integer; APrebufferMS: Integer);
    destructor Destroy; override;

    function Load(AFileName: WideString): Boolean;
    procedure Close;

    function GetData(ABuffer: Pointer; ASize: Integer): integer;
  public
    property DurationMS: Int64 read GetDuration;
    property PositionMS: Int64 read GetPosition write SetPosition;

    property Channels: Integer read FChannels;
    property SampleRate: Integer read FSampleRate;
    property BytesPerSample: Integer read FBytesPerSample;
    property Float: Boolean read FFloat;
    property MSecConv: Int64 read FMSecConv;
    property IsShoutcast: Boolean read FIsShoutcast;
    property Extension: WideString read GetExtension;
  end;

  function GetFilterDirectory: WideString;
  function GetBassDirectory: WideString;

implementation

uses
  BassFilter;

(*** Utilities ****************************************************************)

function WideLastDelimiter(const Delimiters, S: WideString): Integer;
{$IFNDEF UNICODE}
var
  P: PWideChar;
{$ENDIF}
begin
{$IFDEF UNICODE}
  Result := LastDelimiter(Delimiters, S);
{$ELSE}
  Result := Length(S);
  P := PWideChar(Delimiters);
  while Result > 0 do
  begin
    if (S[Result] <> #0) and (WStrScan(P, S[Result]) <> nil) then
      Exit;
    Dec(Result);
  end;
{$ENDIF}
end;

function WideExtractFilePath(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := WideLastDelimiter('\:', FileName);
  Result := Copy(FileName, 1, I);
end;

function WideExtractFileExt(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := WideLastDelimiter('.\:', FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, MaxInt) else
    Result := '';
end;

function GetFilterDirectory: WideString;
var
  pathDll: array[0..MAX_PATH -1] of WideChar;
  res: Cardinal;
begin
  res := GetModuleFileNameW(HInstance, pathDll, MAX_PATH);
  if res = 0 then
  begin
    Result := '';
    Exit;
  end;

  Result := WideExtractFilePath(pathDll);
end;

function GetBassDirectory: WideString;
{$IFDEF WIN64}
var
  directory: WideString;
{$ENDIF}
begin
  Result := GetFilterDirectory;
{$IFDEF WIN64}
  if Result = '' then
    Exit;

  directory := Result + WideString('x64\');
  if FileExists(directory + BASS_DLL) then
    Result := directory;
{$ENDIF}
end;

function IsMODFile(AFileName: WideString): Boolean;
var
  ext: WideString;
  i: Integer;
begin
  ext := WideLowerCase(WideExtractFileExt(AFileName));

  for i := 0 to BASS_EXTENSIONS_COUNT -1 do
  begin
    if (BASS_EXTENSIONS[i].Extension = ext) then
    begin
      Result := BASS_EXTENSIONS[i].IsMOD;
      Exit;
    end;
  end;

  Result := False;
end;

function ReplaceICYX(AString: WideString): WideString;
var
  strPos: Integer;
begin
  strPos := Pos(WideString('icyx'), AString);

  if (strPos = 1) and (Length(AString) > 3)  then
  begin
    AString[1] := 'h';
    AString[2] := 't';
    AString[3] := 't';
    AString[4] := 'p';
  end;

  Result := AString;
end;

function IsURLPath(AFileName: WideString): Boolean;
begin
  Result := (Pos(WideString('http://'), WideLowerCase(AFileName)) > 0) or (Pos(WideString('ftp://'), WideLowerCase(AFileName)) > 0)
end;

(*** Callbacks ****************************************************************)

procedure OnMetaData(handle: DWORD; channel, data: DWORD; user: Pointer); stdcall;
var
  decoder: TBassDecoder;
  tags: PAnsiChar;
  metaStr: String;
  resStr: String;
  idx: Integer;
begin
  decoder := TBassDecoder(user);
  if Assigned(decoder.FMetaDataCallback) then
  begin
    tags := decoder.BASS_ChannelGetTags(channel, BASS_TAG_META);
    if tags = nil then
      Exit;

    metaStr := String(AnsiString(tags));
    resStr := '';

    idx := Pos('StreamTitle=''', metaStr);
    if idx > 0 then
    begin
      // Shoutcast Metadata
      resStr := Copy(metaStr, idx + 13, MaxInt);
      idx := Pos(''';', resStr);
      if (idx > 0) then
      begin
        Delete(resStr, idx, Length(resStr) - idx + 1);
      end else
      begin
        idx := Pos('''', resStr);
        if (idx > 0) then
        begin
          Delete(resStr, idx, Length(resStr) - idx + 1);
        end;
      end;
    end else
    begin
      idx := Pos('TITLE=', metaStr);
      if idx > 0 then
      begin
        resStr := Copy(metaStr, idx + 6, Length(metaStr) - idx - 5);
      end else
      begin
        idx := Pos('Title=', metaStr);
        if idx > 0 then
        begin
          resStr := Copy(metaStr, idx + 6, Length(metaStr) - idx - 5);
        end else
        begin
          idx := Pos('title=', metaStr);
          if idx > 0 then
          begin
            resStr := Copy(metaStr, idx + 6, Length(metaStr) - idx - 5);
          end;
        end;
      end;
    end;

    decoder.FMetaDataCallback(resStr);
  end;
end;

procedure OnShoutcastData(buffer: Pointer; length: DWORD; user: Pointer); stdcall;
begin
  if (buffer <> nil) and Assigned(TBassDecoder(user).FBufferCallback)
    then TBassDecoder(user).FBufferCallback(buffer, length);
end;

(*** TBassDecoder *************************************************************)

constructor TBassDecoder.Create(AMetaDataCallback: TShoutcastMetaDataCallback; ABufferCallback: TShoutcastBufferCallback; ABuffersizeMS: Integer; APrebufferMS: Integer);
var
  directory: WideString;
begin
  inherited Create;

  directory := GetBassDirectory;
  FOFRDLL := LoadLibraryW(PWideChar(directory + WideString('OptimFROG.dll')));
{$IFNDEF WIN64}
  FTAKDLL := LoadLibraryW(PWideChar(directory + WideString('tak_deco_lib.dll')));
{$ENDIF}

  FMetaDataCallback := AMetaDataCallback;
  FBufferCallback := ABufferCallback;
  FBuffersizeMS := ABuffersizeMS;
  FPrebufferMS := APrebufferMS;

  LoadBASS;
  LoadPlugins;
end;

destructor TBassDecoder.Destroy;
begin
  Close;

  if (FOFRDLL <> 0)
    then FreeLibrary(FOFRDLL);
{$IFNDEF WIN64}
  if (FTAKDLL <> 0)
    then FreeLibrary(FTAKDLL);
{$ENDIF}

  inherited Destroy;
end;

procedure TBassDecoder.LoadBASS;
var
  path: WideString;
begin
  path := GetBassDirectory + BASS_DLL;

  if (GetFileAttributesW(PWideChar(path)) <> Cardinal(-1)) then
  begin
    FLibrary := LoadLibraryW(PWideChar(path));
  end;

  if FLibrary = 0 then
  begin
    Exit;
  end;

  @BASS_Init                  := GetProcAddress(FLibrary, 'BASS_Init');
  @BASS_Free                  := GetProcAddress(FLibrary, 'BASS_Free');
  @BASS_PluginLoad            := GetProcAddress(FLibrary, 'BASS_PluginLoad');
  @BASS_MusicLoad             := GetProcAddress(FLibrary, 'BASS_MusicLoad');
  @BASS_StreamCreateURL       := GetProcAddress(FLibrary, 'BASS_StreamCreateURL');
  @BASS_StreamCreateFile      := GetProcAddress(FLibrary, 'BASS_StreamCreateFile');
  @BASS_MusicFree             := GetProcAddress(FLibrary, 'BASS_MusicFree');
  @BASS_StreamFree            := GetProcAddress(FLibrary, 'BASS_StreamFree');
  @BASS_ChannelGetData        := GetProcAddress(FLibrary, 'BASS_ChannelGetData');
  @BASS_ChannelGetInfo        := GetProcAddress(FLibrary, 'BASS_ChannelGetInfo');
  @BASS_ChannelGetLength      := GetProcAddress(FLibrary, 'BASS_ChannelGetLength');
  @BASS_ChannelSetPosition    := GetProcAddress(FLibrary, 'BASS_ChannelSetPosition');
  @BASS_ChannelGetPosition    := GetProcAddress(FLibrary, 'BASS_ChannelGetPosition');
  @BASS_ChannelSetSync        := GetProcAddress(FLibrary, 'BASS_ChannelSetSync');
  @BASS_ChannelRemoveSync     := GetProcAddress(FLibrary, 'BASS_ChannelRemoveSync');
  @BASS_ChannelGetTags        := GetProcAddress(FLibrary, 'BASS_ChannelGetTags');
  @BASS_SetConfig             := GetProcAddress(FLibrary, 'BASS_SetConfig');
  @BASS_SetConfigPtr          := GetProcAddress(FLibrary, 'BASS_SetConfigPtr');

  BASS_Init(0, 44100, 0, GetDesktopWindow, nil);

  if (FPrebufferMS = 0)
    then FPrebufferMS := 1;

  if Assigned(BASS_SetConfigPtr) then
    BASS_SetConfigPtr(BASS_CONFIG_NET_AGENT, BASS_HTTP_AGENT);
  BASS_SetConfig(BASS_CONFIG_NET_BUFFER, FBuffersizeMS);
  BASS_SetConfig(BASS_CONFIG_NET_PREBUF, FBuffersizeMS * 100 div FPrebufferMS);
end;

procedure TBassDecoder.UnloadBASS;
begin
  if (FLibrary > 0) and Assigned(Bass_Free) then
  begin
    try
      if (InstanceCount = 0) then
      begin
        BASS_Free;
      end;
    except
      // crashes mplayer2.exe ???
    end;

    FreeLibrary(FLibrary);
    FLibrary := 0;

    @BASS_Init                  := nil;
    @BASS_Free                  := nil;
    @BASS_PluginLoad            := nil;
    @BASS_MusicLoad             := nil;
    @BASS_StreamCreateURL       := nil;
    @BASS_StreamCreateFile      := nil;
    @BASS_MusicFree             := nil;
    @BASS_StreamFree            := nil;
    @BASS_ChannelGetData        := nil;
    @BASS_ChannelGetInfo        := nil;
    @BASS_ChannelGetLength      := nil;
    @BASS_ChannelSetPosition    := nil;
    @BASS_ChannelGetPosition    := nil;
    @BASS_ChannelSetSync        := nil;
    @BASS_ChannelRemoveSync     := nil;
    @BASS_ChannelGetTags        := nil;
    @BASS_SetConfig             := nil;
    @BASS_SetConfigPtr          := nil;
  end;
end;

procedure TBassDecoder.LoadPlugins;
var
  path: WideString;
  i: Integer;
begin
  if (FLibrary = 0)
    then Exit;

  path := GetBassDirectory;

  for i := 0 to BASS_PLUGINS_COUNT -1 do
  begin
    BASS_PluginLoad(PWideChar(path + BASS_PLUGINS[i]), BASS_UNICODE);
  end;
end;

function TBassDecoder.Load(AFileName: WideString): Boolean;
begin
  Close;

  if (FLibrary = 0) then
  begin
    Result := False;
    Exit;
  end;

  FIsShoutcast := False;
  AFileName := ReplaceICYX(AFileName);

  FIsMOD := IsMODFile(AFileName);
  FIsURL := IsURLPath(AFileName);

  if FIsMOD then
  begin
    if not FIsURL then
    begin
      FStream := BASS_MusicLoad(BASS_FILE_NAME, PWideChar(AFileName), 0, 0, BASS_MUSIC_DECODE or BASS_MUSIC_RAMP or BASS_MUSIC_POSRESET or BASS_MUSIC_PRESCAN or BASS_UNICODE, 0);
    end;
  end else
  begin
    if FIsURL then
    begin
      FStream := BASS_StreamCreateURL(PWideChar(AFileName), 0, BASS_STREAM_DECODE or BASS_UNICODE, @OnShoutcastData, Self);
      FSync := BASS_ChannelSetSync(FStream, BASS_SYNC_META, 0, @OnMetaData, Self);
      FIsShoutcast := GetDuration = 0;
    end else
    begin
      FStream := BASS_StreamCreateFile(BASS_FILE_NAME, PWideChar(AFileName), 0, 0, BASS_STREAM_DECODE or BASS_UNICODE);
    end;
  end;

  if (FStream = 0) then
  begin
    Result := False;
    Exit;
  end;

  if not GetStreamInfos then
  begin
    Close;
    Result := False;
    Exit;
  end;

  Result := True;
end;

procedure TBassDecoder.Close;
begin
  if FStream = 0
    then Exit;

  if FSync <> 0 then
  begin
    BASS_ChannelRemoveSync(FStream, FSync);
  end;

  if FIsMOD
    then BASS_MusicFree(FStream)
    else BASS_StreamFree(FStream);

  FChannels := 0;
  FSampleRate := 0;
  FBytesPerSample := 0;
  FFloat := False;
  FMSecConv := 0;

  FStream := 0;
end;

function TBassDecoder.GetData(ABuffer: Pointer; ASize: Integer): integer;
begin
  Result := BASS_ChannelGetData(FStream, ABuffer, ASize);
end;

function TBassDecoder.GetStreamInfos: Boolean;
var
  info: BASS_CHANNELINFO;
begin
  if not BASS_ChannelGetInfo(FStream, info) then
  begin
    Result := False;
    Exit;
  end;

  if (info.chans = 0) or (info.freq = 0) then
  begin
    Result := False;
    Exit;
  end;

  FFloat := (info.flags and BASS_SAMPLE_FLOAT) > 0;
  FSampleRate := info.freq;
  FChannels := info.chans;
  FType := info.ctype;

  if FFloat then
  begin
    FBytesPerSample := 4;
  end else
  begin
    if ((info.flags and BASS_SAMPLE_8BITS) > 0) then
    begin
      FBytesPerSample := 1;
    end else
    begin
      FBytesPerSample := 2;
    end;
  end;

  FMSecConv := FSampleRate * FChannels * FBytesPerSample;

  if (FMSecConv = 0) then
  begin
    Result := False;
    Exit;
  end;

  GetHTTPInfos;

  Result := True;
end;

procedure TBassDecoder.GetHTTPInfos;

  procedure GetNameTag(AString: PAnsiChar);
  var
    tag: String;
  begin
    while (AString <> nil) and (AString^ <> #0) do
    begin
      tag := String(AnsiString(AString));
      if (Pos('icy-name:', tag) > 0) then
      begin
        Delete(tag, 1, 9);
        tag := Trim(tag);
        if Assigned(FMetaDataCallback)
          then FMetaDataCallback(tag);
      end;

      Inc(AString, lstrlenA(AString) + 1);
    end;
  end;

var
  icyTags: PAnsiChar;
  httpHeaders: PAnsiChar;
begin
  if not FIsShoutcast
    then Exit;

  icyTags := BASS_ChannelGetTags(FStream, BASS_TAG_ICY);
  if (Assigned(icyTags))
    then GetNameTag(icyTags);

  httpHeaders := BASS_ChannelGetTags(FStream, BASS_TAG_HTTP);
  if (Assigned(httpHeaders))
    then GetNameTag(httpHeaders);
end;

function TBassDecoder.GetDuration: Int64;
begin
  if (FMSecConv = 0) then
  begin
    Result := 0;
    Exit;
  end;

  if (FStream = 0) then
  begin
    Result := 0;
    Exit;
  end;

  // bytes = samplerate * channel * bytes_per_second
  // msecs = (bytes * 1000) / (samplerate * channels * bytes_per_second)

  Result := (BASS_ChannelGetLength(FStream, BASS_POS_BYTE) * 1000) div FMSecConv;
end;

function TBassDecoder.GetPosition: Int64;
begin
  if (FMSecConv = 0) then
  begin
    Result := 0;
    Exit;
  end;

  if (FStream = 0) then
  begin
    Result := 0;
    Exit;
  end;

  Result := (BASS_ChannelGetPosition(FStream, BASS_POS_BYTE) * 1000) div FMSecConv;
end;

procedure TBassDecoder.SetPosition(APositionMS: Int64);
var
  pos: Int64;
begin
  if (FMSecConv = 0) then
  begin
    Exit;
  end;

  if (FStream = 0) then
  begin
    Exit;
  end;

  pos := (APositionMS * FMSecConv) div 1000;

  BASS_ChannelSetPosition(FStream, pos, BASS_POS_BYTE);
end;

function TBassDecoder.GetExtension: WideString;
begin
  case FType of
    BASS_CTYPE_STREAM_AAC:   Result := 'aac';
    BASS_CTYPE_STREAM_MP4:   Result := 'mp4';
    BASS_CTYPE_STREAM_MP3:   Result := 'mp3';
    BASS_CTYPE_STREAM_OGG:   Result := 'ogg';
    BASS_CTYPE_STREAM_OPUS:  Result := 'opus';
    else                     Result := 'mp3';
  end;
end;

end.
