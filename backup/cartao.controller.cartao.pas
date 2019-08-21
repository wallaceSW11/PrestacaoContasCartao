unit cartao.controller.cartao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cartao.model.entidades.Cartao;

type

  { TControllerCartao }

  TControllerCartao = class
    public
      function RetornarCartaoImportado(): TCartao;
  end;

implementation



{ TControllerCartao }

function TControllerCartao.RetornarCartaoImportado(): TCartao;
var
  lCartao: TCartao;
begin
  lcartao := TCartao.create;
  lCartao.DtLancamento := date(now);
  lCartao.Descricao:= 'posta SP';
  result := lCartao;



end;

end.

