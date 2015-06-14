unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, ComCtrls, ExtCtrls, Spin, IntervalArithmetic32and64,
  libintherm, libherm;

type
  { TForm1 }
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    kSpin: TSpinEdit;
    nSpin: TSpinEdit;
    RadioGroup2: TRadioGroup;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Label3: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure RadioGroup2SelectionChanged(Sender: TObject);
    procedure standardArithmetic;
    procedure intervalArithmetic;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
    standardArithmetic
  else
    intervalArithmetic;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to StringGrid1.RowCount - 1 do
    StringGrid1.Rows[i].Clear;
  StringGrid1.Cells[0, 0] := 'x';
  StringGrid1.Cells[1, 0] := 'm';
  StringGrid1.Cells[2, 0] := 'f';
  case ComboBox1.ItemIndex of
    0:
    begin
      nSpin.Value := 5;
      kSpin.Value := 5;
      StringGrid1.Cells[0, 1] := IntToStr(1);
      StringGrid1.Cells[0, 2] := IntToStr(2);
      StringGrid1.Cells[0, 3] := IntToStr(3);
      StringGrid1.Cells[0, 4] := IntToStr(4);
      StringGrid1.Cells[0, 5] := IntToStr(5);
      StringGrid1.Cells[0, 6] := IntToStr(6);

      StringGrid1.Cells[1, 1] := IntToStr(1);
      StringGrid1.Cells[1, 2] := IntToStr(1);
      StringGrid1.Cells[1, 3] := IntToStr(1);
      StringGrid1.Cells[1, 4] := IntToStr(1);
      StringGrid1.Cells[1, 5] := IntToStr(1);
      StringGrid1.Cells[1, 6] := IntToStr(1);

      StringGrid1.Cells[2, 1] := IntToStr(1);
      StringGrid1.Cells[2, 2] := IntToStr(4);
      StringGrid1.Cells[2, 3] := IntToStr(9);
      StringGrid1.Cells[2, 4] := IntToStr(16);
      StringGrid1.Cells[2, 5] := IntToStr(25);
      StringGrid1.Cells[2, 6] := IntToStr(36);
      Edit1.Text := '2.5';
      Edit2.Text := Edit1.Text;
    end;
    1:
    begin
      nSpin.Value := 6;
      kSpin.Value := 3;
      StringGrid1.Cells[0, 1] := IntToStr(1);
      StringGrid1.Cells[0, 2] := IntToStr(2);
      StringGrid1.Cells[0, 3] := IntToStr(3);
      StringGrid1.Cells[0, 4] := IntToStr(4);

      StringGrid1.Cells[1, 1] := IntToStr(1);
      StringGrid1.Cells[1, 2] := IntToStr(3);
      StringGrid1.Cells[1, 3] := IntToStr(1);
      StringGrid1.Cells[1, 4] := IntToStr(2);

      StringGrid1.Cells[2, 1] := IntToStr(1);
      StringGrid1.Cells[2, 2] := IntToStr(4);
      StringGrid1.Cells[2, 3] := IntToStr(4);
      StringGrid1.Cells[2, 4] := IntToStr(2);
      StringGrid1.Cells[2, 5] := IntToStr(9);
      StringGrid1.Cells[2, 6] := IntToStr(16);
      StringGrid1.Cells[2, 7] := IntToStr(8);
      Edit1.Text := '2.5';
      Edit2.Text := Edit1.Text;
    end;
    2:
    begin
      nSpin.Value := 9;
      kSpin.Value := 4;
      StringGrid1.Cells[0, 1] := '0.2';
      StringGrid1.Cells[0, 2] := '0.4';
      StringGrid1.Cells[0, 3] := '0.6';
      StringGrid1.Cells[0, 4] := '0.8';
      StringGrid1.Cells[0, 5] := '1.0';

      StringGrid1.Cells[1, 1] := IntToStr(2);
      StringGrid1.Cells[1, 2] := IntToStr(2);
      StringGrid1.Cells[1, 3] := IntToStr(2);
      StringGrid1.Cells[1, 4] := IntToStr(2);
      StringGrid1.Cells[1, 5] := IntToStr(2);

      StringGrid1.Cells[2, 1] := '0.9798652';
      StringGrid1.Cells[2, 2] := '0.20271';
      StringGrid1.Cells[2, 3] := '0.9177710';
      StringGrid1.Cells[2, 4] := '0.42279';
      StringGrid1.Cells[2, 5] := '0.8080348';
      StringGrid1.Cells[2, 6] := '0.68414';
      StringGrid1.Cells[2, 7] := '0.6386093';
      StringGrid1.Cells[2, 8] := '1.02964';
      StringGrid1.Cells[2, 9] := '0.3843735';
      StringGrid1.Cells[2, 10] := '1.55741';
      Edit1.Text := '0.5';
      Edit2.Text := Edit1.Text;
    end;
    3:
    begin
      nSpin.Value := 0;
      kSpin.Value := 0;
      StringGrid1.Cells[0, 1] := '0';

      StringGrid1.Cells[1, 1] := IntToStr(1);

      StringGrid1.Cells[2, 1] := '0';
      Edit1.Text := '0.5';
      Edit2.Text := Edit1.Text;
    end;
    4:
    begin
      nSpin.Value := 4;
      kSpin.Value := 2;

      StringGrid1.Cells[0, 1] := '0';
      StringGrid1.Cells[0, 2] := '1';
      StringGrid1.Cells[0, 3] := '2';

      StringGrid1.Cells[1, 1] := IntToStr(1);
      StringGrid1.Cells[1, 2] := IntToStr(2);
      StringGrid1.Cells[1, 3] := IntToStr(3);

      StringGrid1.Cells[2, 1] := '0';
      StringGrid1.Cells[2, 2] := '1';
      StringGrid1.Cells[2, 3] := '2';
      StringGrid1.Cells[2, 4] := '3';
      StringGrid1.Cells[2, 5] := '4';
      StringGrid1.Cells[2, 6] := '5';
      Edit1.Text := '1.5';
      Edit2.Text := Edit1.Text;
    end;
  end;
  if StringGrid1.ColCount <> 3 then
  begin
    for i := 0 to StringGrid1.RowCount - 1 do
    begin
      StringGrid1.Cells[3, i] := StringGrid1.Cells[0, i];
      StringGrid1.Cells[4, i] := StringGrid1.Cells[2, i];
    end;
  end;
