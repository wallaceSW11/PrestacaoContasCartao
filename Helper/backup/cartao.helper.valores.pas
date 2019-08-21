unit Cartao.Helper.Valores;

interface

uses
  Classes, SysUtils, StdCtrls, math;


type
  TDoubleHelper = record helper for double
    function ValorMonetario: string;
  end;



implementation

{ TValores }

function TValores.ValorMonetario(): string;
begin
  result := formatfloat('0.00'. self);
end;

function TValores.ValorMonetarioCifrao(): string;
begin
  result := result := formatfloat('R$ 0.00'. self);
end;

end.

