program ConsultaCEP;

uses
  Vcl.Forms,
  uTInject.ConfigCEF,
  uMain in 'uMain.pas' {FrmMain},
  uBotConversa in 'CTRL\uBotConversa.pas',
  uBotGestor in 'CTRL\uBotGestor.pas';

{$R *.res}

begin

If not GlobalCEFApp.StartMainProcess then
     Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
