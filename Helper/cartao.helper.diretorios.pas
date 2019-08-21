unit Cartao.Helper.Diretorios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, forms;

type

  { THelper }

  THelper = class
    public
      class function RetornarDiretorioArquivoTemp(): string;
      class function RetornarDiretorioArquivoPessoas(): string;
  end;

implementation



{ THelper }

class function THelper.RetornarDiretorioArquivoTemp(): string;
begin
  result := ExtractFilePath(Application.ExeName) + '\temp.ini'
end;

class function THelper.RetornarDiretorioArquivoPessoas(): string;
begin
  result := ExtractFilePath(Application.ExeName) + '\Pessoas.txt';
end;

end.

