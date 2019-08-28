unit cartao.model.Relatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, grids, dialogs;

type

  { TRelatorio }

  TRelatorio = class
    private
      FListaRelatorio: TStringList;
      FStringGrid: TStringGrid;
      FStringGridCopia: TStringGrid;
      function Cabecalho(): String;
      function CorpoRelatorio(pColuna, pLinha: integer): string;
      procedure RetirarValorZerado;
      function RetornarCopiaGrid(): TStringGrid;
      function RetornarDataEscrita(pData: string): string;
      function RetornarDescricao_Valor(pDescricao, pValor: string): string;
      function Rodape(pTotal: string): string;
    public
      function RetornarRelatorioGerado():TStringList;
      constructor Create(pStringGrid: TStringGrid);
      destructor Destroy; override;
      class function New(pStringGrid: TStringGrid): TRelatorio;

  end;

implementation

{ TRelatorio }

function TRelatorio.RetornarRelatorioGerado(): TStringList;
var
  i, j: integer;
  lTotal: double;
begin
  FListaRelatorio := TStringList.Create;
  RetirarValorZerado;

  for i := 6 to pred(FStringGridCopia.ColCount) do
  begin
    lTotal := 0;
    FListaRelatorio.add('Nome: ' + FStringGridCopia.cells[i,0]);
    FListaRelatorio.add(Cabecalho);

    for j := 1 to pred(FStringGridCopia.RowCount) do
      if (FStringGridCopia.cells[i,j] <> '') then
      begin
        FListaRelatorio.add(CorpoRelatorio(i,j));
        lTotal := lTotal + strtofloat(FStringGridCopia.cells[i,j]);
      end;
    FListaRelatorio.add(rodape(formatfloat('0.00', lTotal)));
  end;
  result := FListaRelatorio;
end;

function TRelatorio.RetornarCopiaGrid():TStringGrid;
var
  c, r: integer;
begin
  FStringGridCopia.ColCount := FStringGrid.ColCount;
  FStringGridCopia.rowcount := FStringGrid.RowCount;

  for c := 0 to pred(FStringGrid.ColCount) do
    for r := 0 to pred(FStringGrid.RowCount) do
      FStringGridCopia.cells[c,r] := trim(FStringGrid.cells[c,r]);

  result := FStringGridCopia;
end;

constructor TRelatorio.Create(pStringGrid: TStringGrid);
begin
  FStringGrid := pStringGrid;
  FStringGridCopia := TStringGrid.create(nil);
end;

destructor TRelatorio.Destroy;
begin
  FreeAndNil(FStringGrid);
  FreeAndNil(FStringGridCopia);
  inherited Destroy;
end;

class function TRelatorio.New(pStringGrid: TStringGrid): TRelatorio;
begin
  result := self.create(pStringGrid);
end;

procedure TRelatorio.RetirarValorZerado;
var
  lCol,lRow, lQt, lCont2, lCont: integer;
  lListaExcluir: array of integer;
begin
  lCont := 0;

  FStringGridCopia := RetornarCopiaGrid;

  for lCol := 6 to pred(FStringGridCopia.ColCount) do
  begin
    lCont2 := 0;

    for lRow := 1 to pred(FStringGridCopia.RowCount) do
      if (FStringGridCopia.cells[lCol,lRow] = trim('')) then
        lCont2 := lcont2 + 1;

    if (lCont2 = pred(FStringGridCopia.RowCount)) then
    begin
      setLength(lListaExcluir, lcont + 1);
      lListaExcluir[lCont] := lCol;
      lCont := lcont + 1;
    end;
  end;

  for lQt := pred(lCont) downto 0 do
    FStringGridCopia.DeleteCol(lListaExcluir[lQt]);
end;

function TRelatorio.Cabecalho(): String;
begin
  result := 'Data' + stringOfChar(' ', 7) +
            'Descrição'+ stringOfChar(' ', 35) +
            'Valor' + #13 + stringofchar('-',62);
end;

function TRelatorio.CorpoRelatorio(pColuna, pLinha: integer): string;
begin
  result := RetornarDataEscrita(FStringGridCopia.cells[2,pLinha]) +
            RetornarDescricao_Valor(FStringGridCopia.cells[3,pLinha], FStringGridCopia.cells[pColuna,pLinha]);
end;

function TRelatorio.RetornarDataEscrita(pData: string):string;
begin
  result := pData + stringOfChar(' ', 11 - length(pData));
end;

function TRelatorio.RetornarDescricao_Valor(pDescricao, pValor: string):string;
begin
  result := pDescricao + stringOfChar(' ', 51 - (length(pValor) + length(pDescricao))) + pValor;
end;

function TRelatorio.Rodape(pTotal: string): string;
begin
  result := stringofchar('-', 62) + #13 +
            'Total:' + stringOfChar(' ', 56 - length(pTotal)) + pTotal + #13 +
            stringofchar('-', 62) + #13;
end;
end.



