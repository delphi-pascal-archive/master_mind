program MasterMind;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  MasterMindEngine in 'MasterMindEngine.pas',
  ResPack in 'ResPack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MasterMind';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
