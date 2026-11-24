object frmPropAbout: TfrmPropAbout
  Left = 511
  Top = 677
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'About'
  ClientHeight = 320
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControl
    Left = 8
    Top = 8
    Width = 401
    Height = 305
    TabOrder = 0
    OnMouseMove = FormMouseMove
    object Image1: TImage
      Left = 26
      Top = 32
      Width = 140
      Height = 80
      Cursor = crHandPoint
      OnClick = Label5Click
      OnMouseMove = FormMouseMove
    end
    object Label1: TLabel
      Left = 186
      Top = 16
      Width = 154
      Height = 13
      AutoSize = False
      Caption = 'DC-Bass Source Mod 1.5.2.0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseMove = FormMouseMove
    end
    object Label3: TLabel
      Left = 186
      Top = 58
      Width = 143
      Height = 13
      Caption = #169' 2003-2010 Milenko Mitrovic'
      Transparent = True
      OnMouseMove = FormMouseMove
    end
    object Label6: TLabel
      Left = 186
      Top = 90
      Width = 23
      Height = 13
      Caption = 'Mail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      OnMouseMove = FormMouseMove
    end
    object Label4: TLabel
      Left = 186
      Top = 74
      Width = 25
      Height = 13
      Caption = 'Web'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      OnMouseMove = FormMouseMove
    end
    object Label7: TLabel
      Left = 216
      Top = 90
      Width = 104
      Height = 13
      Cursor = crHandPoint
      Caption = 'dcoder@dsp-worx.de'
      Transparent = True
      OnClick = Label7Click
      OnMouseMove = Label7MouseMove
    end
    object Label5: TLabel
      Left = 216
      Top = 74
      Width = 121
      Height = 13
      Cursor = crHandPoint
      Caption = 'http://www.dsp-worx.de'
      Transparent = True
      OnClick = Label5Click
      OnMouseMove = Label5MouseMove
    end
    object Label2: TLabel
      Left = 186
      Top = 34
      Width = 186
      Height = 13
      AutoSize = False
      Caption = 'BASS based DirectShow Audio Decoder'
      Transparent = True
      OnMouseMove = FormMouseMove
    end
    object Label10: TLabel
      Left = 186
      Top = 106
      Width = 58
      Height = 13
      Caption = 'Update by'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseMove = FormMouseMove
    end
    object Label11: TLabel
      Left = 249
      Top = 106
      Width = 70
      Height = 13
      Caption = 'Reino Wijnsma'
      OnMouseMove = FormMouseMove
    end
    object Label12: TLabel
      Left = 186
      Top = 122
      Width = 25
      Height = 13
      Caption = 'Web'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnMouseMove = FormMouseMove
    end
    object Label13: TLabel
      Left = 216
      Top = 122
      Width = 138
      Height = 13
      Cursor = crHandPoint
      Caption = 'http://reino.degeelebosch.nl'
      OnClick = Label13Click
      OnMouseMove = Label13MouseMove
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 144
      Width = 369
      Height = 145
      Caption = ' License '
      TabOrder = 0
      OnMouseMove = FormMouseMove
      object Label8: TLabel
        Left = 16
        Top = 24
        Width = 337
        Height = 57
        AutoSize = False
        Caption = 
          'This Program is free software; you can redistribute it and/or mo' +
          'dify it under the terms of the GNU General Public License as pub' +
          'lished by the Free Software Foundation; either version 2, or (at' +
          ' your option) any later version.'
        WordWrap = True
        OnMouseMove = FormMouseMove
      end
      object Label9: TLabel
        Left = 16
        Top = 80
        Width = 337
        Height = 57
        AutoSize = False
        Caption = 
          'This Program is distributed in the hope that it will be useful, ' +
          'but WITHOUT ANY WARRANTY; without even the implied warranty of M' +
          'ERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU ' +
          'General Public License for more details.'
        WordWrap = True
        OnMouseMove = FormMouseMove
      end
    end
  end
end
