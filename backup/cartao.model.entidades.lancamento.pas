unit cartao.model.entidades.Lancamento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TCartao }

  { TLancamento }

  TLancamento = class
  private
    FDescricao: string;
    FDtLancamento: TDate;
    FPessoa: string;
    procedure SetDescricao(AValue: string);
    procedure SetDtLancamento(AValue: TDate);
    procedure SetPessoa(AValue: string);
  published
    property DtLancamento: TDate read FDtLancamento write SetDtLancamento;
    property Descricao: string read FDescricao write SetDescricao;
    property Pessoa: string read FPessoa write SetPessoa;
  end;


implementation

{ TLancamento }

procedure TLancamento.SetDescricao(AValue: string);
begin

end;

procedure TLancamento.SetDtLancamento(AValue: TDate);
begin

end;

procedure TLancamento.SetPessoa(AValue: string);
begin
  if FPessoa=AValue then Exit;
  FPessoa:=AValue;
end;

{ TCartao }

procedure TLancamento.SetDescricao(AValue: string);
begin
  if FDescricao=AValue then Exit;
  FDescricao:=AValue;
end;

procedure TLancamento.SetDtLancamento(AValue: TDate);
begin
  if FDtLancamento=AValue then Exit;
  FDtLancamento:=AValue;
end;

end.

