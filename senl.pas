unit Senl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, Func, Math, Matrices, Dialogs;

type
  TSENL = class
    private
      MList: TList;
    public
      ECNL: array of string;
      MP: array of real;
      VX: array of string;
      MParse: TParseMath;
      n: integer;
      MATJ: TMatriz;
      constructor Create();
      destructor Destroy(); override;

      procedure SetVariable(nt: integer; _ECNL: VectString; _MP: VectReal);
      function SF(ec: string; x: TMatriz): real;
      function SFF(x: TMatriz): TMatriz;
      function SDP(f,v: integer; x: TMatriz; h: real): real;
      function Jacob(a: TMatriz; h: real): TMatriz;
      function FX(a: TMatriz): TMatriz;
      function NewtonGeneralizado(e: real): TBox;
      function Distance(a,b: TMatriz): real;
      function CreateBox(nt: integer): TBox;
end;

implementation

function MtoV(a: TMatriz): VectReal;
var
  i: integer;
begin
  SetLength(Result,a.x);
  for i:=0 to a.x-1 do
    Result[i] := a.m[i,0];
end;

function VtoM(a: VectReal): TMatriz;
var
  i: integer;
begin
  Result := TMatriz.Create(Length(a),1);
  for i:=0 to Length(a)-1 do
    Result.m[i,0] := a[i];
end;

function TSENL.SF(ec: string; x: TMatriz): real;
var i: integer;
begin
  for i:=0 to x.x-1 do
    MParse.NewValue(VX[i],x.m[i,0]);
  MParse.Expression:= ec;
  Result := MParse.Evaluate();
end;

function TSENL.SFF(x: TMatriz): TMatriz;
var i,nt: integer;
begin
  nt:= x.x;
  Result := TMatriz.Create(nt,1);
  for i:=0 to nt-1 do begin
    Result.m[i,0] := Self.SF(ECNL[i],x);
  end;
end;

function TSENL.SDP(f,v: integer; x: TMatriz; h: real): real;
var
  i: integer;
  xi, xj: TMatriz;
begin
  h:= h/10;
  xi:= TMatriz.Create(x.x,1);  xj:= TMatriz.Create(x.x,1);
  for i:=0 to x.x-1 do begin
     xi.m[i,0] := x.m[i,0];
     xj.m[i,0] := x.m[i,0];
  end;
  xi.m[v,0]:= xi.m[v,0]+h;  xj.m[v,0]:= xj.m[v,0]-h;
  Result:= (Self.SF(ECNL[f],xi)-Self.SF(ECNL[f],xj))/(2*h);
end;

procedure TSENL.SetVariable(nt: integer; _ECNL: VectString; _MP: VectReal);
var
  i: integer;
begin
  MParse:= TParseMath.Create();
  ECNL:= _ECNL;
  MP:= _MP;
  for i:= 0 to nt-1 do begin
    MParse.AddVariable(VX[i],0.0);
  end;
end;


constructor TSENL.Create();
begin
  n:= 12;
  SetLength(VX,n);
  VX[0]:= 'a';  VX[1]:= 'b';   VX[2]:= 'c';
  VX[3]:= 'd';  VX[4]:= 'e';   VX[5]:= 'f';
  VX[6]:= 'g';  VX[7]:= 'h';   VX[8]:= 'i';
  VX[9]:= 'j';  VX[10]:= 'k';  VX[11]:= 'l';
  MList:= TList.Create();
end;

destructor TSENL.Destroy();
begin
end;

function TSENL.Jacob(a: TMatriz; h: real): TMatriz;
var
  i,j,s: integer;
begin
  s := a.x;
  Result := TMatriz.Create(s,s);
  for i:=0 to s-1 do
    for j:=0 to s-1 do
      Result.m[i,j] := SDP(i,j,a,h);
end;

function TSENL.FX(a: TMatriz): TMatriz;
var
  i: integer;
begin
  Result := TMatriz.Create(a.x,1);
  for i:=0 to a.x-1 do
    Result.m[i,0] := SF(ECNL[i],a);
end;

function TSENL.Distance(a,b: TMatriz): real;
var
  i: integer;
begin
  Result := 0;
  for i:=0 to a.x-1 do begin
     Result := Result+power(a.m[i,0]-b.m[i,0],2);
  end;
  Result := Sqrt(Result);
end;

function TSENL.CreateBox(nt: integer): TBox;
var
  ntt,i,j,k: integer;
begin
  ntt:= (MList.Count div nt);
  Result:= TBox.Create(ntt+1,nt+1);
  Result.M[0,0]:= 'n';  Result.M[0,nt]:= 'e';
  for i:=0 to nt-2 do
    Result.M[0,i+1]:= VX[i];

  j:= 1; i:=0;
  while(i<MList.Count) do begin
    Result.M[j,0]:= IntToStr(j-1);
    for k:=0 to nt-1 do
      Result.M[j,k+1]:= FloatToStr(Real(MList.Items[i+k]));

    i:= i+nt;
    j:= j+1;
  end;
end;

function TSENL.NewtonGeneralizado(e: real): TBox;
var
  t: boolean;
  Ea: real;
  VM, PR, FT, TMP: TMatriz;
  det: TRD;
  i,j: integer;
begin
  Ea:= e+1; j := 1;
  t:= True;

  MList.Clear;
  VM:= VtoM(MP);
  while(e<Ea) and (t=True) do begin
    TMP:= VM;
    MATJ:= Self.Jacob(VM,0.0001);
    det:= MATJ.Determinante();

    if(det.Value <> 0) then begin
      PR:= MATJ.Inversa(det.Value);
      FT:= SFF(VM);
      VM:= VM-(PR*FT);

     for i:=1 to VM.x do
       MList.Add(Pointer(VM.M[i-1][0]));

     Ea:= Self.Distance(TMP,VM);
     MList.Add(Pointer(Ea));
     j:= j+1;
    end
    else begin
      t:= False;
      ShowMessage('Determinante en la iteración '+IntToStr(j-1)+' es 0');
      exit;
    end;
  end;

  Result:= CreateBox(Length(MP)+1);
end;

end.
