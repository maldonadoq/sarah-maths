unit Result;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids;
type

  { TMResult }

  TMResult = class(TForm)
    SGFResult: TStringGrid;
  private

  public

  end;

var
  MResult: TMResult;

implementation

{$R *.lfm}

end.

