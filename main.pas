unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLType, ExtCtrls, ComCtrls, Grids, ParseMath, TASeries,
  TAFuncSeries, TATools, Intersection, Func, Matrices, Result, Senl,
  Interpolacion, Types, Math, TAChartUtils, TACustomSeries, uCmdBox,
  Edo, Integral;

type

  { TForm1 }

  TForm1 = class(TForm)
    BInterpolar: TButton;
    ButInteg: TButton;
    BGrapInt: TButton;
    EdoN: TEdit;
    GraficaIII: TLineSeries;
    EdoOk: TButton;
    Chart2: TChart;
    Chart3: TChart;
    ColorEdo: TColorButton;
    EdoMetodo: TComboBox;
    EdoEcuac: TEdit;
    EdoSol: TEdit;
    EdoInterv: TEdit;
    EdoInitial: TEdit;
    FEdo: TTabSheet;
    EDPanel: TPanel;
    TextIter: TEdit;
    GraficaII: TLineSeries;
    ClearFunct: TButton;
    CmbInt: TComboBox;
    ColorInteg: TColorButton;
    TextIntervGrap: TEdit;
    ResuInteg: TEdit;
    TextEcuac: TEdit;
    TextIntervalo: TEdit;
    Panel3: TPanel;
    ResizeFunc: TButton;
    Chart1LineSeries1: TLineSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    InterX: TEdit;
    InterY: TEdit;
    InterpSol: TEdit;
    ISGNE: TButton;
    ILagrange: TButton;
    INewton: TButton;
    DatoSenl: TButton;
    INE: TEdit;
    IData: TGroupBox;
    Label5: TLabel;
    OkSenl: TButton;
    DatosOpe: TButton;
    BoxPanel: TGroupBox;
    EcuationSenl: TEdit;
    HSenl: TEdit;
    GroupBox1: TGroupBox;
    MData: TEdit;
    Label4: TLabel;
    OKA: TButton;
    OKB: TButton;
    Panel2: TPanel;
    IPM: TPanel;
    IEVAL: TPanel;
    SGA: TStringGrid;
    SGB: TStringGrid;
    FSENL: TTabSheet;
    PointInitialSenl: TStringGrid;
    SGEcuationSenl: TStringGrid;
    FInter: TTabSheet;
    SGPI: TStringGrid;
    StatusBar1: TStatusBar;
    FIntegral: TTabSheet;
    XA: TEdit;
    YA: TEdit;
    XB: TEdit;
    YB: TEdit;
    MenuA: TPanel;
    MenuB: TPanel;
    SolOper: TButton;
    OperMatriz: TComboBox;
    DB: TButton;
    Derivada: TEdit;
    BoxTM: TGroupBox;
    BMA: TGroupBox;
    BMB: TGroupBox;
    MenuPanel: TPanel;
    Sol: TEdit;
    ErrorH: TEdit;
    PanelLeft: TGroupBox;
    Inter: TButton;
    Chart1: TChart;
    colorbtnFunction: TColorButton;
    comb: TComboBox;
    ediMin: TEdit;
    ediMax: TEdit;
    ediStep: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Solution: TPanel;
    Sarah: TPageControl;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    ENL: TTabSheet;
    Matrix: TTabSheet;
    Datos: TTabSheet;
    SGPoints: TStringGrid;
    TableData: TStringGrid;
    TrackBar1: TTrackBar;

    procedure BGrapIntClick(Sender: TObject);
    procedure BInterpolarClick(Sender: TObject);
    procedure ButIntegClick(Sender: TObject);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ClearFunctClick(Sender: TObject);
    procedure EdoOkClick(Sender: TObject);
    procedure ResizeFuncClick(Sender: TObject);
    procedure DatoSenlClick(Sender: TObject);
    procedure DBClick(Sender: TObject);
    procedure ILagrangeClick(Sender: TObject);
    procedure InterClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FunctionSeriesCalculate(const AX: Double; out AY: Double);
    procedure FormShow(Sender: TObject);
    procedure FunctionsEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ISGNEClick(Sender: TObject);
    procedure OKAClick(Sender: TObject);
    procedure OKBClick(Sender: TObject);
    procedure OkSenlClick(Sender: TObject);
    procedure SolOperClick(Sender: TObject);
    procedure PutResult(a: TMatriz);
    procedure MatrizRandom();
    procedure PointSol(xn: integer);
    procedure SGResultado(TB: TBox);

    function CreateA(): TMatriz;
    function CreateB(): TMatriz;
  private
    FunctionList, EditList: TList;
    ActiveFunction: Integer;
    min, max: Real;
    Parse: TparseMath;
    MInter: TMethIntersection;
    GList: TList;
    GListII: TList;
    MSenl: TSENL;
    PointInter: TMPoint;
    MInterpolacion: TInterpolacion;
    MIntegracion: TIntegral;
    MEDO: TEDO;
    FuncSelected: Boolean;
    function1,function2: string;
    nv: integer;

    function f(x: Real): Real;
    function Func(x: real; s: string): real;
    function Points(xmin,xmax: real; fn: string): TList;

    procedure CreateNewFunction;
    procedure Graphic2D;
    procedure ResizeGraphic2D;
    procedure Clear;
    procedure PointXY();
    procedure PointInterXY();
    procedure EdoGrap();

  public
  end;

