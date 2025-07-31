

unit Unit1;
interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, Buttons, Grids, StdCtrls, module,
     ExtCtrls, FTP, Menus, ComCtrls, XPMan;
type TForm1 = class(TForm)
    GroupLogon: TGroupBox;
    EditFTP: TEdit;
    EditLogin: TEdit;
    EditMdp: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Grille: TStringGrid;
    BtnConnect: TSpeedButton;
    BtnQuit: TSpeedButton;
    PopupMenuFTP: TPopupMenu;
    Ouvrir1: TMenuItem;
    Telecharger: TMenuItem;
    Effacer1: TMenuItem;
    Renommer1: TMenuItem;
    Credossier1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Annuler1: TMenuItem;
    Status: TStatusBar;
    SaveDialog: TSaveDialog;
    BtnDownLoad: TSpeedButton;
    BtnUpload: TSpeedButton;
    OpenDialog: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    EditPort: TEdit;
    Label4: TLabel;
    procedure BtnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnQuitClick(Sender: TObject);
    procedure Ouvrir1Click(Sender: TObject);
    procedure TelechargerClick(Sender: TObject);
    procedure BtnUploadClick(Sender: TObject);
    procedure Effacer1Click(Sender: TObject);
    procedure GrilleDblClick(Sender: TObject);
    procedure Renommer1Click(Sender: TObject);
    procedure Credossier1Click(Sender: TObject);
    procedure EditPortKeyPress(Sender: TObject; var Key: Char);
public
    function IsDossier : Boolean;
end;
const
    TXT_DECONNECT = 'Deconnection';
    TXT_CONNECT = 'Connection';
var
   Form1 : TForm1;
   IsConnected : Boolean;

const
   TitresGrille : Array[1..4] of string = ('Name:', 'Attributes:', 'Size:', 'Date');

implementation
{$R *.dfm}
procedure TForm1.BtnConnectClick(Sender: TObject);
begin
    if ( Trim(EditFTP.Text) = '' ) then
    begin
        MessageBoxA( Handle, PChar('Please enter an FTP server !'), PChar('Server ?'), MB_ICONEXCLAMATION );
        Exit;
    end;
    if ( Trim(EditPort.Text) = '' ) then
    begin
        MessageBoxA( Handle, PChar('Enter a communication port (21 by default)!'), PChar('Port ?'), MB_ICONEXCLAMATION );
        Exit;
    end;
    if BtnConnect.Caption = TXT_CONNECT then
    begin
        if Connexion( Self.Handle, EditFTP.Text, EditLogin.Text, EditMDP.Text, StrToInt(EditPort.Text) ) = True then
        begin
            ListerFichiers( Grille );
            EditFTP.Enabled := False;
            EditLogin.Enabled := False;
            EditMdp.Enabled := False;
            BtnConnect.Caption := TXT_DECONNECT;
            IsConnected := True;
        end else
            MessageBoxA( Handle, Pchar( 'Connection impossible !' ), PChar('Error'), MB_ICONWARNING );
    end else
    begin
        CleanGrid ( Grille );
        FermeConnexion;
        EditFTP.Enabled := True;
        EditLogin.Enabled := True;
        EditMdp.Enabled := True;
        BtnConnect.Caption := TXT_CONNECT;
        IsConnected := False;
    end;
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
    EnteteGrille( Grille, TitresGrille );
    IsConnected := False;
    BtnConnect.Caption := TXT_CONNECT;
end;
procedure TForm1.BtnQuitClick(Sender: TObject);
begin
    Application.Terminate;
end;
procedure TForm1.GrilleDblClick(Sender: TObject);
begin
    if ( Trim(Grille.Cells[1, Grille.selection.Top]) = '' ) then
    begin
        MessageBoxA( Self.Handle, PChar('Select a valid line'), PChar('Error'), 32);
        Exit;
    end;
    if IsDossier then Ouvrir1.Click else Telecharger.Click;
end;
procedure TForm1.Ouvrir1Click(Sender: TObject);
var
    repertoire : string;
begin
    if IsDossier = False then
    begin
        MessageBoxA( Self.Handle, PChar('You can only open folders'), PChar('Error'), 32);
        Exit;
    end;
    repertoire := Grille.Cells[0, Grille.selection.Top];
    EntrerDansRepertoire( Repertoire );
    ListerFichiers( Grille );
end;
procedure TForm1.TelechargerClick(Sender: TObject);
var
    Fichier : string;
    NouveauFichier : string;
begin
    if IsConnected = False then
    begin
        MessageBoxA( Self.Handle, PChar('Log in before using this feature !'), PChar('Connect ?'), MB_ICONEXCLAMATION);
        Exit;
    end;
    if IsDossier then
    begin
        MessageBoxA( Self.Handle, PChar('You can only upload files'), PChar('Error'), 32);
        Exit;
    end;
    Fichier := Grille.Cells[0, Grille.selection.Top];
    SaveDialog.FileName := Fichier;
    if SaveDialog.Execute then
    begin
        SaveDialog.Title := 'Download';
        NouveauFichier := SaveDialog.FileName;
        DownLoadFile( Fichier, NouveauFichier );
    end;
end;
procedure TForm1.BtnUploadClick(Sender: TObject);
var
    Fichier : string;
begin
    if IsConnected = False then
    begin
        MessageBoxA( Self.Handle, PChar('Log in before using this feature !'), PChar('Connect ?'), MB_ICONEXCLAMATION);
        Exit;
    end;
    if OpenDialog.Execute then
    begin
        OpenDialog.Title := 'Uploader';
        Fichier := OpenDialog.FileName;
        UpLoadFile( Fichier, ExtractFileName(Fichier) );
        ListerFichiers( Grille );
    end;
end;
procedure TForm1.Effacer1Click(Sender: TObject);
begin
    if IsConnected = False then
    begin
        MessageBoxA( Self.Handle, PChar('Log in before using this feature !'), PChar('Connect ?'), MB_ICONEXCLAMATION);
        Exit;
    end;
    if IsDossier then
        RemoveDirectoryFTP( Grille.Cells[0, Grille.selection.Top] )
    else
        RemoveFile( Grille.Cells[0, Grille.selection.Top] );
    ListerFichiers( Grille );
end;
procedure TForm1.Renommer1Click(Sender: TObject);
begin
    if IsConnected = False then
    begin
        MessageBoxA( Self.Handle, PChar('Log in before using this feature !'), PChar('Connect ?'), MB_ICONEXCLAMATION);
        Exit;
    end;
    RenameFile( Grille.Cells[0, Grille.selection.Top] );
    ListerFichiers( Grille );
end;
procedure TForm1.Credossier1Click(Sender: TObject);
begin
    if IsConnected = False then
    begin
        MessageBoxA( Self.Handle, PChar('Log in before using this feature !'), PChar('Connect ?'), MB_ICONEXCLAMATION);
        Exit;
    end;
    CreateDirectoryFTP;
    ListerFichiers( Grille );
end;
function TForm1.IsDossier : Boolean;
var
    ChaineAttr : Array [0..8] of Char;
begin
    StrPCopy(ChaineAttr, Grille.Cells[1, Grille.selection.Top]);
    if ChaineAttr[3] = 'd' then result := True else result := False;
end;
procedure TForm1.EditPortKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in [#8, #13, '0'..'9']) then Key := #0;
end;
end.

