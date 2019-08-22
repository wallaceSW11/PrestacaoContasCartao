unit cartao.model.ListaPessoa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cartao.Helper.Diretorios;

type
  TListaPessoa = class
    public
      class function RetornarListaPessoa:TStringList;
  end;

implementation

{ TListaPessoa }

class function TlistaPessoa.RetornarListaPessoa:TStringList;
var
  lLinhas: Tstringlist;
  i: integer;
  lListaPessoa: TStringList;
begin
  lLinhas := TStringlist.create;
  lListaPessoa := TStringList.Create;

  try
    lLinhas.LoadFromFile(THelper.RetornarDiretorioArquivoPessoas);

    for i := 0 to pred(lLinhas.count) do
      lListapessoa.add(lLinhas.strings[i]);

  finally
    lLinhas.free;
  end;

  result := lListaPessoa;
end;
end.

