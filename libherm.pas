unit libherm;

interface

type
  extvec = array of Extended;
  intvec = array of Integer;

function Hermitevalue(n, k: integer; x: extvec;
  m: intvec; f: extvec;
  xx: extended;
  var st: integer): extended;

procedure Hermitecoeffns(n, k: integer; x: extvec;
  m: intvec; var f: extvec;
  var st: integer);

implementation

function Hermitevalue(n, k: integer; x: extvec;
  m: intvec; f: extvec;
  xx: extended;
  var st: integer): extended;
var
  i, j, l, p, q, sum: integer;
  diff, xii, xp: extended;
  d, xi: extvec;
  equal: boolean;
begin
  SetLength(xi, 20);
  SetLength(d, 20);
  st := 0;
  if (n < 0) or (k < 0) then
    st := 1
  else
  begin
    if k > 0 then
    begin
      i := -1;
      repeat
        i := i + 1;
        for j := i + 1 to k do
          if x[i] = x[j] then
            st := 2
      until (i = k - 1) or (st = 2);
    end;
    if st <> 2 then
    begin
      i := -1;
      repeat
        i := i + 1;
        if (m[i] < 1) or (m[i] > 8) then
          st := 3
      until (i = k) or (st = 3);
      if st <> 3 then
      begin
        sum := 0;
        for i := 0 to k do
          sum := sum + m[i];
        if sum <> n + 1 then
          st := 4;
      end;
    end;
  end;
  if st = 0 then
  begin
    for i := 0 to k do
    begin
      if i = 0 then
        l := 0
      else
        l := l + m[i - 1];
      for j := l to l + m[i] - 1 do
      begin
        xi[j] := x[i];
        d[j] := f[l];
      end;
    end;
    for q := 1 to n do
    begin
      l := k;
      equal := False;
      for i := n downto q do
      begin
        xii := xi[i];
        if (q < 8) and (xi[i - q] = xii) then
        begin
          sum := 1;
          for j := 1 to q do
            sum := sum * j;
          if not equal then
          begin
            p := 0;
            for j := k downto l do
              p := p + m[j];
            p := n + 1 - p + q;
            equal := True;
          end;
          d[i] := f[p] / sum;
        end
        else
        begin
          diff := xii - xi[i - q];
          if (q = 1) or (xii <> xi[i - 1])
          then
          begin
            l := l - 1;
            equal := False;
          end;
          d[i] := (d[i] - d[i - 1]) / diff;
        end;
      end;
    end;
    diff := 0;
    for i := 0 to k do
    begin
      if i = 0 then
        sum := 0
      else
      begin
        sum := m[0];
        for p := 1 to i - 1 do
          sum := sum + m[p];
      end;
      xii := 1;
      for p := 0 to i - 1 do
      begin
        xp := x[p];
        for q := 1 to m[p] do
          xii := xii * (xx - xp);
      end;
      for j := 0 to m[i] - 1 do
      begin
        xp := x[i];
        for p := 1 to j do
          xii := xii * (xx - xp);
        diff := diff + d[sum + j] * xii;
      end;
    end;
    Hermitevalue := diff;
  end;
  xi := nil;
  d := nil;
end;

procedure Hermitecoeffns(n, k: integer; x: extvec;
  m: intvec; var f: extvec;
  var st: integer);

  procedure polyproduct(n, m: integer; a, b: extvec;
  var p: integer; var c: extvec);

    function calculate(k, i1, i2: integer; x, y: extvec): extended;
    var
      i: integer;
      sum: extended;
    begin
      sum := 0;
      for i := i1 to i2 do
        sum := sum + x[k - i] * y[i];
      calculate := sum;
    end {calculate};
  var
    k: integer;
    d : extvec;
  begin
    d := Copy(a, 0, Length(a));
    c := d;
    p := n + m;
    if n < m then
    begin
      for k := 0 to n - 1 do
        c[k] := calculate(k, 0, k, b, a);
      for k := n to m do
        c[k] := calculate(k, 0, n, b, a);
      for k := m + 1 to p do
        c[k] := calculate(k, k - m, n, b, a);
    end
    else
    begin
      for k := 0 to m - 1 do
        c[k] := calculate(k, 0, k, a, b);
      for k := m to n do
        c[k] := calculate(k, 0, m, a, b);
      for k := n + 1 to p do
        c[k] := calculate(k, k - n, m, a, b);
    end;
  end {polyproduct};

  procedure bintopoly(n: integer; x: extended;
  var c: extvec);
  var
    k, i: integer;
    prod: extended;
  begin
    if x <> 0 then
    begin
      for k := 0 to n do
      begin
        prod := 1;
        for i := 0 to k - 1 do
          prod := prod * (n - i) / (k - i);
        if x > 0 then
          prod := prod * Exp((n - k) * Ln(x))
        else if x < 0 then
        begin
          prod := prod * Exp((n - k) * Ln(Abs(x)));
          if Odd(n - k) then
            prod := -prod;
        end;
        if Odd(k) then
          prod := -prod;
        c[k] := prod;
      end;
      if Odd(n) then
        for k := 0 to n do
          c[k] := -c[k];
    end
    else
    begin
      if Odd(n) then
        c[n] := -1
      else
        c[n] := 1;
      for k := 0 to n - 1 do
        c[k] := 0;
    end;
  end {bintopoly};
