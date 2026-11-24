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

{ 2026-11-24: Updated PNG loading for Delphi Rio. }

unit formPropAbout;

interface

uses
  Windows, Forms, Dialogs, BaseClass, DirectShow9, DCBassSourceIntf,
  Classes, Controls, ComCtrls, StdCtrls, SysUtils, ExtCtrls,
  {$IFDEF UNICODE}Vcl.Imaging.pngimage,{$ELSE}pngimage,{$ENDIF}
  Graphics, ShellAPI;

const
  CLSID_DCBASS_PropertyPageAbout: TGuid = '{7E15A6DE-B1F1-4E1F-8448-F5A06E179208}';

type
  TfrmPropAbout = class(TFormPropertyPage)
    TabControl1: TTabControl;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure Label5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Label7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Label13MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Label7Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  protected
  public
    function OnConnect(Unknown: IUnknown): HRESULT; override;
    function OnDisconnect: HRESULT; override;
  end;

implementation

{$R *.DFM}

function TfrmPropAbout.OnConnect(Unknown: IUnKnown): HRESULT;
begin
  Result := S_OK;
end;

function TfrmPropAbout.OnDisconnect: HRESULT;
begin
  Result := S_OK;
end;

procedure TfrmPropAbout.Label5MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Label7.Font := Label3.Font;
  Label13.Font := Label3.Font;
  Label5.Font.Color := clHotLight;
  Label5.Font.Style := [fsUnderline];
end;

procedure TfrmPropAbout.Label7MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Label5.Font := Label3.Font;
  Label13.Font := Label3.Font;
  Label7.Font.Color := clHotLight;
  Label7.Font.Style := [fsUnderline];
end;

procedure TfrmPropAbout.Label13MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Label5.Font := Label3.Font;
  Label7.Font := Label3.Font;
  Label13.Font.Color := clHotLight;
  Label13.Font.Style := [fsUnderline];
end;

procedure TfrmPropAbout.Label5Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.dsp-worx.de',nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmPropAbout.Label7Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'mailto:dcoder@dsp-worx.de',nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmPropAbout.Label13Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://reino.degeelebosch.nl',nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmPropAbout.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Label5.Font := Label3.Font;
  Label7.Font := Label3.Font;
  Label13.Font := Label3.Font;
end;

procedure TfrmPropAbout.FormCreate(Sender: TObject);
var
  img: {$IFDEF UNICODE}TPngImage{$ELSE}TPNGObject{$ENDIF};
  res: TResourceStream;
begin
  Screen.Cursors[23] := LoadCursor(HInstance, PChar(102));
  Label5.Cursor := 23;
  Label7.Cursor := 23;
  Label13.Cursor := 23;
  Image1.Cursor := 23;

  res := TResourceStream.CreateFromID(HInstance, 103, 'PNG');
  img := {$IFDEF UNICODE}TPngImage{$ELSE}TPNGObject{$ENDIF}.Create;
  img.LoadFromStream(res);
  Image1.Picture.Assign(img);
  res.Free;
  img.Free;
end;

initialization

  TBCClassFactory.CreatePropertyPage
  (
    TfrmPropAbout,
    CLSID_DCBASS_PropertyPageAbout
  );

end.
