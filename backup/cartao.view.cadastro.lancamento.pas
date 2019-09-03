unit cartao.view.cadastro.lancamento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DateTimePicker;

type

  { TfrmCadastroLancamento }

  TfrmCadastroLancamento = class(TForm)
    btnAdicionar: TButton;
    btnCancelar: TButton;
    dtData: TDateTimePicker;
    edtDescricao: TEdit;
    edtValor: TEdit;
    lblData: TLabel;
    lblDescricao: TLabel;
    Label3: TLabel;
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FListaDados: TStringList;

  public
    function DadosLancamento: TStringList;

  end;

var
  frmCadastroLancamento: TfrmCadastroLancamento;

implementation

{$R *.lfm}

{ TfrmCadastroLancamento }

procedure TfrmCadastroLancamento.FormCreate(Sender: TObject);
begin
  FListaDados := TStringList.Create;;
end;

function TfrmCadastroLancamento.DadosLancamento: TStringList;
begin
  self.showmodal;
  result := FListaDados;
end;

procedure TfrmCadastroLancamento.btnAdicionarClick(Sender: TObject);
begin
  FListaDados.add(datetostr(dtData.Date));
  FListaDados.add(edtDescricao.text);
  FListaDados.add(edtValor.text);
  self.close;
end;

end.

