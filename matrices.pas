unit Matrices;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Func, Math;

type
  TMatriz = class
    private
    public
      x,y: integer;
      M: array of array of real;
      constructor Create(_x,_y: integer);
      destructor Destroy(); override;
      function GetX(): integer;
      function GetY(): integer;
      function Transpuesta(): TMatriz;
      function Determinante(): TRD;
      function Cofactores(a: TMatriz; r,c: integer): real;
      function Adjunta(): TMatriz;
      function Inversa(a: real): TMatriz;
      function Escalar(a: real): TMatriz;
      function MPower(a: integer): TMatriz;

      procedure Print();
  end;

Operator *(a,b: TMatriz): TMatriz;
Operator +(a,b: TMatriz): TMatriz;
Operator -(a,b: TMatriz): TMatriz;
Operator /(a,b: TMatriz): TMatriz;

implementation

constructor TMatriz.Create(_x,_y: integer);
var
  i,j: integer;
begin
  Self.x:= _x;
  Self.y:= _y;
  SetLength(Self.M,Self.x,Self.y);
  for i:=0 to x-1 do
    for j:=0 to y-1 do
      Self.M[i,j]:= 0;
end;

destructor TMatriz.Destroy();
begin
end;

function TMatriz.GetX(): integer;
begin
  Result:= Self.x;
end;

function TMatriz.GetY(): integer;
begin
  Result:= Self.y;
end;

function TMatriz.Transpuesta(): TMatriz;
var
  i,j: integer;
begin
  Result:= TMatriz.Create(Self.y,Self.x);
  for i:=0 to Self.x-1 do
    for j:=0 to Self.y-1 do
      Result.M[j,i]:= Self.M[i,j];
end;

function TMatriz.Cofactores(a:TMatriz; r,c: integer): real;
var
  i,j,i1,j1: integer;
  MT: TMatriz;
begin
  MT:= TMatriz.Create(a.x-1,a.x-1);
  i1:=0; j1:=0;
  for i:=0 to a.x-1 do begin
   for j:=0 to a.x-1 do begin
     if (i<>r) and (j<>c) then begin
         MT.M[i1,j1]:= a.M[i,j];
         j1:= j1+1;
         if(j1>=(a.x-1)) then begin
             i1:=i1+1;
             j1:=0;
         end;
     end;
   end;
  end;
  Result:= (Power(-1,r+c))*(MT.Determinante().Value);
  MT.Destroy();
end;

function TMatriz.Determinante(): TRD;
var i: integer;
begin
  Result.State:= True;
  if Self.x <> Self.y then
    Result.State:= False
  else if Self.x = 1 then
    Result.Value:= Self.M[0,0]
  else if Self.x = 2 then
    Result.Value:= (Self.M[0,0]*Self.M[1,1])-(Self.M[0,1]*Self.M[1,0])
  else begin
    for i:=0 to Self.x-1 do
      Result.Value:= Result.Value+(Self.M[0,i]*Self.Cofactores(Self,0,i));
  end;
end;

function TMatriz.Inversa(a: real): TMatriz;
var
  i,j: integer;
begin
  Result:= TMatriz.Create(Self.x,Self.y);
  for i:=0 to Result.x-1 do
    for j:=0 to Result.y-1 do
      Result.M[i,j]:= Self.Cofactores(Self,i,j)/a;

  Result:= Result.Transpuesta();
end;

function TMatriz.Adjunta(): TMatriz;
var
  i,j: integer;
begin
  Result:= TMatriz.Create(Self.x,Self.y);
  for i:=0 to Result.x-1 do
    for j:=0 to Result.y-1 do
      Result.M[i,j]:= Self.Cofactores(Self,i,j);
end;

function TMatriz.Escalar(a: real): TMatriz;
var i,j: integer;
begin
  Result:= TMatriz.Create(Self.x,Self.y);
  for i:=0 to Result.x-1 do
    for j:=0 to Result.y-1 do
      Result.M[i,j]:= Self.M[i,j]*a;
end;

function TMatriz.MPower(a: integer): TMatriz;
var
  i: integer;
begin
  Result:= Self;
  for i:=0 to a-2 do
    Result:= Result*Self;
end;

procedure TMatriz.Print();
var
  i,j: integer;
begin
  for i:=0 to x-1 do begin
    for j:=0 to y-1 do
      Write(FloatToStr(M[i,j])+' ');
    Write(LineEnding);
  end;
end;

Operator +(a,b: TMatriz): TMatriz;
var i,j: integer;
begin
  if ((a.x = b.x) and (a.y = b.y)) then begin
    Result:= TMatriz.Create(a.x,a.y);
    for i:=0 to a.x-1 do
      for j:=0 to a.y-1 do
        Result.M[i,j]:= a.M[i,j] + b.M[i,j]
  end
  else
      Result:= TMatriz.Create(0,0);
end;

Operator -(a,b: TMatriz): TMatriz;
var i,j: integer;
begin
  if ((a.x = b.x) and (a.y = b.y)) then begin
    Result:= TMatriz.Create(a.x,a.y);
    for i:=0 to a.x-1 do
      for j:=0 to a.y-1 do
        Result.M[i,j]:= a.M[i,j] - b.M[i,j]
  end
  else
      Result:= TMatriz.Create(0,0);
end;

Operator *(a,b: TMatriz): TMatriz;
var i,j,k: integer;
begin
  if (a.y = b.x) then
  begin
    Result:= TMatriz.Create(a.x,b.y);
    for i:=0 to Result.x-1 do
      for j:=0 to Result.y-1 do
        for k:=0 to a.y-1 do
            Result.M[i,j]:= Result.M[i,j]+(a.M[i,k]*b.M[k,j]);
  end
  else begin
      WriteLn('Order of Matrix are Different');
      ShowMessage('Order of Matrix are Different');
      Result:= TMatriz.Create(0,0);
  end;
end;

Operator /(a,b: TMatriz): TMatriz;
var
  det: TRD;
begin
  det:= b.Determinante();
  if(det.State and (det.Value<>0)) then
    Result:= a*b.Inversa(det.Value);
end;

end.