var
  i, j, l, p, q, sum: integer;
  diff, xii: extended;
  a, b, d, xi{, am1, am2, am3}: extvec;
  equal: boolean;
begin
  SetLength(a, 20);
  //SetLength(am1, 20); // z dedykacją
  //SetLength(am2, 20); // z dedykacją
  //SetLength(am3, 20); // z dedykacją
  SetLength(d, 20);
  SetLength(xi, 20);
  SetLength(b, 20);
  st := 0;
  if (n < 0) or (k < 0) then
    st := 1
  else
  begin
    if k > 0 then
    begin
      i := -1;
      repeat
        i := i + 1;
        for j := i + 1 to k do
          if x[i] = x[j] then
            st := 2
      until (i = k - 1) or (st = 2);
    end;
    if st <> 2 then
    begin
      i := -1;
      repeat
        i := i + 1;
        if (m[i] < 1) or (m[i] > 8) then
          st := 3
      until (i = k) or (st = 3);
      if st <> 3 then
      begin
        sum := 0;
        for i := 0 to k do
          sum := sum + m[i];
        if sum <> n + 1 then
          st := 4;
      end;
    end;
  end;
  if st = 0 then
  begin
    for i := 0 to k do
    begin
      if i = 0 then
        l := 0
      else
        l := l + m[i - 1];
      for j := l to l + m[i] - 1 do
      begin
        xi[j] := x[i];
        d[j] := f[l];
      end;
    end;
    for q := 1 to n do
    begin
      l := k;
      equal := False;
      for i := n downto q do
      begin
        xii := xi[i];
        if (q < 8) and (xi[i - q] = xii) then
        begin
          sum := 1;
          for j := 1 to q do
            sum := sum * j;
          if not equal then
          begin
            p := 0;
            for j := k downto l do
              p := p + m[j];
            p := n + 1 - p + q;
            equal := True;
          end;
          d[i] := f[p] / sum;
        end
        else
        begin
          diff := xii - xi[i - q];
          if (q = 1) or (xii <> xi[i - 1])
          then
          begin
            l := l - 1;
            equal := False;
          end;
          d[i] := (d[i] - d[i - 1]) / diff;
        end;
      end;
    end;
    for i := 0 to n do
    begin
      f[i] := 0;
      a[i] := 0;
    end;
    q := m[0];
    a[0] := d[q - 1];
    b[0] := -x[0];
    b[1] := 1;
    p := 0;
    for j := q - 2 downto 0 do
    begin
      polyproduct(q - j - 2, 1, a, b, p, xi);
      for l := 0 to p do
        a[l] := xi[l];
      a[0] := a[0] + d[j];
    end;
    for i := 0 to p do
      f[i] := a[i];
    if k > 0 then
    begin
      for i := 0 to p do
        a[i] := 0;
      sum := q;
      for i := 1 to k - 1 do
        sum := sum + m[i];
      a[0] := d[sum];
      q := 0;
      for i := k - 1 downto 1 do
      begin
        bintopoly(m[i], x[i], b);
        polyproduct(q, m[i], a, b, p, xi);
        for l := 0 to p do
          a[l] := xi[l];
        sum := sum - m[i];
        a[0] := a[0] + d[sum];
        q := p;
      end;
      bintopoly(m[0], x[0], b);
      polyproduct(q, m[0], a, b, p, a);
      //a := am1;
      for i := 0 to p do
        f[i] := f[i] + a[i];
      for i := 1 to k do
        if m[i] > 1 then
        begin
          q := m[i];
          sum := m[0];
          for j := 1 to i - 1 do
            sum := sum + m[j];
          a[0] := d[sum + q - 1];
          b[0] := -x[i];
          b[1] := 1;
          p := 0;
          for j := q - 2 downto 1 do
          begin
            polyproduct(q - j - 2, 1, a, b, p, xi);
            for l := 0 to p do
              a[l] := xi[l];
            a[0] := a[0] + d[sum + j];
          end;
          polyproduct(p, 1, a, b, p, a);
          //a := am2;
          for j := 0 to i - 1 do
          begin
            bintopoly(m[j], x[j], b);
            polyproduct(p, m[j], a, b, p, a);
            //a := am3;
          end;
          for l := 0 to p do
            f[l] := f[l] + a[l];
        end;
    end;
  end;
  a := nil;
  b := nil;
  d := nil;
  xi := nil;
end;

end.
