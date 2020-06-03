unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  Vcl.StdActns;

type
  TDelphiVersion = (Tokyo=19,Rio=20,Sydney=21);

  TForm1 = class(TForm)
    ListBox1: TListBox;
    PlatformSelect: TComboBox;
    Memo1: TMemo;
    Platforms: TCheckListBox;
    Button1: TButton;
    Button2: TButton;
    IgnorePath: TCheckBox;
    SortNew: TCheckBox;
    SortLibrary: TCheckBox;
    RemoveAndReplace: TCheckBox;
    SortNewButton: TButton;
    Button4: TButton;
    CleanUpButton: TButton;
    Button3: TButton;
    ActionList1: TActionList;
    FileSaveAs1: TFileSaveAs;
    FileOpen1: TFileOpen;
    Button5: TButton;
    VersionSelect: TCheckListBox;
    VersionBase: TRadioGroup;
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SortNewButtonClick(Sender: TObject);
    procedure CleanUpButtonClick(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PlatformSelectCloseUp(Sender: TObject);
  private
    FVersionList: TStrings;
    function StringToVersion(const Value: string): TDelphiVersion;
    function StringToVersionNumber(const Value: String): Integer;
    function LibraryKey(AVersion: string): string;
    procedure LoadAvailableVersions;
    function LookUpVersionName(const Value: string): string;
    procedure WriteToTheRegistry(AVersion, APlatform: string; lList: TStringList);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses System.Win.Registry, System.IOUtils, System.Rtti;


resourcestring
  SSearchPath = 'Search Path';
  SRootPath =  '\Software\Embarcadero\BDS\';
//  SLibraryRegistryKey = '\Software\Embarcadero\BDS\20.0\Library\';

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FVersionList.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var lList: TStringList;
  I, J: Integer;
  lPath: string;
begin
  lList := TStringList.Create;
  try
    for I := 0 to Memo1.Lines.Count - 1 do
    begin
      lPath := Memo1.Lines[I];
      if IgnorePath.Checked and (not TDirectory.Exists(lPath)) then
         Continue;
      //don't need dupes
      if lList.IndexOf(lPath) < 0 then
         lList.Add(lPath);
    end;

    if SortNew.Checked then
       lList.Sort;

    for J := 0 to VersionSelect.Count - 1 do
    begin
      if VersionSelect.Checked[J] then
      begin
        for I := 0 to Platforms.Count - 1 do
        begin
          if Platforms.Checked[I] then
          begin
            WriteToTheRegistry(VersionSelect.Items[J], Platforms.Items[I], lList);
          end;
        end;
      end;
    end;
  finally
    lList.Free;
  end;

  ShowMessage('Finished');
end;

procedure TForm1.Button2Click(Sender: TObject);
var I: Integer;
begin
  for I := 0 to ListBox1.Count - 1 do
  begin
    if ListBox1.Selected[I] then
       Memo1.Lines.Add(ListBox1.Items[I]);
  end;
end;

procedure TForm1.SortNewButtonClick(Sender: TObject);
var ts: TStringList;
begin
  ts := TStringList.Create;
  try
    ts.AddStrings(Memo1.Lines);
    ts.Sort;
    Memo1.Lines.Clear;
    Memo1.Lines.Assign(ts);
  finally
    ts.Free;
  end;
  CleanUpButton.Click;
end;

function TForm1.StringToVersion(const Value: string): TDelphiVersion;
begin
  Result := TRttiEnumerationType.GetValue<TDelphiVersion>(Value);
end;

function TForm1.StringToVersionNumber(const Value: String): Integer;
begin
  if SameText(Value, 'Tokyo') then
     Result := 19
  else if SameText(Value, 'Rio') then
     Result := 20
  else if SameText(Value, 'Sydney') then
     Result := 21
  else
     raise Exception.Create('Unrecognised Version');
end;

procedure TForm1.CleanUpButtonClick(Sender: TObject);
var ts: TStringList;
  I: Integer;
begin
  ts := TStringList.Create;
  try
    for I := 0 to Memo1.Lines.Count - 1 do
    begin
      if (Memo1.Lines[I].Trim = '')  or (ts.IndexOf(Memo1.Lines[I]) >= 0) then
         Continue;

      ts.Add(Memo1.Lines[I]);

    end;

   Memo1.Lines.Clear;
   Memo1.Lines.Assign(ts);

  finally
    ts.Free;
  end;

end;

procedure TForm1.FileOpen1Accept(Sender: TObject);
begin
  Memo1.Lines.LoadFromFile(FileOPen1.Dialog.FileName);
end;

procedure TForm1.FileSaveAs1Accept(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(FileSaveAs1.Dialog.FileName);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListBox1.Items.Delimiter := ';';
  ListBox1.Items.StrictDelimiter := True;
  Memo1.Clear;
  FVersionList := TStringList.Create;
end;

function TForm1.LibraryKey(AVersion: string): string;
var lVersion: Integer;
begin
  lVersion := StringToVersionNumber(AVersion);
  result := SRootPath + lVersion.ToString + '.0\Library\'
end;

procedure TForm1.LoadAvailableVersions;
var Registry: TRegistry;
  I: Integer;
  lName: string;
begin
    VersionBase.Items.Clear;
    VersionSelect.Items.Clear;

    Registry := TRegistry.Create;
    try
      Registry.RootKey := HKEY_CURRENT_USER;
      if not Registry.OpenKey(SRootPath, False) then
      begin
        Registry.GetKeyNames(FVersionList);
      end;
    finally
      Registry.Free;
    end;

    TStringList(FVersionList).Sort;

    for I := 0 to FVersionList.Count - 1 do
    begin
      lName := LookUpVersionName(FVersionList[I]);
      if lName = '' then
         Continue;

      FVersionList[I] := lName + '=' + FVersionList[I];
      VersionBase.Items.Add(lName);
    end;

    VersionSelect.Items.AddStrings(VersionBase.Items);
    if VersionSelect.Count = 1 then
    begin
      VersionSelect.ItemIndex := 0;
      VersionBase.ItemIndex := 0;
    end;
end;

function TForm1.LookUpVersionName(const Value: string): string;
var lValue: Integer;
    lHigh, lLow: SmallInt;
    lVersion: TDelphiVersion;
    lVal: string;
begin

  Result := '';
  lVal := Value.Substring(0, Value.IndexOf('.') - 1);
  lValue := StrToIntDef(lVal, 0);

  lHigh := Ord(High(TDelphiVersion));
  lLow := Ord(Low(TDelphiVersion));
  if ((lValue > lHigh) or (lValue < lLow)) then
     Exit;

  lVersion := TDelphiVersion(lValue);

  result := TRttiEnumerationType.GetName<TDelphiVersion>(lVersion);

end;

procedure TForm1.PlatformSelectCloseUp(Sender: TObject);
var lPlatform: string;
    Registry: TRegistry;
begin
  if VersionBase.ItemIndex < 0 then
  begin
    ShowMessage('Choose a base first');
    PlatformSelect.ItemIndex := -1;
    Exit;
  end;

  lPlatform := PlatformSelect.Items[PlatformSelect.ItemIndex];
  ListBox1.Clear;

  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKeyReadOnly(LibraryKey(VersionBase.Items[VersionBase.ItemIndex]) + lPlatform);
    ListBox1.Items.DelimitedText :=  Registry.ReadString(SSearchPath);
  finally
    Registry.Free;
  end;
end;

procedure TForm1.WriteToTheRegistry(AVersion, APlatform: string; lList: TStringList);
var Registry: TRegistry;
    lPaths: TStringList;
  I, P: Integer;
begin
  lPaths := TStringList.Create;
  try
    lPaths.Delimiter := ';';
    lPaths.StrictDelimiter := True;
    Registry := TRegistry.Create;
    try
     Registry.RootKey := HKEY_CURRENT_USER;
     if not Registry.OpenKey(LibraryKey(AVersion) + APlatform, False) then
        raise Exception.Create(LibraryKey(AVersion) + APlatform + ' does not exist');

     lPaths.DelimitedText := Registry.ReadString(SSearchPath);

     if RemoveAndReplace.Checked then
     begin
       for I := 0 to lList.Count - 1 do
       begin

         if lList[I].Trim = '' then Continue;

         P := lPaths.IndexOf(lList[I]);
         if P >= 0 then
            lPaths.Delete(P);

       end;
     end;

     for I := 0 to lList.Count - 1 do
     begin
       if lList[I].Trim = '' then Continue;

       if (lPaths.IndexOf(lList[I]) > -1) then
          continue;

       lPaths.Add(lList[I]);

     end;

     if SortLibrary.Checked then
        lPaths.Sort;

     Registry.WriteString(SSearchPath, lPaths.DelimitedText);
     
    finally
      Registry.Free;
    end;
  finally
    lPaths.Free;
  end;
end;

end.
