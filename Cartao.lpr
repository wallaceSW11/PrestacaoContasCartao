program Cartao;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Cartao.View.Principal, cartao.controller.cartao,
  cartao.model.entidades.Lancamento, cartao.view.relatorio,
  cartao.view.cadastro, uGridHelper, cartao.helper.diretorios, cartao.model.ListaPessoa;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

