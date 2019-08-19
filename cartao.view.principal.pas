unit Cartao.View.Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  cartao.view.relatorio, Types, cartao.view.cadastro, uGridHelper, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnImportar: TButton;
    btnCadastro: TButton;
    btnAbrir: TButton;
    btnSalvar: TButton;
    Button2: TButton;
    edtDiretorioArquivo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTotalImportado: TLabel;
    lblDiferenca: TLabel;
    lblTotalSelecionado: TLabel;
    odDiretorio: TOpenDialog;
    sgPrincipal: TStringGrid;
    procedure btnAbrirClick(Sender: TObject);
    procedure btnCadastroClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure edtDiretorioArquivoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgPrincipalClick(Sender: TObject);
    procedure sgPrincipalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgPrincipalSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure SelecionarValor(Sender: TObject);
  private
    FTotalImportado: double;
    FTotalSelecionado: double;
    FListaCartao: TStringList;
    procedure CarregarArquivoSalvo;
    function CarregarListaPessoa(): TStringlist;
    Procedure CriarColunasGrid;
    procedure GerarColunaPessoa(pListaPessoa: TStringList);
    procedure PreencherGrid();
    procedure CalcularTotalSelecionado;
    function Cabecalho(): String;
    function CorpoRelatorio(pColuna, pLinha: integer): string;
    procedure ImportarArquivoTXT();
    function Rodape(pTotal: string):string;
    procedure SalvarDadosGrid;
    procedure SomarValoresLinha();
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    function ValidarArquivo(): Boolean;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  lArquivo: TextFile;
begin
  CriarColunasGrid;

  if not FileExists(ExtractFilePath(Application.ExeName) + '\temp.ini') then
  begin
    AssignFile(lArquivo, ExtractFilePath(Application.ExeName) + '\temp.ini');
    rewrite(larquivo);
    closefile(larquivo);
  end;

end;


procedure TForm1.sgPrincipalClick(Sender: TObject);
begin
  SomarValoresLinha();
end;

procedure TForm1.sgPrincipalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  			SomarValoresLinha;
end;

procedure TForm1.SomarValoresLinha();
var
  i: integer;
  lValor: double;
begin
  lValor := 0;

  for i := 6 to pred(sgPrincipal.ColCount) do
  begin
    if (sgPrincipal.Cells[i, sgPrincipal.Row] <> '') then
      lValor := lValor + strtofloat(sgPrincipal.Cells[i, sgPrincipal.Row]);
  end;

  sgPrincipal.cells[5, sgPrincipal.row] := formatfloat('0.00', lValor);

  CalcularTotalSelecionado;
end;

procedure TForm1.SelecionarValor(Sender: TObject);
var
  i, j, lcont: integer;
  lMarcado : array of integer;
  lTotal: double;

  lCelula, lValorSelecionado: string;
begin
  if sgPrincipal.Col < 6 then
  exit;

  lCelula := sgPrincipal.cells[sgPrincipal.Col, sgPrincipal.row];
  lValorSelecionado := sgPrincipal.cells[4, sgPrincipal.row];

  // marcar valor
  if (lCelula = '') then
  begin
    sgPrincipal.cells[sgPrincipal.Col, sgPrincipal.row] := lValorSelecionado;
    sgPrincipal.cells[1,sgPrincipal.row] := 'S'
  end
  else
  begin
    sgPrincipal.cells[sgPrincipal.Col, sgPrincipal.row] := '';
    sgPrincipal.cells[1,sgPrincipal.row] := ''
  end;

  // dividir valor
  lTotal := strtofloat (lValorSelecionado);
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

procedure TForm1.sgPrincipalSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  if ACol > 5 then
    sgPrincipal.Options := sgPrincipal.Options + [goEditing]
  else
    sgPrincipal.Options := sgPrincipal.Options - [goEditing];
end;

procedure TForm1.CalcularTotalSelecionado;
var
  i: integer;
  lDiferenca: double;
