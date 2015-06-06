unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, ComCtrls, ExtCtrls, IntervalArithmetic32and64;

type
    extvec   = array [0..20] of Extended;
    intvec  = array [0..20] of Integer;
    intervalvec = array [0..20] of interval;

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

function IntervalHermitevalue (n, k   : Integer;
                       x      : intervalvec;
                       m      : intvec;
                       f      : intervalvec;
                       xx     : interval;
                       var st : Integer) : interval;
var i,j,l,p,q,sum : Integer;
    diff,xii,xp   : interval;
    d,xi          : intervalvec;
    equal         : Boolean;
begin
  st:=0;
  if (n<0) or (k<0)
    then st:=1
    else begin
           if k>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for j:=i+1 to k do
                        if x[i]=x[j]
                          then st:=2
                    until (i=k-1) or (st=2)
                  end;
           if st<>2
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      if (m[i]<1) or (m[i]>8)
                        then st:=3
                    until (i=k) or (st=3);
                    if st<>3
                      then begin
                             sum:=0;
                             for i:=0 to k do
                               sum:=sum+m[i];
                             if sum<>n+1
                               then st:=4
                           end
                  end
         end;
  if st=0
    then begin
           for i:=0 to k do
             begin
               if i=0
                 then l:=0
                 else l:=l+m[i-1];
               for j:=l to l+m[i]-1 do
                 begin
                   xi[j]:=x[i];
                   d[j]:=f[l]
                 end
             end;
             for q:=1 to n do
               begin
                 l:=k;
                 equal:=False;
                 for i:=n downto q do
                   begin
                     xii:=xi[i];
                     if (q<8) and (xi[i-q]=xii)
                       then begin
                              sum:=1;
                              for j:=1 to q do
                                sum:=sum*j;
                              if not equal
                                then begin
                                       p:=0;
                                       for j:=k downto l do
                                         p:=p+m[j];
                                       p:=n+1-p+q;
                                       equal:=True
                                     end;
                              d[i]:=f[p]/int_read(IntToStr(sum))
                            end
                       else begin
                              diff:=xii-xi[i-q];
                              if (q=1) or (xii<>xi[i-1])
                                then begin
                                       l:=l-1;
                                       equal:=False
                                     end;
                              d[i]:=(d[i]-d[i-1])/diff
                            end
                   end
               end;
           diff:=int_read('0');
           for i:=0 to k do
             begin
               if i=0
                 then sum:=0
                 else begin
                        sum:=m[0];
                        for p:=1 to i-1 do
                          sum:=sum+m[p]
                      end;
               xii:=int_read('1');
               for p:=0 to i-1 do
                 begin
                   xp:=x[p];
                   for q:=1 to m[p] do
                     xii:=xii*(xx-xp)
                 end;
               for j:=0 to m[i]-1 do
                 begin
                   xp:=x[i];
                   for p:=1 to j do
                     xii:=xii*(xx-xp);
                   diff:=diff+d[sum+j]*xii
                 end
             end;
           IntervalHermitevalue:=diff
         end
end;

procedure IntervalHermitecoeffns (n,k    : Integer;
                          x      : intervalvec;
                          m      : intvec;
                          var f  : intervalvec;
                          var st : Integer);
procedure polyproduct (n,m   : Integer;
                       a,b   : intervalvec;
                       var p : Integer;
                       var c : intervalvec);
function calculate (k,i1,i2 : Integer;
                    x,y     : intervalvec) : interval;
var i   : Integer;
    sum : interval;
begin
  sum:=int_read('0');
  for i:=i1 to i2 do
    sum:=sum+x[k-i]*y[i];
  calculate:=sum
end {calculate};
var k : Integer;
begin
  p:=n+m;
  if n<m
    then begin
           for k:=0 to n-1 do
             c[k]:=calculate(k,0,k,b,a);
           for k:=n to m do
             c[k]:=calculate(k,0,n,b,a);
           for k:=m+1 to p do
             c[k]:=calculate(k,k-m,n,b,a)
         end
    else begin
           for k:=0 to m-1 do
             c[k]:=calculate(k,0,k,a,b);
           for k:=m to n do
             c[k]:=calculate(k,0,m,a,b);
           for k:=n+1 to p do
             c[k]:=calculate(k,k-n,m,a,b)
         end
end {polyproduct};
procedure bintopoly (n     : Integer;
                     x     : interval;
                     var c : intervalvec);
var k,i  : Integer;
    prod : Extended;