var
  Form1: TForm1;

implementation

const
  FunctionEditName = 'FunctionEdit';
  FunctionSeriesName = 'FunctionLines';

procedure TForm1.FormCreate(Sender: TObject);
begin
  FunctionList:= TList.Create;
  EditList:= TList.Create;
  min:= -10.0;
  max:= 10.0;
  Parse:= TParseMath.create();
  Parse.AddVariable('x', min);
  MInter:= TMethIntersection.Create();
  GList:= TList.Create;
  GListII:= TList.Create;
  MSenl:= TSENL.Create();
  MIntegracion:= TIntegral.Create();
  MInterpolacion:= TInterpolacion.Create();
  MEDO:= TEDO.Create();
  FuncSelected:= True;
  nv:= 20;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
  MInter.Destroy;
  GList.Destroy;
  GListII.Destroy;
  MSenl.Destroy;
  MInterpolacion.Destroy;
  MEDO.Destroy();
  Clear;
  FunctionList.Destroy;
  EditList.Destroy;
end;

function TForm1.f( x: Real ): Real;
begin
  Parse.Expression:= TEdit( EditList[ ActiveFunction ]).Text;
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();
end;

procedure TForm1.FunctionSeriesCalculate(const AX: Double; out AY: Double);
begin
   // AY:= f( AX )
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  CreateNewFunction;
end;

procedure TForm1.FunctionsEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not (key = VK_RETURN) then
    exit;

  with TEdit(Sender) do begin
    ActiveFunction:= Tag;
    Graphic2D;
    if tag = EditList.Count - 1 then
      CreateNewFunction;
  end;
end;

procedure TForm1.Graphic2D;
var x, h: Real;

begin
  h:= StrToFloat( ediStep.Text );
  min:= StrToFloat( ediMin.Text );
  max:= StrToFloat( ediMax.Text );

  with TLineSeries(FunctionList[ActiveFunction]) do begin
    LinePen.Color:= colorbtnFunction.ButtonColor;
    LinePen.Width:= TrackBar1.Position;
  end;

  x:= min;
  TLineSeries( FunctionList[ ActiveFunction ] ).Clear;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do
  repeat
    AddXY(x,f(x));
    x:= x+h
  until ( x>= max );
end;

procedure TForm1.BGrapIntClick(Sender: TObject);
var
  PInt: TMPoint;
  xmi,xma,x,h: real;
  funct: string;
begin
  PInt:= XIntervaloText(TextIntervGrap.Text);
  funct:= TextEcuac.Text;
  xmi:= PInt.x; xma:= PInt.y;

  GraficaII.LinePen.Color:= ColorInteg.ButtonColor;
  x:= xmi; h:=0.01;

  GraficaII.Clear;
  with GraficaII do
    repeat
      AddXY(x,Func(x,funct));
      x:= x+h
    until(x>= xma);

  PInt.Destroy();
end;

procedure TForm1.ResizeGraphic2D;
var
  x, h: Real;
begin
  h:= StrToFloat( ediStep.Text );
  min:= StrToFloat( ediMin.Text );
  max:= StrToFloat( ediMax.Text );

  x:= min;
  TLineSeries( FunctionList[ ActiveFunction ] ).Clear;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do
  repeat
      AddXY(x,f(x));
      x:= x+h
  until ( x>= max );
