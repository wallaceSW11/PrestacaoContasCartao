unit cartao.model.ListaPessoa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cartao.Helper.Diretorios;

type

  { TListaPessoa }

  TListaPessoa = class
    private

     // class var FInstancia: TListaPessoa;

    public
     // constructor Create;
      class function RetornarListaPessoa:TStringList;
      //property ListaPessoa: TStringList read FListaPessoa write FListaPessoa;
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
//
//class function TListaPessoa.ObterDados: TListaPessoa;
//begin
//  if not assigned (Self.FInstancia) then
//    Self.FInstancia := TListaPessoa.Create;
//
//  Result := Self.FInstancia;
//end;
//
//initialization
//  TListaPessoa.FInstancia := nil;
//
//finalization
//  FreeAndNil(TListaPessoa.FInstancia);
end.