begin
  if x<>0
    then begin
           for k:=0 to n do
             begin
               prod:=1;
               for i:=0 to k-1 do
                 prod:=prod*(n-i)/(k-i);
               if x>int_read('0')
                 then prod:=prod*Exp((n-k)*Ln(x.a))
                 else if x<int_read('0')
                        then begin
                               prod:=prod*Exp((n-k)*Ln(Abs(x.a)));
                               if Odd(n-k)
                                 then prod:=-prod
                             end;
               if Odd(k)
                 then prod:=-prod;
               c[k]:=int_read(FloatToStr(prod))
             end;
           if Odd(n)
             then for k:=0 to n do
                    c[k]:=int_read('-1')*c[k]
         end
    else begin
           if Odd(n)
             then c[n]:=int_read('-1')
             else c[n]:=int_read('1');
           for k:=0 to n-1 do
             c[k]:=int_read('0')
         end
end {bintopoly};
var i,j,l,p,q,sum : Integer;
    diff,xii   : interval;
    a,b,d,xi      : intervalvec;
    equal         : Boolean;
begin
  st:=0;
  if (n<0) or (k<0)
    then st:=1
    else begin
           if k>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for j:=i+1 to k do
                        if x[i]=x[j]
                          then st:=2
                    until (i=k-1) or (st=2)
                  end;
           if st<>2
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      if (m[i]<1) or (m[i]>8)
                        then st:=3
                    until (i=k) or (st=3);
                    if st<>3
                      then begin
                             sum:=0;
                             for i:=0 to k do
                               sum:=sum+m[i];
                             if sum<>n+1
                               then st:=4
                           end
                  end
         end;
  if st=0
    then begin
           for i:=0 to k do
             begin
               if i=0
                 then l:=0
                 else l:=l+m[i-1];
               for j:=l to l+m[i]-1 do
                 begin
                   xi[j]:=x[i];
                   d[j]:=f[l]
                 end
             end;
             for q:=1 to n do
               begin
                 l:=k;
                 equal:=False;
                 for i:=n downto q do
                   begin
                     xii:=xi[i];
                     if (q<8) and (xi[i-q]=xii)
                       then begin
                              sum:=1;
                              for j:=1 to q do
                                sum:=sum*j;
                              if not equal
                                then begin
                                       p:=0;
                                       for j:=k downto l do
                                         p:=p+m[j];
                                       p:=n+1-p+q;
                                       equal:=True
                                     end;
                              d[i]:=f[p]/int_read(IntToStr(sum))
                            end
                       else begin
                              diff:=xii-xi[i-q];
                              if (q=1) or (xii<>xi[i-1])
                                then begin
                                       l:=l-1;
                                       equal:=False
                                     end;
                              d[i]:=(d[i]-d[i-1])/diff
                            end
                   end
               end;
           for i:=0 to n do
             begin
               f[i]:=int_read('0');
               a[i]:=int_read('0')
             end;
           q:=m[0];
           a[0]:=d[q-1];
           b[0]:=int_read('-1')*x[0];
           b[1]:=int_read('1');
           p:=0;
           for j:=q-2 downto 0 do
             begin
               polyproduct (q-j-2,1,a,b,p,xi);
               for l:=0 to p do
                 a[l]:=xi[l];
               a[0]:=a[0]+d[j]
             end;
           for i:=0 to p do
             f[i]:=a[i];
           if k>0
             then begin
                    for i:=0 to p do
                      a[i]:=int_read('0');
                    sum:=q;
                    for i:=1 to k-1 do
                      sum:=sum+m[i];
                    a[0]:=d[sum];
                    q:=0;
                    for i:=k-1 downto 1 do
                      begin
                        bintopoly (m[i],x[i],b);
                        polyproduct (q,m[i],a,b,p,xi);
                        for l:=0 to p do
                          a[l]:=xi[l];
                        sum:=sum-m[i];
                        a[0]:=a[0]+d[sum];
                        q:=p
                      end;
                    bintopoly (m[0],x[0],b);
                    polyproduct (q,m[0],a,b,p,a);
                    for i:=0 to p do
                      f[i]:=f[i]+a[i];
                    for i:=1 to k do
                      if m[i]>1
                        then begin
                               q:=m[i];
                               sum:=m[0];
                               for j:=1 to i-1 do
                                 sum:=sum+m[j];
                               a[0]:=d[sum+q-1];
                               b[0]:=int_read('-1')*x[i];
                               b[1]:=int_read('1');
                               p:=0;
                               for j:=q-2 downto 1 do
                                 begin
                                   polyproduct (q-j-2,1,a,b,p,xi);
                                   for l:=0 to p do
                                     a[l]:=xi[l];
                                   a[0]:=a[0]+d[sum+j]
                                 end;
                               polyproduct (p,1,a,b,p,a);
                               for j:=0 to i-1 do
                                 begin
                                   bintopoly (m[j],x[j],b);
                                   polyproduct (p,m[j],a,b,p,a)
                                 end;
                               for l:=0 to p do
                                 f[l]:=f[l]+a[l]
                             end
                  end
         end