end;

procedure TForm1.CreateNewFunction;
begin
  EditList.Add( TEdit.Create(ScrollBox1) );
  //We OKA Edits with functions
  with Tedit( EditList.Items[ EditList.Count - 1 ] ) do begin
    Parent:= ScrollBox1;
    Align:= alTop;
    name:= FunctionEditName + IntToStr( EditList.Count );
    OnKeyUp:= @FunctionsEditKeyUp;
    Font.Size:= 10;
    Text:= EmptyStr;
    Tag:= EditList.Count-1;
    SetFocus;
  end;
  //We OKA serial functions
  FunctionList.Add( TLineSeries.Create( Chart1 ) );
  with TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) do begin
    Name:= FunctionSeriesName + IntToStr( FunctionList.Count );
    Tag:= EditList.Count - 1; // Edit Asossiated
  end;
  Chart1.AddSeries( TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) );
end;

procedure TForm1.Clear;
var
  i: integer;
begin
  for i:=0 to FunctionList.Count-1 do begin
    TEdit(EditList.Items[i]).Destroy;
    TLineSeries(FunctionList.Items[i]).Destroy;
  end;

  EditList.Clear;
  FunctionList.Clear;
  Chart1.ClearSeries;
end;

procedure TForm1.ClearFunctClick(Sender: TObject);
begin
  Clear;
  CreateNewFunction;
end;

procedure TForm1.PointXY();
var
  i: integer;
begin
  Chart1LineSeries1.Clear;
  Chart1LineSeries1.Marks.Style:= smsValue;
  for i:=1 to SGPoints.RowCount-1 do begin
    Chart1LineSeries1.AddXY(StrToFloat(SGPoints.Cells[0,i]),StrToFloat(SGPoints.Cells[1,i]));
    Chart1LineSeries1.AddXY(NaN,NaN);
  end;
end;

procedure TForm1.PointInterXY();
var
  i: integer;
begin
  Chart1LineSeries1.Clear;
  for i:=1 to SGPI.RowCount-1 do begin
    Chart1LineSeries1.AddXY(StrToFloat(SGPI.Cells[0,i]),StrToFloat(SGPI.Cells[1,i]));
    Chart1LineSeries1.AddXY(NaN,NaN);
  end;
end;

procedure TForm1.PointSol(xn: integer);
var
  i,j: integer;
  xt: string;
begin
  j:= GList.Count+1;
  SGPoints.RowCount:= j+GlistII.Count;
  SGPoints.Cells[0,0]:= 'x'; SGPoints.Cells[1,0]:= 'y';
  for i:=0 to GList.Count-1 do begin
    xt:= TBox(GList.Items[i]).M[TBox(GList.Items[i]).x-1,xn];
    SGPoints.Cells[0,i+1]:= xt;
    SGPoints.Cells[1,i+1]:= FloatToStr(Func(StrToFloat(xt),function1));
  end;

  for i:=0 to GListII.Count-1 do begin
    xt:= FloatToStr(Real(GListII.Items[i]));
    SGPoints.Cells[0,j+i]:= xt;
    SGPoints.Cells[1,j+i]:= FloatToStr(Func(StrToFloat(xt),function1));
    GList.Add(TBox.Create(0,0));
  end;
  PointXY();
end;

function TForm1.Points(xmin,xmax: real; fn: string): TList;
var
  xmint,a,b,step: real;
  i: integer;
  t: boolean;
begin
  step:= (xmax-xmin)/nv;
  Result:= TList.Create;
  GListII.Clear;
  t:= False;
  for i:=0 to nv-1 do begin
    xmint:= xmin;
    if(t) then begin
      xmint:= xmint+0.001;
      t:= False;
    end;

    a:= Func(xmint,fn);
    b:= Func(xmin+step,fn);
    if IsNumber(a) and IsNumber(b) and ((a*b)<0) then begin
      Result.Add(TMPoint.Create(xmint,xmin+step));
      WriteLn('('+FloatToStr(xmint)+','+FloatToStr(a)+') ('+FloatToStr(xmin+step)+','+FloatToStr(b)+')');
    end
    else if a=0 then
      GListII.Add(Pointer(xmint))
    else if b=0 then begin
      GListII.Add(Pointer(xmin+step));
      t:= True;
    end;

    xmin:= xmin+step;
  end;
