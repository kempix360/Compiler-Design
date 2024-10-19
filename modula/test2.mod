(********************************************************)
(* Program displays ASCII codes                         *)
(* Compilation:                                         *)
(*   m2c -all test.mod -o test                          *)
(* Running:                                             *)
(*   ./test                                             *)
(********************************************************)
MODULE test;

FROM InOut IMPORT Write, WriteCard, WriteString, WriteLn;
CONST
  FromAscii = 32;
  ToAscii = 127;
VAR
  i : CARDINAL;
  fl : REAL;
BEGIN
  WriteString("ASCII "); WriteString("codes: ");
  WriteLn;
  FOR i := FromAscii TO ToAscii DO
    WriteCard(i, 3);
    Write(' ');
    Write(CHR(i));
    WriteLn
  END;
  fl := 1.1 + 1.0E-2 + 1.0E+2 + 1.0E1; (* real numbers *)
  IF (fl <= 11.11) AND (fl >= 1.111E1) THEN
    WriteString("As expected")
  ELSE
    WriteString("No way!")
  END;
  WriteLn;
  i := 1;
  WHILE i < 5 DO
       WriteLn(i); i := i + 1
  END;
  REPEAT
       WriteLn(i); i := i - 1
  UNTIL i = 1;
  LOOP *) (* closing a comment without opening it *)
       WriteLn("Spam")
  END;
  CASE CHR(FromAscii+16) OF
       '0': WriteLn("Aha!")
     | 'A','a': Writeln("Yes?")
  ELSE (* This comment is unfinished
       Writeln("O!")
  END
END test.
