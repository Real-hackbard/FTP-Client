
unit FTP;
interface
uses Windows, Forms, WinInet, SysUtils, Grids, module, StdCtrls, Dialogs;
    function  GetCurrentDirectory( MyHandle: HINTERNET) : string;
    function Connexion( Handle : Hwnd; Serveur : string; Login : string; MotDePasse : string; Port : WORD ) : Boolean;
    procedure FermeConnexion;
    procedure ListerFichiers( tStringGrid : TStringGrid );
    procedure EntrerDansRepertoire( Repertoire : string );
    procedure UpLoadFile( FichierLocal : String; FichierFTP : String );
    procedure DownLoadFile( Fichier : String; NouveauFichier : String );
    procedure RemoveFile( FichierFTP : string );
    procedure RemoveDirectoryFTP( CheminFTP : string );
    procedure RenameFile ( Fichier : string );
    procedure CreateDirectoryFTP;
var
    PConnexionInternet: HINTERNET;
    PConnexionFTP     : HINTERNET;
    HandleMain        : HWND;
implementation
function GetCurrentDirectory( MyHandle: HINTERNET ) : string;
var
    LenS : Cardinal;
    S : string;
begin
    LenS := 0;
    ftpGetCurrentDirectory( MyHandle, PChar(S), LenS );
    SetLength(S, LenS);
    ftpGetCurrentDirectory( MyHandle, PChar(S), LenS );
    Result := Trim(S);
end;
function Connexion( Handle : Hwnd; Serveur : string; Login : string; MotDePasse : string; Port : WORD ) : Boolean;
var
    Temp : Boolean;
begin
    HandleMain := Handle;
    PConnexionInternet := InternetOpen( PChar('Tiny FTP'), INTERNET_OPEN_TYPE_DIRECT, nil, nil, 0 );
    if PConnexionInternet = nil then
    begin
        Temp := False;
        Exit;
    end;
    PConnexionFTP := InternetConnect( PConnexionInternet, Pchar(Serveur), Port, Pchar(Login), Pchar(MotDePasse), INTERNET_SERVICE_FTP, 0, 0 );
    if PConnexionFTP = nil then
    begin
        InternetCloseHandle( PConnexionInternet );
        Temp := False;
        Exit;
    end;
    Temp := True;
    Result := Temp;
end;
procedure ListerFichiers( tStringGrid : TStringGrid );
var
    STRUCT_DATA : _WIN32_FIND_DATAA;
    FoundFile   : Pointer;
    bFound      : Boolean;
    BeFolder    : boolean;
begin
    BeFolder := False;
    FoundFile := nil;
    bFound := False;
    if PConnexionFTP <> nil then
    begin
        CleanGrid( tStringGrid );
        tStringGrid.Cells[0, tStringGrid.RowCount-1] := '..';
        tStringGrid.Cells[1, tStringGrid.RowCount-1] := '---d----';
        tStringGrid.RowCount := tStringGrid.RowCount + 1;
        FoundFile := FtpFindFirstFile( PConnexionFTP, PChar('*.*'), STRUCT_DATA, 0, 0 );
        if FoundFile <> nil then
        repeat
            if (Trim(STRUCT_DATA.cFileName) <> '..') and (Trim(STRUCT_DATA.cFileName) <> '.') then
            begin
                if Trim(STRUCT_DATA.cFileName) <> '' then
                    tStringGrid.Cells[0, tStringGrid.RowCount-1] := STRUCT_DATA.cFileName
                else
                    tStringGrid.Cells[0, tStringGrid.RowCount-1] := STRUCT_DATA.cAlternateFileName;
                tStringGrid.Cells[1, tStringGrid.RowCount-1] := AttributeToStr( STRUCT_DATA.dwFileAttributes );
                tStringGrid.Cells[2, tStringGrid.RowCount-1] := SizeToStr( STRUCT_DATA.nFileSizeLow );
                tStringGrid.Cells[3, tStringGrid.RowCount-1] := DateTimeToStr( FileTimeToDateTime( STRUCT_DATA.ftLastWriteTime ) );
                tStringGrid.RowCount := tStringGrid.RowCount + 1;
            end;
                bFound := InternetFindNextFile( FoundFile, @STRUCT_DATA );
        until not bFound;
        InternetCloseHandle( FoundFile );
    end;
end;
procedure FermeConnexion;
begin
    InternetCloseHandle(PConnexionInternet);
    InternetCloseHandle(PConnexionFTP);
end;
procedure EntrerDansRepertoire( Repertoire : string );
var
    CheminCourant : string;
    Temp          : string;
    bSuccess      : LongBool;
begin
    CheminCourant := GetCurrentDirectory( PConnexionFTP );
    if (Repertoire = '..') then
        Temp := ExtractBeforeFolder( CheminCourant )
    else
        Temp := SlachFTP(CheminCourant) + Repertoire;
    bSuccess := FtpSetCurrentDirectory(PConnexionFTP, PChar(Temp));
    if not bSuccess then
    begin
        MessageBoxA( HandleMain, PChar( Format('Could not open %s.',[Temp])), PChar('Error'), 32 );
        Exit;
    end;
end;
procedure DownLoadFile( Fichier : String; NouveauFichier : String );
begin
    FtpGetFile( PConnexionFTP, PChar(Fichier), PChar(NouveauFichier), False, 0, FTP_TRANSFER_TYPE_BINARY, 0 );
end;
procedure UpLoadFile( FichierLocal : String; FichierFTP : String );
begin
    FtpPutFile( PConnexionFTP, PChar(FichierLocal), PChar(FichierFTP), FTP_TRANSFER_TYPE_BINARY, 0 );
end;
procedure RemoveFile( FichierFTP : string );
begin
    FtpDeleteFile( PConnexionFTP, PChar(FichierFTP) );
end;
procedure RemoveDirectoryFTP( CheminFTP : string );
begin
    FtpRemoveDirectory( PConnexionFTP, PChar(CheminFTP) );
end;
procedure RenameFile ( Fichier : string );
var
    NouveauNom : string;
begin
    NouveauNom := InputBox( 'Rename', 'New file name : ', '' );
    if Trim(NouveauNom) <> '' then FtpRenameFile( PConnexionFTP, PChar(Fichier), PChar(NouveauNom) );
end;
procedure CreateDirectoryFTP;
var
    NouveauChemin : string;
begin
    NouveauChemin := InputBox( 'Create', 'Name of folder to create : ', '' );
    if Trim(NouveauChemin) <> '' then FtpCreateDirectory( PConnexionFTP, PChar( NouveauChemin ) );
end;
end.

