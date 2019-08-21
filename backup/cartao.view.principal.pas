unit Cartao.View.Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls, Menus,
  cartao.view.relatorio, cartao.view.cadastro, uGridHelper, IniFiles,
  LCLType, cartao.Helper.diretorios;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTotalImportado: TLabel;
    lblDiferenca: TLabel;
    lblTotalSelecionado: TLabel;
    MenuItem1: TMenuItem;
    mCadastro: TMenuItem;
    MenuItem3: TMenuItem;
    mLimparTela: TMenuItem;
    mSobre: TMenuItem;
    mRelatorio: TMenuItem;
    mSalvar: TMenuItem;
    mAbrir: TMenuItem;
    mImportarTXT: TMenuItem;
    mCadastroPessoa: TMenuItem;
    mMenu: TMainMenu;
    odDiretorio: TOpenDialog;
    sgPrincipal: TStringGrid;
    procedure btnAbrirClick(Sender: TObject);
    procedure btnCadastroClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mAbrirClick(Sender: TObject);
    procedure mCadastroPessoaClick(Sender: TObject);
    procedure mLimparTelaClick(Sender: TObject);
    procedure mRelatorioClick(Sender: TObject);
    procedure mImportarTXTClick(Sender: TObject);
    procedure mSalvarClick(Sender: TObject);
    procedure sgPrincipalClick(Sender: TObject);
    procedure sgPrincipalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelecionarValor(Sender: TObject);
    procedure sgPrincipalSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    FTotalImportado: double;
    FTotalSelecionado: double;
    FDiretorioArquivo: string;
    procedure AddColuna(pTitulo: string; pTamanho: integer);
    procedure AlterarCorLabel(pValor: double);
    procedure AtivarBotaoSalvar_Cadastro(pAtivar:boolean = True);
    procedure AtualizarValorLabel(pLabel: TLabel; pValor: double);
    procedure CadastroPessoa;
    procedure CarregarArquivoTemp;
    function CarregarListaPessoa(): TStringlist;
    Procedure CriarColunasGrid;
    procedure GerarColunaPessoa(pListaPessoa: TStringList);
    procedure GerarRelatorio;
    procedure ImportarCartao;
    procedure LimparTela;
    function MarcarValor(): Double;
    procedure CalcularTotalSelecionado;
    function Cabecalho(): String;
    function CorpoRelatorio(pColuna, pLinha: integer): string;
    procedure ImportarArquivoTXT();
    procedure ProcedimentosIniciais;
    function Rodape(pTotal: string):string;
    procedure SalvarDadosGrid;
    procedure SomarValoresLinha();
    function ValidarArquivo(): Boolean;
    procedure ValidarArquivoTemp;
    procedure ZerarValores;
    procedure PreencherGrid(pArquivo: TIniFile; pLista: TStringList);
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ProcedimentosIniciais;
end;

procedure TfrmPrincipal.ProcedimentosIniciais;
begin
  CriarColunasGrid;
  ValidarArquivoTemp;
  mSalvar.Enabled:= false;
end;

procedure TfrmPrincipal.ValidarArquivoTemp;
var
  lArquivo: TextFile;
begin
  if not FileExists(THelper.RetornarDiretorioArquivoTemp) then
  begin
    AssignFile(lArquivo, THelper.RetornarDiretorioArquivoTemp);
    rewrite(larquivo);
    closefile(larquivo);
  end;
end;

procedure TfrmPrincipal.mAbrirClick(Sender: TObject);
begin
  CarregarArquivoTemp;
end;

procedure TfrmPrincipal.mCadastroPessoaClick(Sender: TObject);
begin
  CadastroPessoa;
end;

procedure TfrmPrincipal.mLimparTelaClick(Sender: TObject);
begin
  LimparTela;
end;

