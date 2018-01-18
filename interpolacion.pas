unit Interpolacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Func;

type
  TInterpolacion = class
    private
    public
      function Lagrange(B: TList): string;
      constructor Create();
      destructor Destroy(); override;
  end;

implementation

constructor TInterpolacion.Create();
begin
end;

destructor TInterpolacion.Destroy();
begin
end;

function TInterpolacion.Lagrange(B: TList): string;
var
  n,i,j: integer;
  rs: real;
  plg, lg: string;
begin
  n:= B.Count;

  for i:=0 to n-1 do begin
    if(TPoint(B.Items[i]).y <> 0) then begin
      lg := '('+FloatToStr(TPoint(B.Items[i]).y)+'*';
      rs:=1.0;
      for j:=0 to n-1 do begin
        if(i<>j) then begin
          if(TPoint(B.Items[j]).x = 0) then begin
            lg:= lg+'x*';
          end
          else begin
            lg := lg+'(x';
            if(TPoint(B.Items[j]).x <0) then
              lg:= lg +'+'
            else
              lg:= lg +'-';

            lg:= lg + FloatToStr(Abs(TPoint(B.Items[j]).x))+')*';
          end;
          rs:= rs*(TPoint(B.Items[i]).x-TPoint(B.Items[j]).x);
        end;
      end;
      SetLength(lg,Length(lg)-1);
      lg := lg + '/'+FloatToStr(rs)+')+';
      plg := plg + lg;
    end;
  end;
  SetLength(plg,Length(plg)-1);
  Result:= plg;
end;

end.

