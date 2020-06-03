object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 557
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    922
    557)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 24
    Top = 72
    Width = 402
    Height = 329
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
  end
  object PlatformSelect: TComboBox
    Left = 24
    Top = 45
    Width = 402
    Height = 21
    TabOrder = 1
    Text = 'PlatformSelect'
    OnCloseUp = PlatformSelectCloseUp
    Items.Strings = (
      'Win32'
      'Win64'
      'OSX32'
      'Linux64'
      'iOSSimulator'
      'iOSDevice64'
      'iOSDevice32'
      'Android32')
  end
  object Memo1: TMemo
    Left = 488
    Top = 64
    Width = 417
    Height = 329
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    WordWrap = False
  end
  object Platforms: TCheckListBox
    Left = 384
    Top = 430
    Width = 225
    Height = 58
    Columns = 2
    ItemHeight = 13
    Items.Strings = (
      'Win32'
      'Win64'
      'OSX32'
      'Linux64'
      'iOSSimulator'
      'iOSDevice64'
      'iOSDevice32'
      'Android32')
    TabOrder = 3
  end
  object Button1: TButton
    Left = 800
    Top = 407
    Width = 75
    Height = 25
    Caption = 'Register'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 432
    Top = 216
    Width = 34
    Height = 25
    Caption = '>>'
    TabOrder = 5
    OnClick = Button2Click
  end
  object IgnorePath: TCheckBox
    Left = 624
    Top = 407
    Width = 153
    Height = 17
    Caption = 'Ignore if Path doesn'#39't exist'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object SortNew: TCheckBox
    Left = 624
    Top = 428
    Width = 97
    Height = 17
    Caption = 'Sort New Entries'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object SortLibrary: TCheckBox
    Left = 624
    Top = 471
    Width = 97
    Height = 17
    Caption = 'Sort Library Paths'
    TabOrder = 8
  end
  object RemoveAndReplace: TCheckBox
    Left = 624
    Top = 449
    Width = 153
    Height = 17
    Caption = 'Remove and Replace'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object SortNewButton: TButton
    Left = 830
    Top = 33
    Width = 75
    Height = 25
    Caption = 'Sort && Clean'
    TabOrder = 10
    OnClick = SortNewButtonClick
  end
  object Button4: TButton
    Left = 24
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Sort'
    TabOrder = 11
  end
  object CleanUpButton: TButton
    Left = 749
    Top = 33
    Width = 75
    Height = 25
    Caption = 'Clean Up'
    TabOrder = 12
    OnClick = CleanUpButtonClick
  end
  object Button3: TButton
    Left = 569
    Top = 33
    Width = 75
    Height = 25
    Action = FileSaveAs1
    TabOrder = 13
  end
  object Button5: TButton
    Left = 488
    Top = 33
    Width = 75
    Height = 25
    Action = FileOpen1
    TabOrder = 14
  end
  object VersionSelect: TCheckListBox
    Left = 384
    Top = 408
    Width = 225
    Height = 16
    Columns = 4
    Ctl3D = False
    ItemHeight = 13
    Items.Strings = (
      'Rio'
      'Seattle'
      'Sydney')
    ParentCtl3D = False
    TabOrder = 15
  end
  object VersionBase: TRadioGroup
    Left = 24
    Top = 0
    Width = 185
    Height = 41
    Caption = 'Delphi Version'
    Columns = 3
    Items.Strings = (
      'Rio'
      'Tokyo'
      'Sydney')
    TabOrder = 16
  end
  object ActionList1: TActionList
    Left = 448
    Top = 280
    object FileSaveAs1: TFileSaveAs
      Category = 'File'
      Caption = 'Save'
      Dialog.DefaultExt = 'txt'
      Dialog.Filter = 'Text File (*.txt)|*.txt'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
      OnAccept = FileSaveAs1Accept
    end
    object FileOpen1: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Dialog.DefaultExt = 'txt'
      Dialog.Filter = 'Text File (*.txt)|*.txt'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = FileOpen1Accept
    end
  end
end