procedure TfrmPrincipal.LimparTela;
begin
  if (Application.MessageBox('Confirma limpar os dados ?', 'Confirmação', MB_ICONQUESTION + MB_YESNO) = IDYES) then
  begin
    CriarColunasGrid;
    AtivarBotaoSalvar_Cadastro(False);
    ZerarValores;
  end;
end;

procedure TfrmPrincipal.ZerarValores;
begin
  FTotalSelecionado := 0;
  FTotalImportado := 0;
  AtualizarValorLabel(lblTotalImportado,0);
  AtualizarValorLabel(lblTotalSelecionado,0);
  AtualizarValorLabel(lblDiferenca,0);
  lblDiferenca.Font.color := clblack;
end;

procedure TfrmPrincipal.mRelatorioClick(Sender: TObject);
begin
  GerarRelatorio;
end;

procedure TfrmPrincipal.mImportarTXTClick(Sender: TObject);
begin
  ImportarCartao;
end;

procedure TfrmPrincipal.mSalvarClick(Sender: TObject);
begin
  SalvarDadosGrid;
end;


procedure TfrmPrincipal.sgPrincipalClick(Sender: TObject);
begin
  SomarValoresLinha();
end;

procedure TfrmPrincipal.sgPrincipalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    SomarValoresLinha;
end;



procedure TfrmPrincipal.SomarValoresLinha();
var
  i: integer;
  lValor: double;
begin
  if sgPrincipal.row = 0 then
    exit;

  lValor := 0;

  for i := 6 to pred(sgPrincipal.ColCount) do
    if (sgPrincipal.Cells[i, sgPrincipal.Row] <> '') then
      lValor := lValor + strtofloat(sgPrincipal.Cells[i, sgPrincipal.Row]);

  sgPrincipal.cells[5, sgPrincipal.row] := formatfloat('0.00', lValor);

  CalcularTotalSelecionado;
end;

procedure TfrmPrincipal.SelecionarValor(Sender: TObject);
var
  i, j, lcont: integer;
  lMarcado : array of integer;
  lTotal: double;
begin
  if (sgPrincipal.Col < 6) then
  exit;

  lTotal := MarcarValor();
  lcont := 0;

  for i := 6 to pred(sgPrincipal.ColCount) do
  begin
    if (sgPrincipal.cells[i, sgPrincipal.row] <> '') then
    begin
      setLength(lMarcado, lcont + 1);
      lMarcado[lCont] := i;
      lCont := lcont + 1;
    end;
  end;

  if lcont > 0 then
  begin
    lTotal := (lTotal / lCont);

    for j := 0 to pred(lcont) do
    begin
      sgPrincipal.cells[lMarcado[j], sgPrincipal.Row] := formatfloat('0.00', lTotal);
 	  end;
  end;

  SomarValoresLinha;
end;

procedure TfrmPrincipal.sgPrincipalSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  sgPrincipal.Options := sgPrincipal.Options - [goEditing];

  if ACol > 5 then
    sgPrincipal.Options := sgPrincipal.Options + [goEditing]
end;

function TfrmPrincipal.MarcarValor():Double;
var
  lCelula, lValorSelecionado: string;
begin
  lCelula := sgPrincipal.cells[sgPrincipal.Col, sgPrincipal.row];
  lValorSelecionado := sgPrincipal.cells[4, sgPrincipal.row];

  sgPrincipal.cells[sgPrincipal.Col, sgPrincipal.row] := '';
  sgPrincipal.cells[1,sgPrincipal.row] := '';

  if (lCelula = '') then
  begin
    sgPrincipal.cells[sgPrincipal.Col, sgPrincipal.row] := lValorSelecionado;
    sgPrincipal.cells[1,sgPrincipal.row] := 'S'
  end;

  result := strtofloat(lValorSelecionado);
end;

//procedure TfrmPrincipal.sgPrincipalSelectCell(Sender: TObject; aCol: Integer);
//begin
//  sgPrincipal.Options := sgPrincipal.Options - [goEditing];
//
//  if ACol > 5 then
//    sgPrincipal.Options := sgPrincipal.Options + [goEditing]
//end;

