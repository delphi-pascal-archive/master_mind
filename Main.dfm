object Form1: TForm1
  Left = 223
  Top = 121
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Master Mind'
  ClientHeight = 674
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 687
    Height = 674
    Align = alClient
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
    OnPaint = PaintBox1Paint
  end
  object Plot1: TImage
    Tag = 1
    Left = 15
    Top = 473
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot2: TImage
    Left = 54
    Top = 448
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot3: TImage
    Left = 94
    Top = 473
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot4: TImage
    Left = 15
    Top = 532
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot5: TImage
    Left = 54
    Top = 502
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot6: TImage
    Left = 94
    Top = 532
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot7: TImage
    Left = 15
    Top = 591
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot8: TImage
    Left = 54
    Top = 561
    Width = 44
    Height = 45
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot9: TImage
    Left = 94
    Top = 591
    Width = 44
    Height = 44
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object Plot10: TImage
    Left = 54
    Top = 615
    Width = 44
    Height = 45
    Cursor = crDrag
    AutoSize = True
    OnMouseDown = Plot1MouseDown
    OnMouseMove = Plot1MouseMove
    OnMouseUp = Plot1MouseUp
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object Parties1: TMenuItem
      Caption = 'Parties'
      OnClick = Parties1Click
      object MenuNewGame1: TMenuItem
        Caption = 'Nouvelle partie'
        object Baby1: TMenuItem
          Caption = 'BabyMind'
          OnClick = Baby1Click
        end
        object Standar6plots12chances1: TMenuItem
          Caption = 'MasterMind'
          OnClick = Standar6plots12chances1Click
        end
        object SuperMasterMind1: TMenuItem
          Caption = 'SuperMasterMind'
          OnClick = SuperMasterMind1Click
        end
      end
      object MenuEndGame1: TMenuItem
        Caption = 'Abandonner la partie'
        OnClick = MenuEndGame1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Quitter1: TMenuItem
        Caption = 'Quitter'
        OnClick = Quitter1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
      object Combinaisonsecrete1: TMenuItem
        Caption = 'Combinaison secrete'
        object Simple1: TMenuItem
          Tag = 1
          AutoCheck = True
          Caption = 'Simple'
          Checked = True
          GroupIndex = 14
          RadioItem = True
          OnClick = Simple1Click
        end
        object MNUDoublons: TMenuItem
          Tag = 2
          AutoCheck = True
          Caption = 'Double'
          GroupIndex = 14
          RadioItem = True
          OnClick = Simple1Click
        end
        object riple1: TMenuItem
          Tag = 3
          AutoCheck = True
          Caption = 'Triple'
          GroupIndex = 14
          RadioItem = True
          OnClick = Simple1Click
        end
        object Quadruple1: TMenuItem
          Tag = 4
          AutoCheck = True
          Caption = 'Quadruple'
          GroupIndex = 14
          RadioItem = True
          OnClick = Simple1Click
        end
      end
      object Fonddecran1: TMenuItem
        Caption = 'Fond d'#39'ecran'
        object Fond11: TMenuItem
          AutoCheck = True
          Caption = 'Psychedelix'
          GroupIndex = 69
          RadioItem = True
          OnClick = Fond41Click
        end
        object Fond21: TMenuItem
          Tag = 1
          AutoCheck = True
          Caption = 'Losanges'
          GroupIndex = 69
          RadioItem = True
          OnClick = Fond41Click
        end
        object Fond31: TMenuItem
          Tag = 2
          AutoCheck = True
          Caption = 'Etoiles'
          GroupIndex = 69
          RadioItem = True
          OnClick = Fond41Click
        end
        object Fond41: TMenuItem
          Tag = 3
          AutoCheck = True
          Caption = 'Metalic'
          GroupIndex = 69
          RadioItem = True
          OnClick = Fond41Click
        end
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 45
    OnTimer = Timer1Timer
    Left = 8
    Top = 40
  end
end