end;

procedure TForm1.RadioGroup1SelectionChanged(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
  begin
    StringGrid1.ColCount := 3;
    Edit2.Enabled := false;
  end
  else
  begin
    StringGrid1.ColCount := 5;
    Edit2.Enabled := true;
  end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in [#8, '0'..'9', '.']) then
  begin
    Key := #0;
  end
  else if (Key = FormatSettings.DecimalSeparator) and (Pos(Key, Edit1.Text) > 0) then
  begin
    Key := #0;
  end;
end;

procedure TForm1.RadioGroup2SelectionChanged(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to StringGrid1.RowCount - 1 do
    StringGrid1.Rows[i].Clear;
  StringGrid1.Cells[0, 0] := 'x';
  StringGrid1.Cells[1, 0] := 'm';
  StringGrid1.Cells[2, 0] := 'f';
  if RadioGroup2.ItemIndex = 0 then
  begin
    nSpin.Enabled := True;
    kSpin.Enabled := True;
    nSpin.Value := 0;
    kSpin.Value := 0;
    ComboBox1.Enabled := False;
    //Edit1.Enabled := True;
  end
  else if RadioGroup2.ItemIndex = 1 then
  begin
    nSpin.Enabled := False;
    kSpin.Enabled := False;
    ComboBox1.Enabled := True;
    //Edit1.Enabled := False;
    ComboBox1Change(Sender);
  end;
end;

procedure TForm1.standardArithmetic;
var
  i, ox, l, j, st, n, k: integer;
  Value, out_i, out_fi: string;
  d: extended;
  x: extvec;
  m: libherm.intvec;
  xx: extended;
  f: extvec;
begin
  n := nSpin.Value;
  k := kSpin.Value;
  SetLength(x, 20);
  SetLength(m, 20);
  SetLength(f, 20);
  st := 0;
  ox := 0;
  FormatSettings.DecimalSeparator := '.';
  for i := 0 to k do
  begin
    {TODO: zabezpieczenia w przypadku, kiedy tablica nie jest wypełniona}
    val(StringGrid1.Cells[0, i + 1], x[i]);
    val(StringGrid1.Cells[1, i + 1], m[i]);
  end;
  for i := 0 to k do
  begin
    if i = 0 then
      l := 0
    else
      l := l + m[i - 1];
    for j := l to l + m[i] - 1 do
    begin
      val(StringGrid1.Cells[2, ox + 1], f[j]);
      ox := ox + 1;
    end;
  end;
  xx := StrToFloat(Edit1.Text);
  d := Hermitevalue(n, k, x, m, f, xx, st);
  Memo1.Lines.Clear;
  if st = 0 then
  begin
    Memo1.Lines.Add('Wartość:');
    str(d: 5: 20, Value);
    Memo1.Lines.Add(Value);
    Memo1.Lines.Add('Współczynniki:');
    Hermitecoeffns(n, k, x, m, f, st);
    for i := 0 to n do
    begin
      str(i, out_i);
      str(f[i], out_fi);
      Memo1.Lines.Add('f[' + out_i + '] = ' + out_fi);
    end;
  end
  else
  begin
    Memo1.Lines.Add('st = ' + IntToStr(st));
  end;
end;

procedure TForm1.intervalArithmetic;
var
  i, ox, l, j, st, n, k: integer;
  out_i: string;
  d: interval;
  x: intervalvec;
  m: libintherm.intvec;
  xx: interval;
  f: intervalvec;
  ileft, iright: string;
begin
  st := 0;
  n := nSpin.Value;
  k := kSpin.Value;
  SetLength(x, 20);
  SetLength(m, 20);
  SetLength(f, 20);
  ox := 0;
  FormatSettings.DecimalSeparator := '.';
  for i := 0 to k do
  begin
    {TODO: zabezpieczenia w przypadku, kiedy tablica nie jest wypełniona}
    //x[i] := int_read(StringGrid1.Cells[0, i + 1]);
    val(StringGrid1.Cells[0, i + 1], x[i].a);
    val(StringGrid1.Cells[3, i + 1], x[i].b);
    val(StringGrid1.Cells[1, i + 1], m[i]);
  end;
  for i := 0 to k do
  begin
    if i = 0 then
      l := 0
    else
      l := l + m[i - 1];
    for j := l to l + m[i] - 1 do
    begin
      //f[j] := int_read(StringGrid1.Cells[2, ox + 1]);
      val(StringGrid1.Cells[2, ox + 1], f[j].a);
      val(StringGrid1.Cells[4, ox + 1], f[j].b);
      ox := ox + 1;
    end;
  end;
  val(Edit1.Text, xx.a);
  val(Edit2.Text, xx.b);
  //xx := int_read(Edit1.Text);
  d := IntervalHermitevalue(n, k, x, m, f, xx, st);
  Memo1.Lines.Clear;
  if st = 0 then
  begin
    iends_to_strings(d, ileft, iright);
    Memo1.Lines.Add('Wartość:');
    Memo1.Lines.Add('[' + ileft + ';' + iright + ']');
    Memo1.Lines.Add('Współczynniki:');
    IntervalHermitecoeffns(n, k, x, m, f, st);
    for i := 0 to n do
    begin
      str(i, out_i);
      iends_to_strings(f[i], ileft, iright);
      Memo1.Lines.Add('f[' + out_i + '] = [' + ileft + ';' + iright + ']');
    end;
  end
  else
  begin
    Memo1.Lines.Add('st = ' + IntToStr(st));
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  RadioGroup2SelectionChanged(Sender);
end;

end.