end;

procedure TForm1.InterClick(Sender: TObject);
var
  PList: TList;
  sl,slp: string;
  i: integer;
  xtmp,e: real;
begin
  if((function1='') or (function2='')) then begin
    ShowMessage('Elige dos Funciones!!!!');
    Exit;
  end;
  sl:= '('+function1+')-('+function2+')';
  WriteLn(sl);
  slp:= Derivada.Text;
  GList.Clear;
  PList:= TList.Create;
  PList:= Points(min,max,sl);
  TableData.Clear;
  SGPoints.Clear;
  e:= StrToFloat(ErrorH.Text);

  if(PList.Count<>0) then begin
    if(comb.ItemIndex = 0) then begin
      for i:=0 to PList.Count-1 do begin
        xtmp:= MInter.MBisIni(TMPoint(PList.Items[i]).x,TMPoint(PList.Items[i]).y,0.01,sl);
        GList.Add(MInter.MSecant(xtmp,e,sl));
      end;
      PointSol(1);
    end
    else if(comb.ItemIndex = 1) then begin
      for i:=0 to PList.Count-1 do
        GList.Add(MInter.MBisect(TMPoint(PList.Items[i]).x,TMPoint(PList.Items[i]).y,e,sl));
      PointSol(3);
    end
    else if(comb.ItemIndex = 2) then begin
      for i:=0 to PList.Count-1 do
        GList.Add(MInter.MFalPos(TMPoint(PList.Items[i]).x,TMPoint(PList.Items[i]).y,e,sl));
      PointSol(3);
    end
    else if(comb.ItemIndex = 3) then begin
      for i:=0 to PList.Count-1 do
        GList.Add(MInter.MNewton(TMPoint(PList.Items[i]).x,e,sl,slp));
      PointSol(1);
    end
    else if(comb.ItemIndex = 4) then begin
      for i:=0 to PList.Count-1 do
        GList.Add(MInter.MSecant(TMPoint(PList.Items[i]).x,e,sl));
      PointSol(1);
    end;
  end
  else if GListII.Count<>0 then
     PointSol(1)
  else
    ShowMessage('No hay Intersección!!!!!');
end;

procedure TForm1.DBClick(Sender: TObject);
var
  BT: TBox;
  i,j: integer;
begin
  BT:= TBox(GList.Items[StrToInt(Sol.Text)-1]);
  TableData.Clear;
  if(BT.x<>0) then begin
    TableData.RowCount:= BT.x;
    TableData.ColCount:= BT.y;
    for i:=0 to BT.x-1 do begin
      for j:=0 to BT.y-1 do
        TableData.Cells[j,i]:= BT.M[i,j];
    end
  end
  else begin
    TableData.RowCount:= 1;
    TableData.ColCount:= 1;
    TableData.Cells[0,0]:= 'Solución exacta!!!';
  end;
end;

procedure TForm1.OKAClick(Sender: TObject);
begin
  SGA.Clear;
  SGA.RowCount:= StrToInt(XA.Text);
  SGA.ColCount:= StrToInt(YA.Text);
end;

procedure TForm1.OKBClick(Sender: TObject);
begin
  SGB.Clear;
  SGB.RowCount:= StrToInt(XB.Text);
  SGB.ColCount:= StrToInt(YB.Text);
end;

function TForm1.CreateA(): TMatriz;
var
  i,j: integer;
begin
  Result:= TMatriz.Create(SGA.RowCount,SGA.ColCount);
  for i:=0 to SGA.RowCount-1 do
    for j:=0 to SGA.ColCount-1 do
      Result.M[i,j]:= StrToFloat(SGA.Cells[j,i]);
end;

function TForm1.CreateB(): TMatriz;
var
  i,j: integer;
begin
  Result:= TMatriz.Create(SGB.RowCount,SGB.ColCount);
  for i:=0 to SGB.RowCount-1 do
    for j:=0 to SGB.ColCount-1 do
      Result.M[i,j]:= StrToFloat(SGB.Cells[j,i]);
end;

procedure TForm1.PutResult(a: TMatriz);
var
  i,j: integer;
