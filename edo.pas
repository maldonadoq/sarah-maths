unit Edo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, Func, Dialogs;

type
  TEDO = class
    constructor Create();
    destructor Destroy(); override;

    private
      MParse: TParseMath;
      MR: TList;
    public
      function Func(x,y: real; fn: string): real;
      function EulerMejorado(xi,xf,xti,yti: real; n: integer; fn,fs: string): TBox;
      function RungeKutta4(xi,xf,xti,yti: real; n: integer; fn,fs: string): TBox;
      function CreateTBox(n: integer): TBox;
  end;

implementation

constructor TEDO.Create();
begin
  MParse:= TParseMath.Create();
  MParse.AddVariable('x',0);
  MParse.AddVariable('y',0);
  MR:= TList.Create;
end;

destructor TEDO.Destroy();
begin
  MR.Destroy;
end;

function TEDO.Func(x,y: real; fn: string): real;
begin
  MParse.NewValue('x',x);
  MParse.NewValue('y',y);
  MParse.Expression:= fn;
  Result:= MParse.Evaluate();
end;

function TEDO.CreateTBox(n: integer): TBox;
var
  m,i,j,k: integer;
begin
  m:= (MR.Count div n);
  Result:= TBox.Create(m+1,n+1);
  Result.M[0,0]:= 'n';         Result.M[0,1]:= 'X';
  Result.M[0,2]:= 'Y [Euler]'; Result.M[0,3]:= 'Solución Exacta';

  k:= 1; i:= 0;
  while(i<MR.Count-1) do begin
    Result.M[k,0]:= IntToStr(k-1);
    for j:=0 to 2 do
      Result.M[k,j+1]:= FloatToStr(Real(MR.Items[i+j]));
    i:= i+n;
    k:= k+1;
  end;
end;

function TEDO.EulerMejorado(xi,xf,xti,yti: real; n: integer; fn,fs: string): TBox;
var
  h,myti,myt,tmp: real;
  i: integer;
begin
  h:= (xf-xi)/n;
  if(xti = xi) then  h:= h
  else if(xti = xf) then  h:= 0-h
  else begin
    ShowMessage('Punto Inicial Mal');
    exit;
  end;

  MR.Clear;
  myt:= yti;

  MR.Add(Pointer(xti));
  MR.Add(Pointer(yti));
  MR.Add(Pointer(yti));

  for i:=1 to n do begin
    tmp:= myt+(h*Func(xti,myt,fn));
    myti:= myt+(h*((Func(xti,myt,fn)+Func(xti+h,tmp,fn))/2));

    MR.Add(Pointer(xti+h));
    MR.Add(Pointer(myti));
    if(fs <> '') then
      MR.Add(Pointer(Func(xti+h,myti,fs)))
    else
      MR.Add(Pointer(0));
    xti:= xti+h;
    myt:= myti;
  end;
  Result:= CreateTBox(3);
end;

function TEDO.RungeKutta4(xi,xf,xti,yti: real; n: integer; fn,fs: string): TBox;
var
  h,myti,k1,k2,k3,k4: real;
  i: integer;
begin
  h:= (xf-xi)/n;
  if(xti = xi) then  h:= h
  else if(xti = xf) then  h:= 0-h
  else begin
    ShowMessage('Punto Inicial Mal');
    exit;
  end;

  MR.Clear;
  MR.Add(Pointer(xti));
  MR.Add(Pointer(yti));
  MR.Add(Pointer(yti));
  for i:=1 to n do begin

    k1:= Func(xti,yti,fn);
    k2:= Func(xti+(h/2),yti+(k1*h/2),fn);
    k3:= func(xti+(h/2),yti+(k2*h/2),fn);
    k4:= func(xti+h,yti+(k3*h),fn);

    myti:= yti+(h*(k1 + (2*k2) + (2*k3) + k4)/6);

    MR.Add(Pointer(xti+h));
    MR.Add(Pointer(myti));
    if(fs <> '') then
      MR.Add(Pointer(Func(xti+h,myti,fs)))
    else
      MR.Add(Pointer(0));

    xti:= xti+h;
    yti:= myti;
  end;
  Result:= CreateTBox(3);
end;

end.