begin
  FTotalSelecionado := 0;

  for i := 1 to pred(sgPrincipal.RowCount) do
    if (sgPrincipal.cells[5,i] <> '') then
    		FTotalSelecionado := FTotalSelecionado + strtofloat(sgPrincipal.cells[5, i]);

  lDiferenca := FTotalSelecionado - FTotalImportado;

  lblDiferenca.font.Color := clBlack;

  if lDiferenca < 0 then
		  lblDiferenca.font.Color := clRed;

  lblTotalSelecionado.Caption := formatFloat('R$ 0.00', FTotalSelecionado);
  lblDiferenca.caption := formatfloat('R$ 0.00', lDiferenca);
end;

function TForm1.Cabecalho(): String;
var
  lEspaco1, lEspaco2: string;
begin
  lEspaco1 := stringOfChar(' ', 7);
  lEspaco2 := stringOfChar(' ', 35);
  result := 'Data' + lEspaco1 + 'Descrição'+ lEspaco2 + 'Valor';
end;

function TForm1.CorpoRelatorio(pColuna, pLinha: integer): string;
var
  lEspaco2: string;
begin
  lEspaco2 := stringOfChar(' ', 44 - length(sgPrincipal.cells[3,pLinha]));
  result := sgPrincipal.cells[2,pLinha] + ' ' + sgPrincipal.cells[3,pLinha] + lEspaco2 + sgPrincipal.cells[pColuna,pLinha];
end;

function TForm1.Rodape(pTotal: string): string;
var
  lEspaco, lSeparador: string;
begin
  lEspaco := stringofchar('.', 49);
  lSeparador := stringofchar('_', 60);
  result := lSeparador + #13 + 'Total:' + lEspaco + pTotal + #13;
end;

procedure TForm1.btnCadastroClick(Sender: TObject);
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

procedure TForm1.btnAbrirClick(Sender: TObject);
begin
  CarregarArquivoSalvo;
end;

procedure TForm1.CarregarArquivoSalvo;
var
  lLista: TStringList;
  lArquivo: TiniFile;
  i, j: integer;
begin
  lLista :=  TStringlist.Create;
  lArquivo := Tinifile.create(ExtractFilePath(Application.ExeName) + '\temp.ini');

  lArquivo.ReadSections(lLista);

  sgPrincipal.LimparGrid;
  CriarColunasGrid;

  for i := 0 to pred(lLista.count) do
  begin
    if (sgprincipal.Cells[2,0] <> '') then
            sgprincipal.RowCount := sgprincipal.RowCount + 1;

    sgPrincipal.Cells[0,i+1] := lArquivo.ReadString(lLista.Strings[i], 'ID', '');
    sgPrincipal.Cells[1,i+1] := lArquivo.ReadString(lLista.Strings[i], 'Marcado', '');
    sgPrincipal.Cells[2,i+1] := lArquivo.ReadString(lLista.Strings[i], 'Data', '');
    sgPrincipal.Cells[3,i+1] := lArquivo.ReadString(lLista.Strings[i], 'Descricao', '');
    sgPrincipal.Cells[4,i+1] := lArquivo.ReadString(lLista.Strings[i], 'Valor', '');
    sgPrincipal.Cells[5,i+1] := lArquivo.ReadString(lLista.Strings[i], 'Selecionado', '');

    for j := 0 to pred(CarregarListaPessoa.Count) do
      sgPrincipal.Cells[j+6,i+1] := lArquivo.ReadString(lLista.Strings[i], 'ValorInformado_'+inttostr(j+6), '');

  FTotalImportado := FTotalImportado + strtofloat(sgPrincipal.Cells[4,i+1]);

  end;

  lArquivo.free;
  CalcularTotalSelecionado;
  lblTotalImportado.caption := formatfloat('R$ 0.00', FTotalImportado);

end;

procedure TForm1.btnImportarClick(Sender: TObject);
begin
  odDiretorio.Filter := 'Arquivos de texto|*.txt';
  odDiretorio.execute;
  edtDiretorioArquivo.text := odDiretorio.FileName;

  if ValidarArquivo then
  			ImportarArquivoTXT;
end;

procedure TForm1.btnSalvarClick(Sender: TObject);
begin
  SalvarDadosGrid;
end;

procedure TForm1.SalvarDadosGrid;
var
  i, j: integer;
  lArquivo: TextFile;
begin
  AssignFile(lArquivo, ExtractFilePath(Application.ExeName) + '\temp.ini');
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

