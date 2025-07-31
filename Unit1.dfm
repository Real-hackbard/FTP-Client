object Form1: TForm1
  Left = 1729
  Top = 184
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FTP Client 1.0 Source'
  ClientHeight = 444
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnQuit: TSpeedButton
    Left = 392
    Top = 384
    Width = 121
    Height = 33
    Caption = 'Quitter'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = BtnQuitClick
  end
  object BtnDownLoad: TSpeedButton
    Left = 136
    Top = 344
    Width = 121
    Height = 33
    Caption = 'Download'
    Flat = True
    OnClick = TelechargerClick
  end
  object BtnUpload: TSpeedButton
    Left = 8
    Top = 344
    Width = 121
    Height = 33
    Caption = 'Password :'
    Flat = True
    OnClick = BtnUploadClick
  end
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 384
    Width = 121
    Height = 33
    Caption = 'DELETE'
    Flat = True
    OnClick = Effacer1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 136
    Top = 384
    Width = 121
    Height = 33
    Caption = 'Rename'
    Flat = True
    OnClick = Renommer1Click
  end
  object SpeedButton3: TSpeedButton
    Left = 264
    Top = 344
    Width = 121
    Height = 33
    Caption = 'Create a folder'
    Flat = True
    OnClick = Credossier1Click
  end
  object GroupLogon: TGroupBox
    Left = 8
    Top = 8
    Width = 505
    Height = 105
    Caption = ' Connection '
    TabOrder = 0
    object Label1: TLabel
      Left = 43
      Top = 25
      Width = 38
      Height = 13
      Caption = 'Adress :'
      Transparent = True
    end
    object Label2: TLabel
      Left = 54
      Top = 49
      Width = 32
      Height = 13
      Caption = 'Login :'
      Transparent = True
    end
    object Label3: TLabel
      Left = 16
      Top = 71
      Width = 52
      Height = 13
      Caption = 'Password :'
      Transparent = True
    end
    object BtnConnect: TSpeedButton
      Left = 328
      Top = 56
      Width = 153
      Height = 33
      Caption = 'Connection'
      Flat = True
      OnClick = BtnConnectClick
    end
    object Label4: TLabel
      Left = 296
      Top = 25
      Width = 25
      Height = 13
      Caption = 'Port :'
    end
    object EditFTP: TEdit
      Left = 96
      Top = 20
      Width = 169
      Height = 19
      CharCase = ecLowerCase
      Ctl3D = False
      MaxLength = 100
      ParentCtl3D = False
      TabOrder = 0
    end
    object EditLogin: TEdit
      Left = 96
      Top = 44
      Width = 169
      Height = 19
      Ctl3D = False
      MaxLength = 30
      ParentCtl3D = False
      TabOrder = 1
    end
    object EditMdp: TEdit
      Left = 96
      Top = 68
      Width = 169
      Height = 19
      Ctl3D = False
      MaxLength = 35
      ParentCtl3D = False
      PasswordChar = '*'
      TabOrder = 2
    end
    object EditPort: TEdit
      Left = 328
      Top = 20
      Width = 41
      Height = 19
      Ctl3D = False
      MaxLength = 5
      ParentCtl3D = False
      TabOrder = 3
      Text = '21'
      OnKeyPress = EditPortKeyPress
    end
  end
  object Grille: TStringGrid
    Left = 8
    Top = 120
    Width = 505
    Height = 217
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentFont = False
    PopupMenu = PopupMenuFTP
    TabOrder = 1
    OnDblClick = GrilleDblClick
    ColWidths = (
      133
      86
      78
      161
      185)
  end
  object Status: TStatusBar
    Left = 0
    Top = 424
    Width = 520
    Height = 20
    Panels = <>
    SimplePanel = True
    SimpleText = 'Version 1.0'
    SizeGrip = False
  end
  object PopupMenuFTP: TPopupMenu
    Left = 56
    Top = 168
    object Ouvrir1: TMenuItem
      Caption = 'Ouvrir'
      OnClick = Ouvrir1Click
    end
    object Telecharger: TMenuItem
      Caption = 'Telecharger'
      OnClick = TelechargerClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Effacer1: TMenuItem
      Caption = 'Supprimer'
      OnClick = Effacer1Click
    end
    object Renommer1: TMenuItem
      Caption = 'Renommer'
      OnClick = Renommer1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Credossier1: TMenuItem
      Caption = 'Cr'#233'e dossier'
      OnClick = Credossier1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Annuler1: TMenuItem
      Caption = 'Annuler'
    end
  end
  object SaveDialog: TSaveDialog
    Options = [ofEnableSizing]
    Left = 88
    Top = 168
  end
  object OpenDialog: TOpenDialog
    Left = 24
    Top = 168
  end
end
