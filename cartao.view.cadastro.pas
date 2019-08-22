unit cartao.view.cadastro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  cartao.helper.diretorios, LCLType, cartao.model.ListaPessoa;

type

  { TfrmCadastro }

  TfrmCadastro = class(TForm)
    btnAddPessoa: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    btnExcluirPessoa: TButton;
    edtPessoa: TEdit;
    Label1: TLabel;
    lbPessoa: TListBox;
    procedure btnAddPessoaClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirPessoaClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtPessoaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lbPessoaClick(Sender: TObject);
    procedure lbPessoaDblClick(Sender: TObject);
  private
    procedure AddPessoa;
    procedure CarregarListaPessoa;
    procedure ExcluirCadastro();
    procedure SalvarPessoaTXT;

  public

  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.lfm}

{ TfrmCadastro }

procedure TfrmCadastro.btnAddPessoaClick(Sender: TObject);
begin
  AddPessoa;
end;

procedure TfrmCadastro.AddPessoa;
begin
  if trim(edtPessoa.text) = '' then
  exit;

  lbPessoa.Items.Add(edtPessoa.text);
  edtPessoa.clear();
  edtPessoa.SetFocus;
end;

procedure TfrmCadastro.btnCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCadastro.btnExcluirPessoaClick(Sender: TObject);
begin
  ExcluirCadastro;
end;

procedure TfrmCadastro.btnSalvarClick(Sender: TObject);
begin
  SalvarPessoaTXT;
  close;
  self.modalresult := mrOk;
end;


procedure TfrmCadastro.edtPessoaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    AddPessoa;
end;

procedure TfrmCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    AddPessoa;
end;



procedure TfrmCadastro.FormShow(Sender: TObject);
var
  lArquivo: TextFile;
begin
  if not FileExists(THelper.RetornarDiretorioArquivoPessoas) then
  begin
    AssignFile(lArquivo, THelper.RetornarDiretorioArquivoPessoas);
    rewrite(lArquivo);
    closefile(lArquivo);
  end;

  CarregarListaPessoa;
  btnExcluirPessoa.visible := false;
end;

procedure TfrmCadastro.lbPessoaClick(Sender: TObject);
begin
  btnExcluirPessoa.visible := (lbpessoa.itemindex > 0)
end;

procedure TfrmCadastro.CarregarListaPessoa;
var
  i: integer;
begin
  for i := 0 to pred(TListaPessoa.RetornarListaPessoa.count) do
    lbPessoa.items.add(TListaPessoa.RetornarListaPessoa.strings[i]);
end;

procedure TfrmCadastro.lbPessoaDblClick(Sender: TObject);
begin
  if trim(edtPessoa.text) <> '' then
  exit;

  edtPessoa.text := lbPessoa.items[lbpessoa.itemindex];
  lbPessoa.DeleteSelected;
end;

procedure TfrmCadastro.ExcluirCadastro();
begin
  if (Application.MessageBox('Confirma excluir o cadastro selecionado ?', 'Confirmação', MB_ICONQUESTION + MB_YESNO) = IDYES) then
    begin
      lbPessoa.DeleteSelected;
      btnExcluirPessoa.visible := false;
    end;
end;

procedure TfrmCadastro.SalvarPessoaTXT;
var
  lArquivo: TextFile;
  i: integer;
begin
  AssignFile(lArquivo, THelper.RetornarDiretorioArquivoPessoas);
  Rewrite(lArquivo);

  try
    for i := 0 to pred(lbPessoa.count) do
    begin
      writeln(larquivo, lbPessoa.items[i]);
    end;

  finally
    closefile(larquivo);
  end;

end;

end.

