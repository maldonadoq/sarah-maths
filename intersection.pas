unit Intersection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, Dialogs, Func;

type
  TMethIntersection = class
    private
      nv: integer;
    public
      MParse: TParseMath;
      constructor Create();
      destructor Destroy(); override;

      function Points(xmin,xmax: real; fn: string): TList;
      function Func(x: real; f: string): real;
      function MBisect(a,b,e: real; fn: string):  TBox;
      function MFalPos(a,b,e: real; fn: string):  TBox;
      function MNewton(a,e: real; fn,fp: string): TBox;
      function MSecant(a,e: real; fn: string):    TBox;
end;

implementation

constructor TMethIntersection.Create();
begin
  MParse:= TParseMath.create();
  MParse.AddVariable('x',0);
  nv:= 100;
end;

destructor TMethIntersection.Destroy();
begin
end;

function TMethIntersection.Points(xmin,xmax: real; fn: string): TList;
var
  step: real;
  i: integer;
begin
  step:= (xmax-xmin)/nv;
  Result:= TList.Create;
  for i:=0 to nv-1 do begin
    if((Func(xmin,fn)*Func(xmin+step,fn)) <= 0) then
      Result.Add(TMPoint.Create(xmin,xmin+step));
    xmin:= xmin+step;
  end;
end;

function TMethIntersection.Func(x: real; f: string): real;
begin
  MParse.NewValue('x',x);
  MParse.Expression:= f;
  Result:= MParse.Evaluate();
end;

function TMethIntersection.MBisect(a,b,e: real; fn: string): TBox;
var
  et,vt,v,s: real;
  MT: TList;
begin
  et:= e+1; v:= 0;
  MT:= TList.Create;
  while(e<et) do begin
    vt:= v;
    v:= (a+b)/2;
    et:= abs(vt-v);
    s:= Func(a,fn)*Func(v,fn);

    MT.Add(Pointer(a));  MT.Add(Pointer(b));
    MT.Add(Pointer(v));  MT.Add(Pointer(et));

    if(s<0) then b:= v
    else a:= v;
  end;
  Result:= TBox.Create(MT,4);
  MT.Clear;
end;


function TMethIntersection.MFalPos(a,b,e: real; fn: string): TBox;
var
  et,vt,v,s: real;
  MT: TList;
begin
  et:= e+1; v:= 0;
  MT:= TList.Create;
  while(e<et) do begin
    vt:= v;
    v:= b-((Func(b,fn)*(a-b))/(Func(a,fn)-Func(b,fn)));
    et:= abs(vt-v);
    s:= Func(a,fn)*Func(v,fn);

    MT.Add(Pointer(a));  MT.Add(Pointer(b));
    MT.Add(Pointer(v));  MT.Add(Pointer(et));

    if(s<0) then b:= v
    else a:= v;
  end;
  Result:= TBox.Create(MT,4);
  MT.Clear;
end;

function TMethIntersection.MNewton(a,e: real; fn,fp: string): TBox;
var
  v,vt,et: real;
  MT: TList;
begin
  v:= a; et:= e+1;
  MT:= TList.Create;
  while(e<et) do begin
    vt:= v;
    if(Func(v,fp) = 0.0) then
      v:= v-(Func(v,fn)/(Func(v,fp)+0.0001))
    else
      v:= v-(Func(v,fn)/Func(v,fp));
    et:= abs(vt-v);

    MT.Add(Pointer(v));  MT.Add(Pointer(et));
  end;
  Result:= TBox.Create(MT,2);
  MT.Clear;
end;

function TMethIntersection.MSecant(a,e: real; fn: string): TBox;
var
  v,vt,et,h: real;
  MT: TList;
begin
  h:= e/10; v:= a; et:= e+1;
  MT:= TList.Create;
  while(e<et) do begin
    vt:= v;
    if((Func(v+h,fn)-Func(v-h,fn)) = 0.0) then
      v:= v-((2*h*Func(v,fn))/(Func(v+h,fn)-Func(v-h,fn)+0.0001))
    else
      v:= v-((2*h*Func(v,fn))/(Func(v+h,fn)-Func(v-h,fn)));
    et:= abs(vt-v);

    MT.Add(Pointer(v));  MT.Add(Pointer(et));
  end;
  Result:= TBox.Create(MT,2);
  MT.Clear;
end;

end.
