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

  for i := 6 to pred(FStringGrid.ColCount) do
  begin
    lTotal := 0;
    FListaRelatorio.add('Nome: ' + FStringGrid.cells[i,0]);
    FListaRelatorio.add(Cabecalho);

    for j := 1 to pred(FStringGrid.RowCount) do
    begin
      if (FStringGrid.cells[i,j] <> '') then
      begin
        FListaRelatorio.add(CorpoRelatorio(i,j));
        lTotal := lTotal + strtofloat(FStringGrid.cells[i,j]);
      end;
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
      FStringGridCopia.cells[c,r] := FStringGrid.cells[c,r];


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

  for lCol := 6 to pred(FStringGrid.ColCount) do
  begin
    lCont2 := 0;

    for lRow := 1 to pred(FStringGrid.RowCount) do
      if (FStringGrid.cells[lCol,lRow] = trim('')) then
        lCont2 := lcont2 + 1;

    if (lCont2 = pred(FStringGrid.RowCount)) then
    begin
      setLength(lListaExcluir, lcont + 1);
      lListaExcluir[lCont] := lCol;
      lCont := lcont + 1;
    end;
  end;

  for lQt := pred(lCont) downto 0 do
    FStringGrid.DeleteCol(lListaExcluir[lQt]);
end;

function TRelatorio.Cabecalho(): String;
var
  lEspaco1, lEspaco2, lSeparador: string;
begin
  lEspaco1 := stringOfChar(' ', 7);
  lEspaco2 := stringOfChar(' ', 35);
  lSeparador := stringofchar('-',62);
  result := 'Data' + lEspaco1 + 'Descrição'+ lEspaco2 + 'Valor' +#13+lSeparador;
end;

function TRelatorio.CorpoRelatorio(pColuna, pLinha: integer): string;
var
  lData, lDescricao, lValor: string;
begin
  lData := FStringGrid.cells[2,pLinha]+ ' ';
  lDescricao := FStringGrid.cells[3,pLinha];
  lValor := FStringGrid.cells[pColuna,pLinha];
  result := lData + RetornarDescricao_Valor(lDescricao, lValor);
end;


function TRelatorio.RetornarDescricao_Valor(pDescricao, pValor: string):string;
var
  lTamanhoValor, lTamanhoDescricao: integer;
begin
  lTamanhoDescricao := length(pDescricao);
  lTamanhoValor := length(pValor);

  case lTamanhoValor of
  7: result := pDescricao + stringOfChar(' ', 44 - lTamanhoDescricao) + pValor;
  6: result := pDescricao + stringOfChar(' ', 45 - lTamanhoDescricao) + pValor;
  5: result := pDescricao + stringOfChar(' ', 46 - lTamanhoDescricao) + pValor;
  4: result := pDescricao + stringOfChar(' ', 47 - lTamanhoDescricao) + pValor;
  end;
end;

function TRelatorio.Rodape(pTotal: string): string;
var
  lLinha: string;
  lTamanhoValor: integer;
begin
  lTamanhoValor := length(pTotal);
  lLinha := stringofchar('-', 62);

  case lTamanhoValor of
  8: result := lLinha + #13 + 'Total:' + stringOfChar(' ', 54 - 6) + pTotal + #13 + lLinha + #13;
  7: result := lLinha + #13 + 'Total:' + stringOfChar(' ', 55 - 6) + pTotal + #13 + lLinha + #13;
  6: result := lLinha + #13 + 'Total:' + stringOfChar(' ', 56 - 6) + pTotal + #13 + lLinha + #13;
  5: result := lLinha + #13 + 'Total:' + stringOfChar(' ', 57 - 6) + pTotal + #13 + lLinha + #13;
  4: result := lLinha + #13 + 'Total:' + stringOfChar(' ', 58 - 6) + pTotal + #13 + lLinha + #13;
  end;
end;

end.


