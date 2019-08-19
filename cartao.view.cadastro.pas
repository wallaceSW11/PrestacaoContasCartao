unit cartao.view.cadastro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmCadastro }

  TfrmCadastro = class(TForm)
    btnAddPessoa: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    edtPessoa: TEdit;
    Label1: TLabel;
    lbPessoa: TListBox;
    procedure btnAddPessoaClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtPessoaKeyPress(Sender: TObject; var Key: char);
    procedure edtPessoaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lbPessoaDblClick(Sender: TObject);
  private
    procedure AddPessoa;
    procedure CarregarListaPessoa;
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

procedure TfrmCadastro.btnSalvarClick(Sender: TObject);
begin
  SalvarPessoaTXT;
  close;
  self.modalresult := mrOk;
end;

procedure TfrmCadastro.edtPessoaKeyPress(Sender: TObject; var Key: char);
begin

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
  if not FileExists(ExtractFilePath(Application.ExeName) + '\Pessoas.txt') then
  begin
    AssignFile(lArquivo, ExtractFilePath(Application.ExeName) + '\Pessoas.txt');
    rewrite(lArquivo);
    closefile(lArquivo);
  end;

  CarregarListaPessoa;
end;


{ código duplicado - Favor ajustar }
procedure TfrmCadastro.CarregarListaPessoa;
var
  lLinhas: Tstringlist;
  i: integer;
begin
  lLinhas := TStringlist.create;
  lLinhas.LoadFromFile(ExtractFilePath(Application.ExeName) + '\Pessoas.txt');
  lbPessoa.clear;

  for i := 0 to pred(lLinhas.count) do
  begin
    lbPessoa.items.add(lLinhas.strings[i]);
  end;
end;

procedure TfrmCadastro.lbPessoaDblClick(Sender: TObject);
begin
  if trim(edtPessoa.text) <> '' then
  exit;

  edtPessoa.text := lbPessoa.items[lbpessoa.itemindex];
  lbPessoa.DeleteSelected;
end;

procedure TfrmCadastro.SalvarPessoaTXT;
var
  lArquivo: TextFile;
  i: integer;
begin
  AssignFile(lArquivo, ExtractFilePath(Application.ExeName) + '\Pessoas.txt');
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

