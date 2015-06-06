unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, ComCtrls, ExtCtrls,
  libintherm, libherm;

type

  { TForm1 }
  TForm1 = class(TForm)
    RadioGroup1: TRadioGroup;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid2: TStringGrid;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Button1: TButton;
    Edit1: TEdit;
    Label3: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    //procedure Button1Click(Sender: TObject);
    procedure standardArithmetic;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  f,f2                 : extvec;
  x                    : extvec;
  m                    : intvec;
  H                    : Extended;
  xx                   : Extended;
  deriv                : Boolean;

implementation

{$R *.lfm}

procedure TForm1.FormActivate(Sender: TObject);
begin
     StringGrid1.Cells[0,0] := 'x';
     StringGrid1.Cells[1,0] := 'm';
     StringGrid2.Cells[0,0] := 'f';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
     standardArithmetic
  else
      ShowMessage('Not implemented');
end;


procedure TForm1.RadioGroup1SelectionChanged(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
  begin
       StringGrid1.ColCount := 2;
       StringGrid2.ColCount := 1;
  end
  else
  begin
       StringGrid1.ColCount := 3;
       StringGrid1.Cells[2,0] := 'x2';
       StringGrid2.ColCount := 2;
       StringGrid2.Cells[1,0] := 'f2';
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
     StringGrid1.RowCount := TrackBar1.Position + 2;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
          StringGrid2.RowCount := TrackBar2.Position + 2;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', '.']) then begin
    Key := #0;
  end
  else if (Key = FormatSettings.DecimalSeparator) and
          (Pos(Key, Edit1.Text) > 0) then begin
    Key := #0;
  end;
end;

procedure TForm1.standardArithmetic;
var i,ox,l,j,st,n : Integer;
    value, out_i, out_fi : String;
  d : Extended;
begin
  st := 0;
  n := TrackBar1.Position;
  ox := 0;
  FormatSettings.DecimalSeparator:='.';
  for i := 0 to TrackBar2.Position do
    begin
    {TODO: zabezpieczenia w przypadku, kiedy tablica nie jest wypełniona}
      val(StringGrid1.Cells[0,i+1], x[i]);
      val(StringGrid1.Cells[1,i+1], m[i]);
    end;
      for i:=0 to TrackBar2.Position do
    begin
      if i=0
        then l:=0
        else l:=l+m[i-1];
      for j:=l to l+m[i]-1 do
        begin
          val(StringGrid2.Cells[0,ox+1], f[j]);
          ox := ox + 1;
        end
    end;
    xx := StrToFloat(Edit1.Text);
    d := Hermitevalue(TrackBar1.Position, TrackBar2.Position, x, m, f, xx, st);
    Memo1.Lines.Clear;
    Memo1.Lines.Add('Wartość:');
    str(d:5:20, value);
    Memo1.Lines.Add(value);
    Memo1.Lines.Add('Współczynniki:');
    {===============================}
      Hermitecoeffns (TrackBar1.Position, TrackBar2.Position, x, m, f, st);
    for i:=0 to n do
    begin
        str(i, out_i);
        str(f[i], out_fi);
        Memo1.Lines.Add('f[' + out_i + '] = ' + out_fi);
      end;
    {for i:=0 to k do
    begin

      if i=0
        then l:=0
        else l:=l+m[i-1];
      for j:=l to l+m[i]-1 do
        begin
          deriv:=True;
          case j-l-1 of
            -1 : begin
                   H:=f[n];
                   for p:=n-1 downto 0 do
                     H:=H*x[i]+f[p]
                 end;
             0 : begin
                   H:=n*f[n];
                   for p:=n-1 downto 1 do
                     H:=H*x[i]+p*f[p]
                 end;
             1 : begin
                   H:=n*(n-1)*f[n];
                   for p:=n-1 downto 2 do
                     H:=H*x[i]+p*(p-1)*f[p]
                 end;
            else deriv:=False
          end;
          if deriv
            then Memo1.Lines.Add('x[' + IntToStr(i) + '] = ' + FloatToStr(H))
            else Memo1.Lines.Add('x[' + IntToStr(i) + '] = niepoliczone');
        end
    end;
    }
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     TrackBar1.Position := 5;
     TrackBar2.Position := 5;
     StringGrid1.Cells[0,1] := IntToStr(1);
     StringGrid1.Cells[0,2] := IntToStr(2);
     StringGrid1.Cells[0,3] := IntToStr(3);
     StringGrid1.Cells[0,4] := IntToStr(4);
     StringGrid1.Cells[0,5] := IntToStr(5);
     StringGrid1.Cells[0,6] := IntToStr(6);
     StringGrid1.Cells[1,1] := IntToStr(1);
     StringGrid1.Cells[1,2] := IntToStr(1);
     StringGrid1.Cells[1,3] := IntToStr(1);
     StringGrid1.Cells[1,4] := IntToStr(1);
     StringGrid1.Cells[1,5] := IntToStr(1);
     StringGrid1.Cells[1,6] := IntToStr(1);
     StringGrid2.Cells[0,1] := IntToStr(1);
     StringGrid2.Cells[0,2] := IntToStr(4);
     StringGrid2.Cells[0,3] := IntToStr(9);
     StringGrid2.Cells[0,4] := IntToStr(16);
     StringGrid2.Cells[0,5] := IntToStr(25);
     StringGrid2.Cells[0,6] := IntToStr(36);
     Edit1.Text := '2.5';

end;

end.




