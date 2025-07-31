
unit module;

interface

uses Windows, Messages, SysUtils, Classes, Dialogs, StrUtils, Grids;

    function  slach( chemin : string ) : string;
    function  SizeToStr(Size: Integer): string;
    function  slachFTP( chemin : string ) : string;
    procedure CleanGrid ( GrilleANettoyer : TStringGrid );
    function  AttributeToStr( Attrib : Cardinal ) : string;
    function  FileTimeToDateTime(FileTime: TFileTime): TDateTime;
    function  ExtractBeforeFolder( Repertoire : string ) : string;
    procedure EnteteGrille( Tableau : TStringGrid; Titres : Array of string );

implementation

function slach( chemin : string ) : string;
begin
    if rightstr( chemin, 1 ) <> '\' then result := trim(chemin) + '\' else result := trim(chemin);
end;

function slachFTP( Chemin : string ) : string;
begin
    if rightstr( chemin, 1 ) <> '/' then result := trim(chemin) + '/' else result := trim(chemin);
end;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
    LocalFileTime: TFileTime;
    SystemTime: TSystemTime;
begin
    FileTimeToLocalFileTime(FileTime, LocalFileTime);
    FileTimeToSystemTime(LocalFileTime, SystemTime);
    Result := SystemTimeToDateTime(SystemTime);
end;
function ExtractBeforeFolder( Repertoire : string ) : string;
var
    PositionSlach : Integer;
    i : Integer;
begin
    PositionSlach := 0;
    For i := 1 to Length( Repertoire ) do
        if Copy ( Repertoire, i, 1 ) = '/' then PositionSlach := i;
    Result := Copy( Repertoire, 1, PositionSlach );
end;
procedure EnteteGrille( Tableau : TStringGrid; Titres : Array of string );
var
    X : Integer;
begin
    Tableau.ColCount := High(Titres) + 1;
    for X := Low(Titres) to High(Titres) do
    begin
        Tableau.Cells[X, 0]:= Titres[X];
    end;
end;
procedure CleanGrid ( GrilleANettoyer : TStringGrid );
var
    x : integer;
begin
        for x := 1 to GrilleANettoyer.RowCount - 1 do
            GrilleANettoyer.Rows[x].Clear;
    GrilleANettoyer.RowCount  := 2;
    GrilleANettoyer.FixedRows := 1;
end;
function SizeToStr(Size: Integer): string;
begin
    if Size >= $F4240 then
        Result := Format('%.2f', [Size / $F4240]) + ' Mo'
    else
    if Size < 1000 then
        Result := IntToStr(Size) + ' oc.'
    else
        Result := Format('%.2f', [Size / 1000]) + ' Ko';
end;
function AttributeToStr( Attrib : Cardinal ) : string;
var
    Chaine : Array [0..8] of Char;
begin
    if (Attrib and FILE_ATTRIBUTE_READONLY  ) = FILE_ATTRIBUTE_READONLY   then Chaine[0] := 'r' else Chaine[0] := '-';
    if (Attrib and FILE_ATTRIBUTE_HIDDEN    ) = FILE_ATTRIBUTE_HIDDEN     then Chaine[1] := 'h' else Chaine[1] := '-';
    if (Attrib and FILE_ATTRIBUTE_SYSTEM    ) = FILE_ATTRIBUTE_SYSTEM     then Chaine[2] := 's' else Chaine[2] := '-';
    if (Attrib and FILE_ATTRIBUTE_DIRECTORY ) = FILE_ATTRIBUTE_DIRECTORY  then Chaine[3] := 'd' else Chaine[3] := '-';
    if (Attrib and FILE_ATTRIBUTE_ARCHIVE   ) = FILE_ATTRIBUTE_ARCHIVE    then Chaine[4] := 'a' else Chaine[4] := '-';
    if (Attrib and FILE_ATTRIBUTE_NORMAL    ) = FILE_ATTRIBUTE_NORMAL     then Chaine[5] := 'n' else Chaine[5] := '-';
    if (Attrib and FILE_ATTRIBUTE_COMPRESSED) = FILE_ATTRIBUTE_COMPRESSED then Chaine[6] := 'c' else Chaine[6] := '-';
    if (Attrib and FILE_ATTRIBUTE_TEMPORARY ) = FILE_ATTRIBUTE_TEMPORARY  then Chaine[7] := 't' else Chaine[7] := '-';
    Chaine[8] := #0;
    result := Chaine;
end;
end.

