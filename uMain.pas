unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  uTInject,
  uTInject.Constant,
  uTInject.Classes,
  System.StrUtils,
  uBotGestor,
  uBotConversa, REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TFrmMain = class(TForm)
    BtnAuth: TButton;
    WP: TInject;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    FDMemTable1cep: TWideStringField;
    FDMemTable1logradouro: TWideStringField;
    FDMemTable1complemento: TWideStringField;
    FDMemTable1bairro: TWideStringField;
    FDMemTable1localidade: TWideStringField;
    FDMemTable1uf: TWideStringField;
    procedure BtnAuthClick(Sender: TObject);
    procedure WPGetUnReadMessages(const Chats: TChatList);
  private
    { Private declarations }
    Gestor: TBotManager;
    ConversaAtual: TBotConversa;
  public
    { Public declarations }
    procedure GestorInteracao(Conversa: TBotConversa);
    procedure EnviarMenuCEP;
    procedure EnviarConsultaCEP(AResposta: String);
    procedure EnviarMenuPrincipal(whatsapp: string);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.BtnAuthClick(Sender: TObject);
begin
  Gestor := TBotManager.create(Self);
  Gestor.Simutaneios := 20;
  Gestor.OnInteracao := GestorInteracao;
  Gestor.TempoInatividade := (300 * 1000); // 5min

  if not WP.Auth(false) then
  Begin
    WP.FormQrCodeType := TFormQrCodeType(Ft_Http);
    WP.FormQrCodeStart;
  End;

  if not WP.FormQrCodeShowing then
    WP.FormQrCodeShowing := True;

end;

procedure TFrmMain.EnviarConsultaCEP(AResposta: String);
var
  ATexto: String;
begin
  RESTClient1.BaseURL := 'https://viacep.com.br/ws/' + AResposta + '/json/';

  try
    RESTRequest1.Execute;
  Except
    on e: exception do
    begin
      WP.Send(Gestor.ConversaAtual.ID, 'Falha ao consultar CEP!');
    end;
  end;

  if RESTResponse1.StatusCode = 200 then
  begin
    ATexto := ATexto + FDMemTable1.FieldByName('logradouro').AsString + '\n';
    ATexto := ATexto + FDMemTable1.FieldByName('bairro').AsString + '\n';
    ATexto := ATexto + FDMemTable1.FieldByName('localidade').AsString + '\n';
  end;

  WP.Send(Gestor.ConversaAtual.ID, ATexto);

end;

procedure TFrmMain.EnviarMenuCEP;
begin
  Gestor.ConversaAtual.Etapa := 2;
  WP.Send(Gestor.ConversaAtual.ID, 'Informe o CEP:');
end;

procedure TFrmMain.EnviarMenuPrincipal(whatsapp: string);
var
  ATexto: String;
begin

  Gestor.ConversaAtual.Situacao := saEmAtendimento;
  ATexto := ATexto + WP.Emoticons.AtendenteM + 'Olá *' +
    Gestor.ConversaAtual.Nome + '*! \n';
  ATexto := ATexto + 'Por favor *digite* um número como opção: \n\n';
  ATexto := ATexto + WP.Emoticons.Um + 'Consultar CEP\n\n';

  Gestor.ConversaAtual.Etapa := 1;
  Gestor.ConversaAtual.Pergunta := ATexto;

  WP.Send(Gestor.ConversaAtual.ID, Gestor.ConversaAtual.Pergunta);
end;

procedure TFrmMain.GestorInteracao(Conversa: TBotConversa);
begin
  Gestor.ConversaAtual := Conversa;

  case Gestor.ConversaAtual.Situacao of

    saIndefinido:
      ;
    saNova:
      begin
        EnviarMenuPrincipal(Conversa.Telefone);
      end;
    saEmAtendimento:
      begin
        if (Pos(UpperCase(Conversa.Resposta), 'INICIO,INÍCIO,INíCIO') > 0) then
          EnviarMenuPrincipal(Conversa.Telefone)
        else
        begin
          case Conversa.Etapa of
            1:
              begin
                case AnsiIndexText(Conversa.Resposta, ['1']) of
                  0:
                    EnviarMenuCEP;
                end;
              end;
            2:
              begin
                EnviarConsultaCEP(Conversa.Resposta);
              end;
          end;
        end;
      end;
    saEmEspera:
      ;
    saInativa:
      ;
    saFinalizada:
      ;
  end;

end;

procedure TFrmMain.WPGetUnReadMessages(const Chats: TChatList);
begin
  Gestor.AdministrarChatList(WP, Chats);
end;

end.
