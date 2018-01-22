unit Func;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  VectString = array of string;

type
  VectReal = array of real;

type
  TBox = class
    public
      x,y: integer;
      M: array of array of String;
      procedure Print;
      constructor Create(a: TList; size: integer);
      constructor Create(a,b: integer);
      destructor Destroy(); override;
  end;

type
  TMPoint = class
    public
      x,y: real;
      constructor Create(_x,_y: real);
      destructor Destroy(); override;
  end;

type
  TRD = record
    State: Boolean;
    Value: Real;
  end;

type
  TLP = record
    MList: TList;
    PList: TList;
  end;

function XIntervalo(MP: TList): TMPoint;
function XIntervaloText(Tx: string): TMPoint;
function PointInitial(Tx: string): TMPoint;

implementation

constructor TMPoint.Create(_x, _y: real);
begin
  Self.x:= _x;
  Self.y:= _y;
end;

destructor TMPoint.Destroy();
begin
end;

function XIntervaloText(Tx: string): TMPoint;
var
  PosCorcheteIni, PosCorcheteFin, PosSeparador: Integer;
  PosicionValidad: Boolean;
  i: Integer;
  x: Double;
  xmin,xmax: string;
const
  CorcheteIni = '[';
  CorcheteFin = ']';
  Separador = ';';
begin

  PosCorcheteIni:= Pos(CorcheteIni, Tx);
  PosCorcheteFin:= pos(CorcheteFin, Tx);
  PosSeparador:= Pos(Separador, Tx);

  PosicionValidad:= (PosCorcheteIni > 0);
  PosicionValidad:= PosicionValidad and (PosSeparador > 2);
  PosicionValidad:= PosicionValidad and (PosCorcheteFin > 3);

  if not PosicionValidad then begin
    ShowMessage( 'Error en el intervalo');
    exit;
  end;

  xmin:= Copy(Tx,PosCorcheteIni+1, PosSeparador-2);

  xmin:= Trim(xmin);
  xmax:= Copy(Tx, PosSeparador+1, Length(Tx)-PosSeparador-1);

  xmax:= Trim(xmax);
  Result:= TMPoint.Create(StrToFloat(xmin),StrToFloat(xmax));
end;

function PointInitial(Tx: string): TMPoint;
var
  PosCorcheteIni, PosCorcheteFin, PosSeparador: Integer;
  PosicionValidad: Boolean;
  i: Integer;
  x: Double;
  xmin,xmax: string;
const
  CorcheteIni = '(';
  CorcheteFin = ')';
  Separador = ',';
begin

  PosCorcheteIni:= Pos(CorcheteIni, Tx);
  PosCorcheteFin:= pos(CorcheteFin, Tx);
  PosSeparador:= Pos(Separador, Tx);

  PosicionValidad:= (PosCorcheteIni > 0);
  PosicionValidad:= PosicionValidad and (PosSeparador > 2);
  PosicionValidad:= PosicionValidad and (PosCorcheteFin > 3);

  if not PosicionValidad then begin
    ShowMessage( 'Error en el Punto');
    exit;
  end;

  xmin:= Copy(Tx,PosCorcheteIni+1, PosSeparador-2);

  xmin:= Trim(xmin);
  xmax:= Copy(Tx, PosSeparador+1, Length(Tx)-PosSeparador-1);

  xmax:= Trim(xmax);
  Result:= TMPoint.Create(StrToFloat(xmin),StrToFloat(xmax));
end;

function XIntervalo(MP: TList): TMPoint;
var
  i: integer;
  xmin,xmax,xtmp: real;
begin
  xmin:= TMPoint(MP.Items[0]).x;
  xmax:= TMPoint(MP.Items[0]).x;
  for i:=1 to MP.Count-1 do begin
    xtmp:= TMPoint(MP.Items[i]).x;
    if(xtmp < xmin) then xmin:= xtmp;
    if(xtmp > xmax) then xmax:= xtmp;
  end;
  Result:= TMPoint.Create(xmin,xmax);
end;

constructor TBox.Create(a: TList; size: integer);
var
  r,i,j: integer;
begin
  r:= (a.Count div size);
  i:= 0;  j:=1;
  y:= size+1;
  x:= r+1;

  SetLength(M,x,y);
  if(size=2) then begin
    M[0,0]:= 'n'; M[0,1]:= 'xn'; M[0,2]:= 'e';
    while(i<a.Count) do begin
      M[j,0]:= IntToStr(j-1);
      M[j,1]:= FloatToStr(Real(a.Items[i]));
      M[j,2]:= FloatToStr(Real(a.Items[i+1]));
      i:= i+size;
      j:= j+1;
    end;
  end
  else if(size=4) then begin
    M[0,0]:= 'n'; M[0,1]:= 'a'; M[0,2]:= 'b'; M[0,3]:= 'xn'; M[0,4]:= 'e';
    while(i<a.Count) do begin
      M[j,0]:= IntToStr(j-1);
      M[j,1]:= FloatToStr(Real(a.Items[i]));
      M[j,2]:= FloatToStr(Real(a.Items[i+1]));
      M[j,3]:= FloatToStr(Real(a.Items[i+2]));
      M[j,4]:= FloatToStr(Real(a.Items[i+3]));

      i:= i+size;
      j:= j+1;
    end;
  end;
end;

constructor TBox.Create(a,b: integer);
begin
  x:= a;
  y:= b;
  SetLength(M,x,y);
end;

destructor TBox.Destroy();
begin
end;

procedure TBox.Print;
var
  i,j: integer;
begin
  for i:=0 to x-1 do begin
    for j:=0 to y-1 do
      Write(M[i,j]+' ');
    WriteLn()
  end;
end;

end.