procedure TfrmPrincipal.CalcularTotalSelecionado;
var
  i: integer;
begin
  FTotalSelecionado := 0;

  for i := 1 to pred(sgPrincipal.RowCount) do
    if (sgPrincipal.cells[5,i] <> '') then
    		FTotalSelecionado := FTotalSelecionado + strtofloat(sgPrincipal.cells[5, i]);

  AlterarCorLabel(FTotalSelecionado - FTotalImportado);
  AtualizarValorLabel(lblTotalSelecionado, FTotalSelecionado);
  AtualizarValorLabel(lblDiferenca, FTotalSelecionado - FTotalImportado);
end;

procedure TfrmPrincipal.AlterarCorLabel(pValor: double);
begin
  lblDiferenca.font.Color := clBlack;

  if pValor < 0 then
    lblDiferenca.font.Color := clRed;
end;

procedure TfrmPrincipal.AtualizarValorLabel(pLabel: TLabel; pValor: double);
begin
 pLabel.caption := formatFloat('R$ 0.00', pValor);
end;

function TfrmPrincipal.Cabecalho(): String;
var
  lEspaco1, lEspaco2: string;
begin
  lEspaco1 := stringOfChar(' ', 7);
  lEspaco2 := stringOfChar(' ', 35);
  result := 'Data' + lEspaco1 + 'Descrição'+ lEspaco2 + 'Valor';
end;

function TfrmPrincipal.CorpoRelatorio(pColuna, pLinha: integer): string;
var
  lEspaco2: string;
begin
  lEspaco2 := stringOfChar(' ', 44 - length(sgPrincipal.cells[3,pLinha]));
  result := sgPrincipal.cells[2,pLinha] + ' ' + sgPrincipal.cells[3,pLinha] + lEspaco2 + sgPrincipal.cells[pColuna,pLinha];
end;

function TfrmPrincipal.Rodape(pTotal: string): string;
var
  lEspaco, lSeparador: string;
begin
  lEspaco := stringofchar('.', 49);
  lSeparador := stringofchar('_', 60);
  result := lSeparador + #13 + 'Total:' + lEspaco + pTotal + #13;
end;

procedure TfrmPrincipal.btnCadastroClick(Sender: TObject);
begin
  CadastroPessoa;
end;


procedure TfrmPrincipal.CadastroPessoa;
var
  lTelaCadastro: TfrmCadastro;
begin
  lTelaCadastro := TfrmCadastro.create(nil);

  try
    lTelaCadastro.ShowModal;
    if lTelaCadastro.ModalResult = mrOK then
      CriarColunasGrid;
  finally
    lTelaCadastro.free;
  end;

end;

procedure TfrmPrincipal.btnAbrirClick(Sender: TObject);
begin
  CarregarArquivoTemp;
end;

procedure TfrmPrincipal.CarregarArquivoTemp;
var
  lLista: TStringList;
  lArquivo: TiniFile;
begin
  lLista :=  TStringlist.Create;
  lArquivo := Tinifile.create(THelper.RetornarDiretorioArquivoTemp);
  lArquivo.ReadSections(lLista);

  try
    if (lLista.count = 0) then
  		  exit;

    PreencherGrid(lArquivo, lLista);
  finally
    lArquivo.free;
    CalcularTotalSelecionado;
    AtualizarValorLabel(lblTotalImportado,FTotalImportado);
    AtivarBotaoSalvar_Cadastro(FTotalImportado > 0);
  end;
end;



procedure TfrmPrincipal.AtivarBotaoSalvar_Cadastro(pAtivar:boolean = True);
begin
  mSalvar.Enabled := pAtivar;
  mCadastro.Enabled := not pAtivar;
end;

