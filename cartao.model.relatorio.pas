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
      function Cabecalho(): String;
      function CorpoRelatorio(pColuna, pLinha: integer): string;
      procedure RetirarValorZerado;
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

constructor TRelatorio.Create(pStringGrid: TStringGrid);
begin
 FStringGrid := pStringGrid;
end;

destructor TRelatorio.Destroy;
begin
  inherited Destroy;
end;

class function TRelatorio.New(pStringGrid: TStringGrid): TRelatorio;
begin
  result := self.create(pStringGrid);
end;

procedure TRelatorio.RetirarValorZerado;
var
  i,j, l: integer;
  lVazio: boolean;
  lListaExcluir: array of integer;
   lCont: integer;
begin
  lCont := 0;

  for i := 6 to pred(FStringGrid.ColCount) do
  begin
    for j := 1 to pred(FStringGrid.RowCount) do
    begin
        if (FStringGrid.cells[i,j] <> trim('')) then
          showmessage('Pren: ' + FStringGrid.cells[i,j] + 'lin: ' + inttostr(j) + ' col: ' + inttostr(i))
        //break
        //else
        //
        //begin
        //  setLength(lListaExcluir, lcont + 1);
        //  lListaExcluir[lCont] := i;
        //  lCont := lcont + 1;
        //end;
        //else
        //  lvazio := true;
    end;

    //if lVazio then
    //  begin
    //    setLength(lListaExcluir, lcont + 1);
    //    lListaExcluir[lCont] := i;
    //    lCont := lcont + 1;
    //  end;
  end;

  for l := 0 to pred(lCont) do
    showmessage('ids: ' + inttostr(lListaExcluir[l]));

  //FStringGrid.DeleteCol(lListaExcluir[l]);
  //

  //showmessage('Col2: ' + inttostr(FStringGrid.ColCount));
  //showmessage('Lin2: ' + inttostr(FStringGrid.RowCount));
end;

//procedure TRelatorio.RetirarValorZerado;
//var
//  i,j, l: integer;
//  lVazio: boolean;
//  lListaExcluir: array of integer;
//   lCont: integer;
//begin
//  lCont := 0;
//  //showmessage('Col: ' + inttostr(FStringGrid.ColCount));
//  //showmessage('Lin: ' + inttostr(FStringGrid.RowCount));
//
//  for i := 6 to pred(FStringGrid.ColCount) do
//  begin
//    lVazio := false;
//
//    for j := 1 to pred(FStringGrid.RowCount) do
//    begin
//        if (FStringGrid.cells[i,j] <> trim('')) then
//        			break
//        else
//          lvazio := true;
//    end;
//
//    if lVazio then
//      begin
//        setLength(lListaExcluir, lcont + 1);
//        lListaExcluir[lCont] := i;
//        lCont := lcont + 1;
//      end;
//  end;
//
//  for l := 0 to lCont do
//    showmessage('ids: ' + inttostr(lListaExcluir[l]));
//
//  //FStringGrid.DeleteCol(lListaExcluir[l]);
//  //
//
//  //showmessage('Col2: ' + inttostr(FStringGrid.ColCount));
//  //showmessage('Lin2: ' + inttostr(FStringGrid.RowCount));
//end;

//procedure TRelatorio.RetirarValorZerado;
//var
//  i,j, l: integer;
//  lVazio: boolean;
//  lListaExcluir: array of integer;
//   lCont: integer;
//begin
//  lCont := 0;
//  //showmessage('Col: ' + inttostr(FStringGrid.ColCount));
//  //showmessage('Lin: ' + inttostr(FStringGrid.RowCount));
//
//  for i := 7 to pred(FStringGrid.ColCount) do
//  begin
//    lVazio := false;
//
//    for j := 1 to pred(FStringGrid.RowCount) do
//    begin
//        if (FStringGrid.cells[i,j] <> trim('')) then
//        			break
//        else
//          lvazio := true;
//    end;
//
//    if lVazio then
//      begin
//        setLength(lListaExcluir, lcont + 1);
//        lListaExcluir[lCont] := i;
//        lCont := lcont + 1;
//      end;
//  end;
//
//  for l := 0 to lCont do
//    showmessage('ids: ' + inttostr(lListaExcluir[l]));
//
//  //FStringGrid.DeleteCol(lListaExcluir[l]);
//  //
//
//  //showmessage('Col2: ' + inttostr(FStringGrid.ColCount));
//  //showmessage('Lin2: ' + inttostr(FStringGrid.RowCount));
//end;

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

