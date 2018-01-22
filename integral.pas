unit Integral;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;

type
  TIntegral = class
    constructor Create();
    destructor Destroy(); override;

    private
      LG, WL: array  of real;
      nv: integer;
      MParse: TParseMath;
    public
      function Func(x: real; fn: string): real;
      function Trapecio(a,b: real; fn: string; n: integer): real;
      function SimpsonI(a,b: real; fn: string; n: integer): real;
      function SimpsonII(a,b: real; fn: string; n: integer): real;
      function CuadraturaGauss(a,b: real; fn: string; n: integer): real;
  end;

implementation

constructor TIntegral.Create();
begin
  nv:= 5;
  SetLength(LG,nv); SetLength(WL,nv);
  LG[0]:= 0;                  WL[0]:= 0.568888888888889;
  LG[1]:= -0.538469310105683; WL[1]:= 0.478628670499366;
  LG[2]:= 0.538469310105683;  WL[2]:= 0.478628670499366;
  LG[3]:= -0.906179845938664; WL[3]:= 0.236926885056189;
  LG[4]:= 0.906179845938664;  WL[4]:= 0.236926885056189;
  MParse:= TParseMath.Create();
  MParse.AddVariable('x',0);
end;

destructor TIntegral.Destroy();
begin
end;

function TIntegral.Func(x: real; fn: string): real;
begin
  MParse.NewValue('x',x);
  MParse.Expression:= fn;
  Result:= MParse.Evaluate();
end;

function TIntegral.Trapecio(a,b: real; fn: string; n: integer): real;
var
  r,h: real;
begin
  h := (b-a)/n;
  r := (Func(a,fn)+Func(b,fn))/2;
  a := a+h;

  while(a<b) do begin
    r:= r+Func(a,fn);
    a:= a+h;
  end;
  Result:= h*r;
end;

function TIntegral.SimpsonI(a,b: real; fn: string; n: integer): real;
var
  s,h,r: real;
  nt,i: integer;
  xim: array of real;
begin
  h:= (b-a)/(2*n);
  r:= Func(a,fn) + Func(b,fn);
  nt:= (2*n)+1; s:=0;
  SetLength(xim,nt);
  for i:=0 to nt-1 do begin
    xim[i]:= Func(a,fn);
    a:= a+h;
  end;

  for i:=1 to n-1 do   s:= s+xim[2*i];
  r:= r+(2*s); s:= 0;
  for i:=0 to n-1 do   s:= s+xim[(2*i)+1];
  r:= r+(4*s);
  Result:= (r*h)/3;
end;

function TIntegral.SimpsonII(a,b: real; fn: string; n: integer): real;
var
  nt,i: integer;
  r,s,h: real;
  xim: array of real;
begin
  h:= (b-a)/(3*n);
  r:= 0; s:=0;
  nt:= (3*n)+1;
  SetLength(xim,nt);
  for i:=0 to nt-1 do begin
    xim[i]:= Func(a,fn);
    a:= a+h;
  end;

  for i:=1 to n do  r:= r+xim[3*(i-1)]+xim[3*i];
  for i:=1 to n do  s:= s+xim[(3*i)-2]+xim[(3*i)-1];
  r:= r+(3*s);
  Result:= (3*h*r)/8;
end;

function TIntegral.CuadraturaGauss(a,b: real; fn: string; n: integer): real;
var
  i: integer;
  r,tm: real;
begin
  n:= 5; tm:= b-a;
  r:=0;
  for i:=0 to n-1 do
    r:= r+(WL[i]*Func(((LG[i]*tm)+b+a)/2,fn));
  Result:= (tm*r)/2;
end;

end.