end;


function Hermitevalue (n, k   : Integer;
                       x      : extvec;
                       m      : intvec;
                       f      : extvec;
                       xx     : Extended;
                       var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Hermitevalue calculates the value of a polynomial given by  }
{  Hermite's interpolation formula.                                         }
{  Data:                                                                    }
{    n  - the degree of polynomial (the degree is at most n),               }
{    k  - number of nodes minus 1 (the nodes are numbered from 0 to k),     }
{    x  - an array containing the values of nodes,                          }
{    m  - an array containing the positive integers associated with nodes   }
{         (m[i] is the multiplicity of the node x[i]; the elements of m     }
{         should satisfy the condition m[0]+m[1]+...+m[k]=n+1),             }
{    f  - an array containing the values of function and its derivatives at }
{         succeeding nodes (the element f[0] should contain the value of    }
{         f(x[0]), f[1] - the value of f'(x[0]), ..., f[m[0]-1] - the value }
{         of (m[0]-1) derivative of f at x[0], ..., the element             }
{         f[m[0]+m[1]+...m[k-1]] should contain the value of f(x[k]), ...,  }
{         and the element f[m[0]+m[1]+...+m[k-1]+m[k]-1] - the value of     }
{         (m[k]-1) derivative of f at x[k]),                                }
{    xx - the point at which the value of interpolating polynomial should   }
{         be calculated.                                                    }
{  Result:                                                                  }
{    Hermitevalue(n,k,x,m,f,xx,st) - the value of polynomial at xx.         }
{  Other parameters:                                                        }
{    st - a variable which within the function Hermitevalue is assigned the }
{         value of:                                                         }
{           1, if n<0 or k<0,                                               }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,k) such      }
{              that x[i]=x[j],                                              }
{           3, if m[i]<1 or m[i]>8 for at least one i,                      }
{           4, if m[0]+m[1]+...+m[k] is not equal to n+1,                   }
{           0, otherwise.                                                   }
{         Note: If st<>0, then Hermitevalue(n,k,x,m,f,xx,st) is not         }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    extvec  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    extvec - a type identifier of extended array [q0..qk], where q0<=0    }
{              and qk>=k,                                                   }
{    intvec - a type identifier of integer array [q0..qk], where q0<=0     }
{              and qk>=k.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,l,p,q,sum : Integer;
    diff,xii,xp   : Extended;
    d,xi          : extvec;
    equal         : Boolean;
begin
  st:=0;
  if (n<0) or (k<0)
    then st:=1
    else begin
           if k>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for j:=i+1 to k do
                        if x[i]=x[j]
                          then st:=2
                    until (i=k-1) or (st=2)
                  end;
           if st<>2
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      if (m[i]<1) or (m[i]>8)
                        then st:=3
                    until (i=k) or (st=3);
                    if st<>3
                      then begin
                             sum:=0;
                             for i:=0 to k do
                               sum:=sum+m[i];
                             if sum<>n+1
                               then st:=4
                           end
                  end
         end;
  if st=0
    then begin
           for i:=0 to k do
             begin
               if i=0
                 then l:=0
                 else l:=l+m[i-1];
               for j:=l to l+m[i]-1 do
                 begin
                   xi[j]:=x[i];
                   d[j]:=f[l]
                 end
             end;
             for q:=1 to n do
               begin
                 l:=k;
                 equal:=False;
                 for i:=n downto q do
                   begin
                     xii:=xi[i];
                     if (q<8) and (xi[i-q]=xii)
                       then begin
                              sum:=1;
                              for j:=1 to q do
                                sum:=sum*j;
                              if not equal
                                then begin
                                       p:=0;
                                       for j:=k downto l do
                                         p:=p+m[j];
                                       p:=n+1-p+q;
                                       equal:=True
                                     end;
                              d[i]:=f[p]/sum
                            end
                       else begin
                              diff:=xii-xi[i-q];
                              if (q=1) or (xii<>xi[i-1])
                                then begin
                                       l:=l-1;
                                       equal:=False
                                     end;
                              d[i]:=(d[i]-d[i-1])/diff
                            end
                   end
               end;
           diff:=0;
           for i:=0 to k do
             begin
               if i=0
                 then sum:=0
                 else begin
                        sum:=m[0];
                        for p:=1 to i-1 do
                          sum:=sum+m[p]
                      end;
               xii:=1;
               for p:=0 to i-1 do
                 begin
                   xp:=x[p];
                   for q:=1 to m[p] do
                     xii:=xii*(xx-xp)
                 end;
               for j:=0 to m[i]-1 do
                 begin
                   xp:=x[i];
                   for p:=1 to j do
                     xii:=xii*(xx-xp);
                   diff:=diff+d[sum+j]*xii
                 end
             end;
           Hermitevalue:=diff
         end
end;

procedure Hermitecoeffns (n,k    : Integer;
                          x      : extvec;
                          m      : intvec;
                          var f  : extvec;
                          var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Hermitecoeffns calculates coefficients of a polynomial     }
{  given by Hermite's interpolation formula.                                }
{  Data:                                                                    }
{    n - the degree of polynomial (the degree is at most n),                }
{    k - number of nodes minus 1 (the nodes are numbered from 0 to k),      }
{    x - an array containing the values of nodes,                           }
{    m - an array containing the positive integers associated with nodes    }
{        (m[i] is the multiplicity of the node x[i]; the elements of m      }
{        should satisfy the condition m[0]+m[1]+...+m[k]=n+1),              }
{    f - an array containing the values of function and its derivatives at  }
{        succeeding nodes (the element f[0] should contain the value of     }
{        f(x[0]), f[1] - the value of f'(x[0]), ..., f[m[0]-1] - the value  }
{        of (m[0]-1) derivative of f at x[0], ..., the element              }
{        f[m[0]+m[1]+...m[k-1]] should contain the value of f(x[k]), ...,   }
{        and the element f[m[0]+m[1]+...+m[k-1]+m[k]-1] - the value of      }
{        (m[k]-1) derivative of f at x[k]; the elements of array f are      }
{        changed on exit).                                                  }
{  Result:                                                                  }
{    f - an array of coefficients of polynomial (the element f[i] contains  }
{        the value of coefficient before x^i; i=0,1,...,n).                 }
{  Other parameters:                                                        }
{    st - a variable which within the function Hermitevalue is assigned the }
{         value of:                                                         }
{           1, if n<0 or k<0,                                               }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,k) such      }
{              that x[i]=x[j],                                              }
{           3, if m[i]<1 or m[i]>8 for at least one i,                      }
{           4, if m[0]+m[1]+...+m[k] is not equal to n+1,                   }
{           0, otherwise.                                                   }
{         Note: If st<>0, then Hermitevalue(n,k,x,m,f,xx,st) is not         }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    extvec  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    extvec - a type identifier of extended array [q0..qk], where q0<=0    }
{              and qk>=k,                                                   }
{    intvec - a type identifier of integer array [q0..qk], where q0<=0     }
{              and qk>=k.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
procedure polyproduct (n,m   : Integer;
                       a,b   : extvec;
                       var p : Integer;
                       var c : extvec);
function calculate (k,i1,i2 : Integer;
                    x,y     : extvec) : Extended;
var i   : Integer;
    sum : Extended;
begin
  sum:=0;
  for i:=i1 to i2 do
    sum:=sum+x[k-i]*y[i];
  calculate:=sum
end {calculate};
var k : Integer;
begin
  p:=n+m;
  if n<m
    then begin
           for k:=0 to n-1 do
             c[k]:=calculate(k,0,k,b,a);
           for k:=n to m do
             c[k]:=calculate(k,0,n,b,a);
           for k:=m+1 to p do
             c[k]:=calculate(k,k-m,n,b,a)
         end
    else begin
           for k:=0 to m-1 do
             c[k]:=calculate(k,0,k,a,b);
           for k:=m to n do
             c[k]:=calculate(k,0,m,a,b);
           for k:=n+1 to p do
             c[k]:=calculate(k,k-n,m,a,b)
         end
end {polyproduct};
procedure bintopoly (n     : Integer;
                     x     : Extended;
                     var c : extvec);
var k,i  : Integer;
    prod : Extended;
begin
  if x<>0
    then begin
           for k:=0 to n do
             begin
               prod:=1;
               for i:=0 to k-1 do
                 prod:=prod*(n-i)/(k-i);
               if x>0
                 then prod:=prod*Exp((n-k)*Ln(x))
                 else if x<0
                        then begin
                               prod:=prod*Exp((n-k)*Ln(Abs(x)));
                               if Odd(n-k)
                                 then prod:=-prod
                             end;
               if Odd(k)
                 then prod:=-prod;
               c[k]:=prod
             end;
           if Odd(n)
             then for k:=0 to n do
                    c[k]:=-c[k]
         end
    else begin
           if Odd(n)
             then c[n]:=-1
             else c[n]:=1;
           for k:=0 to n-1 do
             c[k]:=0
         end
end {bintopoly};
var i,j,l,p,q,sum : Integer;
    diff,xii   : Extended;
    a,b,d,xi      : extvec;
    equal         : Boolean;
begin
  st:=0;
  if (n<0) or (k<0)
    then st:=1
    else begin
           if k>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for j:=i+1 to k do
                        if x[i]=x[j]
                          then st:=2
                    until (i=k-1) or (st=2)
                  end;
           if st<>2
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      if (m[i]<1) or (m[i]>8)
                        then st:=3
                    until (i=k) or (st=3);
                    if st<>3
                      then begin
                             sum:=0;
                             for i:=0 to k do
                               sum:=sum+m[i];
                             if sum<>n+1
                               then st:=4
                           end
                  end
         end;
  if st=0
    then begin
           for i:=0 to k do
             begin
               if i=0
                 then l:=0
                 else l:=l+m[i-1];
               for j:=l to l+m[i]-1 do
                 begin
                   xi[j]:=x[i];
                   d[j]:=f[l]
                 end
             end;
             for q:=1 to n do
               begin
                 l:=k;
                 equal:=False;
                 for i:=n downto q do
                   begin
                     xii:=xi[i];
                     if (q<8) and (xi[i-q]=xii)
                       then begin
                              sum:=1;
                              for j:=1 to q do
                                sum:=sum*j;
                              if not equal
                                then begin
                                       p:=0;
                                       for j:=k downto l do
                                         p:=p+m[j];
                                       p:=n+1-p+q;
                                       equal:=True
                                     end;
                              d[i]:=f[p]/sum
                            end
                       else begin
                              diff:=xii-xi[i-q];
                              if (q=1) or (xii<>xi[i-1])
                                then begin
                                       l:=l-1;
                                       equal:=False
                                     end;
                              d[i]:=(d[i]-d[i-1])/diff
                            end
                   end
               end;
           for i:=0 to n do
             begin
               f[i]:=0;
               a[i]:=0
             end;
           q:=m[0];
           a[0]:=d[q-1];
           b[0]:=-x[0];
           b[1]:=1;
           p:=0;
           for j:=q-2 downto 0 do
             begin
               polyproduct (q-j-2,1,a,b,p,xi);
               for l:=0 to p do
                 a[l]:=xi[l];
               a[0]:=a[0]+d[j]
             end;
           for i:=0 to p do
             f[i]:=a[i];
           if k>0
             then begin
                    for i:=0 to p do
                      a[i]:=0;
                    sum:=q;
                    for i:=1 to k-1 do
                      sum:=sum+m[i];
                    a[0]:=d[sum];
                    q:=0;
                    for i:=k-1 downto 1 do
                      begin
                        bintopoly (m[i],x[i],b);
                        polyproduct (q,m[i],a,b,p,xi);
                        for l:=0 to p do
                          a[l]:=xi[l];
                        sum:=sum-m[i];
                        a[0]:=a[0]+d[sum];
                        q:=p
                      end;
                    bintopoly (m[0],x[0],b);
                    polyproduct (q,m[0],a,b,p,a);
                    for i:=0 to p do
                      f[i]:=f[i]+a[i];
                    for i:=1 to k do
                      if m[i]>1
                        then begin
                               q:=m[i];
                               sum:=m[0];
                               for j:=1 to i-1 do
                                 sum:=sum+m[j];
                               a[0]:=d[sum+q-1];
                               b[0]:=-x[i];
                               b[1]:=1;
                               p:=0;
                               for j:=q-2 downto 1 do
                                 begin
                                   polyproduct (q-j-2,1,a,b,p,xi);
                                   for l:=0 to p do
                                     a[l]:=xi[l];
                                   a[0]:=a[0]+d[sum+j]
                                 end;
                               polyproduct (p,1,a,b,p,a);
                               for j:=0 to i-1 do
                                 begin
                                   bintopoly (m[j],x[j],b);
                                   polyproduct (p,m[j],a,b,p,a)
                                 end;
                               for l:=0 to p do
                                 f[l]:=f[l]+a[l]
                             end
                  end
         end
end;

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



