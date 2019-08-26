unit cartao.view.relatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmRelatorio }

  TfrmRelatorio = class(TForm)
    mmRelatorio: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmRelatorio: TfrmRelatorio;

implementation

{$R *.lfm}

{ TfrmRelatorio }

procedure TfrmRelatorio.FormCreate(Sender: TObject);
begin
  mmRelatorio.clear;
  mmRelatorio.Font.Name := 'Courier New';
end;

end.

