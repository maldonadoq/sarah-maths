program Graphics;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, ParseMath, tachartlazaruspkg, cmdbox, Intersection, Func,
  Matrices, Result, Senl, Interpolacion, Integral, Edo;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMResult, MResult);
  Application.Run;
end.