begin
  MResult.SGFResult.RowCount:= a.GetX;
  MResult.SGFResult.ColCount:= a.GetY;
  for i:=0 to a.GetY-1 do
    for j:=0 to a.GetX-1 do
      MResult.SGFResult.Cells[i,j]:= FloatToStr(a.M[j,i]);
end;

procedure TForm1.MatrizRandom();
var
  i,j,ra1,ca1,rb1,cb1: integer;
begin
  ra1:= SGA.RowCount; ca1:= SGA.ColCount;
  for i:=0 to ra1-1 do
   for j:=0 to ca1-1 do
     SGA.Cells[j,i]:= IntToStr(random(10));

  rb1:= SGB.RowCount; cb1:= SGB.ColCount;
  for i:=0 to rb1-1 do
   for j:=0 to cb1-1  do
     SGB.Cells[j,i]:= IntToStr(random(10));
end;

procedure TForm1.SolOperClick(Sender: TObject);
var
  A,B: TMatriz;
  det: TRD;
begin
  if(OperMatriz.ItemIndex=9) then
    MatrizRandom()
  else begin
    A:= CreateA;  B:= CreateB;
    MResult.Show;
    if(OperMatriz.ItemIndex=0) then
      PutResult(A+B)
    else if(OperMatriz.ItemIndex=1) then
      PutResult(A-B)
    else if(OperMatriz.ItemIndex=2) then
      PutResult(A*B)
    else if(OperMatriz.ItemIndex=3) then
      PutResult(A/B)
    else if(OperMatriz.ItemIndex=4) then begin
      det:= A.Determinante();
      if(det.State and (det.Value<>0)) then
        PutResult(A.Inversa(det.Value))
      else
        ShowMessage('No Tiene Inversa');
    end
    else if(OperMatriz.ItemIndex=5) then begin
      det:= B.Determinante();
      if(det.State and (det.Value<>0)) then
        PutResult(B.Inversa(det.Value))
      else
        ShowMessage('No Tiene Inversa');
    end
    else if(OperMatriz.ItemIndex=6) then
      PutResult(A.Escalar(StrToFloat(MData.Text)))
    else if(OperMatriz.ItemIndex=7) then
      PutResult(A.MPower(StrToInt(MData.Text)))
    else if(OperMatriz.ItemIndex=8) then
      PutResult(A.Transpuesta)

  end;
end;


procedure TForm1.OkSenlClick(Sender: TObject);
var
  VP: array of real;
  VE: array of string;
  i, ne: integer;
  TTB: TBox;
  e: real;
begin
  ne:= StrToInt(EcuationSenl.Text);
  e:= StrToFloat(HSenl.Text);
  SetLength(VP,ne);
  SetLength(VE,ne);
  for i:=0 to ne-1 do begin
    VP[i]:= StrToFloat(PointInitialSenl.Cells[0,i+1]);
    VE[i]:= SGEcuationSenl.Cells[0,i+1];
  end;

  MSenl.SetVariable(ne,VE,VP);
  TTB:= MSenl.NewtonGeneralizado(e);
  SGResultado(TTB);
end;

procedure TForm1.SGResultado(TB: TBox);
var
  i,j: integer;
begin
  MResult.Show;

  MResult.SGFResult.Clear();
  MResult.SGFResult.RowCount:= TB.x;
  MResult.SGFResult.ColCount:= TB.y;
  for i:=0 to TB.x-1 do
    for j:=0 to TB.y-1 do
      MResult.SGFResult.Cells[j,i]:= TB.M[i,j];
end;

procedure TForm1.DatoSenlClick(Sender: TObject);
begin
  SGEcuationSenl.Cells[0,0]:= 'Ecuaciones';
  PointInitialSenl.Cells[0,0]:= 'Puntos Iniciales';
  SGEcuationSenl.RowCount:= StrToInt(EcuationSenl.Text)+1;
  PointInitialSenl.RowCount:= StrToInt(EcuationSenl.Text)+1;
end;

procedure TForm1.ISGNEClick(Sender: TObject);
var
  nt: integer;
begin
  nt:= StrToInt(INE.Text);
  SGPI.RowCount:= nt+1;
  SGPI.Cells[0,0]:= 'x';
  SGPI.Cells[1,0]:= 'y';
end;

procedure TForm1.ILagrangeClick(Sender: TObject);
var
  i: integer;
  MP: TList;