procedure TfrmPrincipal.btnImportarClick(Sender: TObject);
begin
  ImportarCartao;
end;

procedure TfrmPrincipal.ImportarCartao;
begin
  odDiretorio.Filter := 'Arquivos de texto|*.txt';
  odDiretorio.execute;
  FDiretorioArquivo := odDiretorio.FileName;

  if ValidarArquivo then
  		ImportarArquivoTXT;
end;

procedure TfrmPrincipal.btnSalvarClick(Sender: TObject);
begin
  SalvarDadosGrid;
end;

procedure TfrmPrincipal.SalvarDadosGrid;
var
  i, j: integer;
  lArquivo: TextFile;
begin
  AssignFile(lArquivo, THelper.RetornarDiretorioArquivoTemp);
  rewrite(larquivo);
  sgPrincipal.ColWidths[0] := 20;
  sgPrincipal.ColWidths[1] := 20;

  for i := 1 to pred(sgPrincipal.RowCount) do
  begin
    writeln(lArquivo, '[Linha_'+inttostr(i)+']');
    writeln(lArquivo, 'ID=' + sgPrincipal.cells[0,i]);
    writeln(lArquivo, 'Marcado=' + sgPrincipal.cells[1,i]);
    writeln(lArquivo, 'Data=' + sgPrincipal.cells[2,i]);
    writeln(lArquivo, 'Descricao=' + sgPrincipal.cells[3,i]);
    writeln(lArquivo, 'Valor=' + sgPrincipal.cells[4,i]);
    writeln(lArquivo, 'Selecionado=' + sgPrincipal.cells[5,i]);

    for j := 6 to pred(sgPrincipal.ColCount) do
    begin
      writeln(lArquivo, 'ValorInformado_'+inttostr(j)+'=' + sgPrincipal.cells[j,i]);
    end;

    writeln(larquivo, '');
  end;

  closefile(larquivo);
  sgPrincipal.ColWidths[0] := 0;
  sgPrincipal.ColWidths[1] := 0;

  showmessage('Salvo com sucesso!');
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  GerarRelatorio;
end;

procedure TfrmPrincipal.GerarRelatorio;
var
  i, j: integer;
  lTela: TfrmRelatorio;
  lTotal: double;
begin
  lTela := TfrmRelatorio.create(nil);
  lTela.mmRelatorio.clear;

  for i := 6 to pred(sgPrincipal.ColCount) do
  begin
    lTotal := 0;
    lTela.mmRelatorio.lines.add(sgPrincipal.cells[i,0]);
    lTela.mmRelatorio.lines.add(Cabecalho);

    for j := 1 to pred(sgPrincipal.RowCount) do
    begin
      if (sgPrincipal.cells[i,j] <> '') then
      begin
        lTela.mmRelatorio.lines.add(CorpoRelatorio(i,j));
        lTotal := lTotal + strtofloat(sgPrincipal.cells[i,j]);
      end;
    end;
    lTela.mmRelatorio.lines.add(rodape(floattostr(lTotal)));
  end;

 lTela.showmodal;
 lTela.free;
end;

procedure TfrmPrincipal.CriarColunasGrid;
begin
  sgPrincipal.ColCount := 1;
  sgPrincipal.RowCount := 1;
  sgPrincipal.Options := [goFixedHorzLine, goFixedVertLine, goHorzLine, goVertLine];

  AddColuna('ID',0);
  AddColuna('Marcado',0);
  AddColuna('Data',70);
  AddColuna('Descrição',250);
  AddColuna('Valor',100);
  AddColuna('Selecionado',100);

  GerarColunaPessoa(CarregarListaPessoa);
  sgprincipal.RemoverUltimaColuna;
end;

procedure TfrmPrincipal.AddColuna(pTitulo: string; pTamanho: integer);
begin
  sgPrincipal.Cells[sgPrincipal.colcount-1,0] := pTitulo;
  sgPrincipal.ColWidths[sgPrincipal.colcount-1] := pTamanho;
  sgprincipal.ColCount:=sgprincipal.ColCount+1;