procedure TForm1.Button2Click(Sender: TObject);
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

procedure TForm1.edtDiretorioArquivoChange(Sender: TObject);
begin
  btnCadastro.enabled := (edtDiretorioArquivo.text = '');

end;

procedure TForm1.CriarColunasGrid;
begin
  sgPrincipal.ColCount := 6;
  sgPrincipal.RowCount := 1;
  sgPrincipal.Options := [goFixedHorzLine,
                          goFixedVertLine,
                          goHorzLine,
                          goVertLine];

  sgPrincipal.Cells[0,0] := 'ID';
  sgPrincipal.ColWidths[0] := 0;
  sgPrincipal.Cells[1,0] := 'Marcado';
  sgPrincipal.ColWidths[1] := 0;
  sgPrincipal.Cells[2,0] := 'Data';
  sgPrincipal.ColWidths[2] := 70;
  sgPrincipal.Cells[3,0] := 'Descrição';
  sgPrincipal.ColWidths[3] := 250;
  sgPrincipal.Cells[4,0] := 'Valor';
  sgPrincipal.ColWidths[4] := 100;
  sgPrincipal.Cells[5,0] := 'Selecionado';
  sgPrincipal.ColWidths[5] := 100;

  GerarColunaPessoa(CarregarListaPessoa);
end;

procedure TForm1.GerarColunaPessoa(pListaPessoa: TStringList);
var
  i: integer;
begin
  for i := 0 to pred(pListaPessoa.count) do
  begin
    sgPrincipal.ColCount := sgPrincipal.ColCount + 1;
    sgPrincipal.Cells[i+6,0] := pListaPessoa[i];
    sgPrincipal.ColWidths[i+6] := 80;
  end;
end;

{ código duplicado - Favor ajustar }
function TForm1.CarregarListaPessoa(): TStringlist;
var
  lLinhas: Tstringlist;
  i: integer;
  lTela: TfrmCadastro;
begin
  lLinhas := TStringlist.create;

  if not FileExists(ExtractFilePath(Application.ExeName) + '\Pessoas.txt') then
  begin
    showmessage('Por favor, cadastre as pessoas na tela a seguir e clique em Salvar');
    lTela := TfrmCadastro.create(nil);
    try
    lTela.showmodal;
    finally
    end;
    lTela.free;
  end;

  lLinhas.LoadFromFile(ExtractFilePath(Application.ExeName) + '\Pessoas.txt');
  result := lLinhas;
end;


procedure TForm1.ImportarArquivoTXT();
var
  linhas,colunas: TStringList;
  i:Integer;
  lDados: string;
begin
    colunas := TStringList.Create();
    linhas := TStringList.Create();

    sgPrincipal.LimparGrid;
    CriarColunasGrid;

    try
     Linhas.LoadFromFile(edtDiretorioArquivo.text);
      for i:= 0 to linhas.Count - 1 do
      begin
        colunas.Delimiter := ';';
        colunas.StrictDelimiter:= true;
        colunas.DelimitedText := linhas[i];
        //lDados := colunas.Strings[0];

        if (sgprincipal.Cells[2,0] <> '') then
            sgprincipal.RowCount := sgprincipal.RowCount + 1;

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
    lblTotalImportado.caption := formatfloat('R$ 0.00', FTotalImportado);
end;

function TForm1.ValidarArquivo():Boolean;
begin
  result := (trim(edtDiretorioArquivo.text) <> '');
end;

procedure TForm1.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

procedure TForm1.PreencherGrid();
var
  i: integer;
  lValor: double;
begin
  FTotalImportado := 0;
  lValor := 50;

  for i := 1 to 3 do
  begin
    if (sgprincipal.Cells[2,0] <> '') then
            sgprincipal.RowCount := sgprincipal.RowCount + 1;

		  sgprincipal.cells[0,i] := inttostr(i);
    sgprincipal.cells[2,i] := datetostr(TDate(now));
    sgprincipal.cells[3,i] := 'Posto ' +inttostr(i);
    sgprincipal.cells[4,i] := formatfloat('0.00', lValor);

    FTotalImportado := FTotalImportado + lValor;
  end;

  lblTotalImportado.caption := formatfloat('R$ 0.00', FTotalImportado);

end;

end.

