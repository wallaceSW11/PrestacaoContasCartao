unit cartao.model.entidades.Cartao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TCartao }

  TCartao = class
  private
    FDescricao: string;
    FDtLancamento: TDate;
    procedure SetDescricao(AValue: string);
    procedure SetDtLancamento(AValue: TDate);
  published
    property DtLancamento: TDate read FDtLancamento write SetDtLancamento;
    property Descricao: string read FDescricao write SetDescricao;
  end;


implementation

{ TCartao }

procedure TCartao.SetDescricao(AValue: string);
begin
  if FDescricao=AValue then Exit;
  FDescricao:=AValue;
end;

procedure TCartao.SetDtLancamento(AValue: TDate);
begin
  if FDtLancamento=AValue then Exit;
  FDtLancamento:=AValue;
end;

end.