end;

procedure TfrmPrincipal.GerarColunaPessoa(pListaPessoa: TStringList);
var
  i: integer;
begin
  for i := 0 to pred(pListaPessoa.count) do
    AddColuna(pListaPessoa[i],80);
end;

{ código duplicado - Favor ajustar }
function TfrmPrincipal.CarregarListaPessoa(): TStringlist;
var
  lLinhas: Tstringlist;
  lTela: TfrmCadastro;
begin
  lLinhas := TStringlist.create;

  if not FileExists(THelper.RetornarDiretorioArquivoPessoas) then
  begin
    showmessage('Por favor, cadastre as pessoas na tela a seguir e clique em Salvar');
    lTela := TfrmCadastro.create(nil);
    try
      lTela.showmodal;
    finally
      lTela.free;
    end;
  end;

  lLinhas.LoadFromFile(THelper.RetornarDiretorioArquivoPessoas);
  result := lLinhas;
end;


procedure TfrmPrincipal.ImportarArquivoTXT();
var
  linhas,colunas: TStringList;
  i:Integer;
begin
  colunas := TStringList.Create();
  linhas := TStringList.Create();

  FTotalImportado := 0;

  CriarColunasGrid;

  try
   Linhas.LoadFromFile(FDiretorioArquivo);

  For i:= 0 to linhas.Count - 1 do
  begin
    colunas.Delimiter := ';';
    colunas.StrictDelimiter:= true;
    colunas.DelimitedText := linhas[i];

    sgPrincipal.AddLinha;
    sgPrincipal.cells[0,i+1] := inttostr(i);
    sgPrincipal.cells[2,i+1] := colunas.Strings[0];
    sgPrincipal.cells[3,i+1] := colunas.Strings[1];
    sgPrincipal.cells[4,i+1] := colunas.Strings[2];

    FTotalImportado := FTotalImportado + strtofloat(colunas.Strings[2]);
  end;
  finally
    colunas.Free;
    linhas.free;
  end;

  AtualizarValorLabel(lblTotalImportado,FTotalImportado);
  CalcularTotalSelecionado;
end;

function TfrmPrincipal.ValidarArquivo():Boolean;
begin
  result := (trim(FDiretorioArquivo) <> '');
  mSalvar.Enabled := result;
  mCadastro.Enabled:= not result;
end;



procedure TfrmPrincipal.PreencherGrid(pArquivo: TIniFile; pLista: TStringList);
var
  i, j: integer;
begin
  FTotalImportado := 0;
  CriarColunasGrid;

  for i := 0 to pred(pLista.count) do
  begin
    sgPrincipal.AddLinha;
    sgPrincipal.Cells[0,i+1] := pArquivo.ReadString(pLista.Strings[i], 'ID', '');
    sgPrincipal.Cells[1,i+1] := pArquivo.ReadString(pLista.Strings[i], 'Marcado', '');
    sgPrincipal.Cells[2,i+1] := pArquivo.ReadString(pLista.Strings[i], 'Data', '');
    sgPrincipal.Cells[3,i+1] := pArquivo.ReadString(pLista.Strings[i], 'Descricao', '');
    sgPrincipal.Cells[4,i+1] := pArquivo.ReadString(pLista.Strings[i], 'Valor', '');
    sgPrincipal.Cells[5,i+1] := pArquivo.ReadString(pLista.Strings[i], 'Selecionado', '');

    for j := 0 to pred(CarregarListaPessoa.Count) do
      sgPrincipal.Cells[j+6,i+1] := pArquivo.ReadString(pLista.Strings[i], 'ValorInformado_'+inttostr(j+6), '');

    FTotalImportado := FTotalImportado + strtofloat(sgPrincipal.Cells[4,i+1]);
  end;
end;

end.


