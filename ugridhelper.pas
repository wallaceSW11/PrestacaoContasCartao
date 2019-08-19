unit uGridHelper;

interface

uses
  Grids, Types, Graphics;

type
  THelperGrid = class helper for TStringGrid
  public
    procedure RetirarFoco;
    procedure LimparGrid;
    procedure AjustarColunasGrid;
end;

implementation

{ THelperGrid }

procedure THelperGrid.RetirarFoco;
begin
  Self.Selection := TGridRect(Rect(-1,-1,-1,-1));
end;


procedure THelperGrid.LimparGrid;
var
  i: Integer;
begin
  //for i := 0 to pred(Self.RowCount) do
  //  begin
  //  Self.Rows[i].Clear;
  //  if self.RowCount > 2 then
  //    self.RowCount := self.RowCount -1;
  //  end;

 // with self do
 //begin
 // for i:= 1 to RowCount do
 // Rows[i]:= Rows[i+1];
 // if RowCount >2 then
 // RowCount:=RowCount-1;
 //end; // With Grade

end;

procedure THelperGrid.AjustarColunasGrid;
begin
  Self.ColWidths[1] := Self.Width -
                       Self.ColWidths[0] -
                       Self.ColWidths[2] - 15;
end;
end.

