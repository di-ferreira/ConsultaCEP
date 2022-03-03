object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Consulta CEP'
  ClientHeight = 173
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BtnAuth: TButton
    Left = 80
    Top = 56
    Width = 129
    Height = 57
    Caption = 'Autenticar'
    TabOrder = 0
    OnClick = BtnAuthClick
  end
  object WP: TInject
    InjectJS.AutoUpdateTimeOut = 10
    Config.AutoStart = True
    Config.AutoDelay = 1000
    Config.ReceiveAttachmentAuto = False
    AjustNumber.LengthPhone = 8
    AjustNumber.DDIDefault = 55
    FormQrCodeType = Ft_Http
    OnGetUnReadMessages = WPGetUnReadMessages
    Left = 16
    Top = 16
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://viacep.com.br/ws/28979123/json'
    Params = <>
    Left = 24
    Top = 128
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    Left = 120
    Top = 128
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 240
    Top = 128
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 248
    Top = 80
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'cep'
        DataType = ftWideString
        Size = 9
      end
      item
        Name = 'logradouro'
        DataType = ftWideString
        Size = 14
      end
      item
        Name = 'complemento'
        DataType = ftWideString
      end
      item
        Name = 'bairro'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'localidade'
        DataType = ftWideString
        Size = 8
      end
      item
        Name = 'uf'
        DataType = ftWideString
        Size = 2
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 256
    Top = 16
    object FDMemTable1cep: TWideStringField
      FieldName = 'cep'
      Size = 9
    end
    object FDMemTable1logradouro: TWideStringField
      FieldName = 'logradouro'
      Size = 14
    end
    object FDMemTable1complemento: TWideStringField
      FieldName = 'complemento'
      Size = 0
    end
    object FDMemTable1bairro: TWideStringField
      FieldName = 'bairro'
      Size = 6
    end
    object FDMemTable1localidade: TWideStringField
      FieldName = 'localidade'
      Size = 8
    end
    object FDMemTable1uf: TWideStringField
      FieldName = 'uf'
      Size = 2
    end
  end
end
