unit uGridHelper;

interface

uses
  Grids, Types, Graphics;

type

  { THelperGrid }

  THelperGrid = class helper for TStringGrid
  public
    procedure RetirarFoco;
    procedure AjustarColunasGrid;
    procedure AddLinha;
    procedure AddColuna(pTitulo: string; pTamanho: integer);
    procedure RemoverUltimaColuna;
end;

implementation

{ THelperGrid }

procedure THelperGrid.RetirarFoco;
begin
  Self.Selection := TGridRect(Rect(-1,-1,-1,-1));
end;

procedure THelperGrid.AjustarColunasGrid;
begin
  Self.ColWidths[1] := Self.Width -
                       Self.ColWidths[0] -
                       Self.ColWidths[2] - 15;
end;

procedure THelperGrid.AddLinha;
begin
  if (Self.Cells[2,0] <> '') then
    Self.RowCount := Self.RowCount + 1;
end;

procedure THelperGrid.AddColuna(pTitulo: string; pTamanho: integer);
begin
  sgPrincipal.Cells[sgPrincipal.colcount-1,0] := pTitulo;
  sgPrincipal.ColWidths[sgPrincipal.colcount-1] := pTamanho;
  sgprincipal.ColCount:=sgprincipal.ColCount+1;

  //if (Self.cells[Self.colcount-1,0] <> '') then
  // Self.colcount := Self.colcount + 1;
end;

procedure THelperGrid.RemoverUltimaColuna;
begin
  self.ColCount:=self.ColCount-1;
end;

end.