begin
  MP:= TList.Create;
  for i:=1 to SGPI.RowCount-1 do
    MP.Add(TMPoint.Create(StrToFloat(SGPI.Cells[0,i]),StrToFloat(SGPI.Cells[1,i])));
  PointInter:= XIntervalo(MP);

  case TButton(Sender).Tag of
    0: InterpSol.Text:= MInterpolacion.Lagrange(MP);
    1: InterpSol.Text:= 'Newton';
  end;
  MP.Clear;
  PointInterXY();
end;

function TForm1.Func(x: real; s: string): real;
begin
  Parse.Expression:= s;
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();
end;

procedure TForm1.BInterpolarClick(Sender: TObject);
var
  xt: real;
begin
  if((InterX.Text <> '') and (InterpSol.Text<>'')) then begin
    xt:= StrToFloat(InterX.Text);
    if((xt<PointInter.x) or (xt>PointInter.y)) then
      ShowMessage('Fuera del Intervalo');
    InterY.Text:= FloatToStr(Func(xt,InterpSol.Text));
  end
  else
    ShowMessage('Aplicar Algún Método de Interpolación!!');
end;

procedure TForm1.ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
  APoint: TPoint);
var
  x, y: Double;
begin
  with ATool as TDatapointClickTool do
    if (Series is TLineSeries) then
      with TLineSeries(Series) do begin
        if(FuncSelected) then begin
          function1:= TEdit(EditList.Items[Tag]).Caption;
          FuncSelected:= False;
        end
        else begin
          if(function1 <> TEdit(EditList.Items[Tag]).Caption) then begin
            function2:= TEdit(EditList.Items[Tag]).Caption;
            FuncSelected:= True;
          end
          else
            ShowMessage('Seleccione otra función, no la misma!!');
        end;
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        Statusbar1.SimpleText := Format('f(x): %s', [TEdit(EditList.Items[Tag]).Caption]);
        //ListBox1.AddItem(TEdit(EditList.Items[Tag]).Caption,TEdit(EditList.Items[Tag]));
      end
    else
    begin
      Statusbar1.SimpleText:='';
    end;
end;

procedure TForm1.ResizeFuncClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to FunctionList.Count-2 do begin
    ActiveFunction:= i;
    ResizeGraphic2D;
  end;
end;

procedure TForm1.ButIntegClick(Sender: TObject);
var
  iter: integer;
  rin: real;
  MP: TMPoint;
  fn: string;
begin
  fn:= TextEcuac.Text;
  iter:= StrToInt(TextIter.Text);
  MP:= XIntervaloText(TextIntervalo.Text);
  case CmbInt.ItemIndex of
    0: rin:= MIntegracion.Trapecio(MP.x,MP.y,fn,iter);
    1: rin:= MIntegracion.SimpsonI(MP.x,MP.y,fn,iter);
    2: rin:= MIntegracion.SimpsonII(MP.x,MP.y,fn,iter);
    3: rin:= MIntegracion.CuadraturaGauss(MP.x,MP.y,fn,iter);
  end;
  ResuInteg.Text:= FloatToStr(rin);
end;


procedure TForm1.EdoGrap();
var
  i: integer;
begin
  GraficaIII.LinePen.Color:= ColorEdo.ButtonColor;
  GraficaIII.Clear;
  for i:=1 to MResult.SGFResult.RowCount-1 do
    GraficaIII.AddXY(StrToFloat(MResult.SGFResult.Cells[1,i]),StrToFloat(MResult.SGFResult.Cells[2,i]));
end;

procedure TForm1.EdoOkClick(Sender: TObject);
var
  MB: TBox;
  P1,P2: TMPoint;
  ntm: integer;
begin
  P1:= XIntervaloText(EdoInterv.Text);
  P2:= PointInitial(EdoInitial.Text);
  ntm:= StrToInt(EdoN.Text);

  case EdoMetodo.ItemIndex of
    0: MB:= MEDO.EulerMejorado(P1.x,P1.y,P2.x,P2.y,ntm,EdoEcuac.Text,EdoSol.Text);
    1: MB:= MEDO.RungeKutta4(P1.x,P1.y,P2.x,P2.y,ntm,EdoEcuac.Text,EdoSol.Text);
  end;
  SGResultado(MB);
  EdoGrap();
end;

{$R *.lfm}

end.
