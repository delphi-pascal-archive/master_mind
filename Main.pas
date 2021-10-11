unit Main;
{ MASTERMIND
  by f0xi

  v1.2 - 24/07/2006
  v1.1 - 23/07/2006
  v1.0 - 22/07/2006
  v0.0 - 08/05/2006
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls,
{ ----------------- }
  MasterMindEngine, Math, PNGImage, JPeg, ResPack;
{ ----------------- }

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Parties1: TMenuItem;
    MenuNewGame1: TMenuItem;
    Standar6plots12chances1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    PaintBox1: TPaintBox;
    MenuEndGame1: TMenuItem;
    Plot1: TImage;
    Plot2: TImage;
    Plot3: TImage;
    Plot4: TImage;
    Plot5: TImage;
    Plot6: TImage;
    Plot7: TImage;
    Plot8: TImage;
    Plot9: TImage;
    Plot10: TImage;
    Baby1: TMenuItem;
    SuperMasterMind1: TMenuItem;
    Options1: TMenuItem;
    Combinaisonsecrete1: TMenuItem;
    MNUDoublons: TMenuItem;
    Fonddecran1: TMenuItem;
    Fond11: TMenuItem;
    Fond21: TMenuItem;
    Fond31: TMenuItem;
    Fond41: TMenuItem;
    Timer1: TTimer;
    Simple1: TMenuItem;
    riple1: TMenuItem;
    Quadruple1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Standar6plots12chances1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure MenuEndGame1Click(Sender: TObject);
    procedure Parties1Click(Sender: TObject);
    procedure Plot1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Plot1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Plot1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Baby1Click(Sender: TObject);
    procedure SuperMasterMind1Click(Sender: TObject);
    procedure Fond41Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Quitter1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Simple1Click(Sender: TObject);
  private
  public
    { Gestionnaires d'evenements pour MasterMindEngine }
    procedure DoCheck(Sender : TObject; const Solve,Check : TMMEStr; const win : boolean);
    procedure DoWin(Sender : TObject);
    procedure DoLose(Sender : TObject);
    procedure DoNewGame(Sender : TObject);
    procedure DoEndGame(Sender : TObject);
  end;


var
  Form1    : TForm1;

implementation

{$R *.dfm}

{ ------------------------------------------------------------------------------------------------ }
{ VARIABLES -------------------------------------------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

var
  AppDir      : string;

  { graphismes }

  { gestion des dessins }
  DrawWin     : boolean = false;
  DrawLose    : boolean = false;
  CurBkgnd    : integer = 0;

  { gestion des animations }
  ANMA        : integer = 180;
  ANMY        : integer = 0;

  { MasterMindEngine }
  MME         : TMasterMindEngine = nil;

  { gestion du jeux }
  PlayedSolve : TMMEStr;
  ButtonState : integer = 3;
  Score       : integer = 0;
  CombiMode   : integer = 1;
  
{ ------------------------------------------------------------------------------------------------ }
{ CREATION/CHARGEMENT/LIBERATION ----------------------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

procedure TForm1.FormCreate(Sender: TObject);
begin
  { init du generateur de nombre aleatoire }
  randomize;

  { recuperation du repertoire de l'appli }
  AppDir       := ExtractFilePath(Application.ExeName);

  { assignation des objets Timage Plot* a un tableau pour faciliter les chargements }
  DADPlots[1]  := Plot1;
  DADPlots[2]  := Plot2;
  DADPlots[3]  := Plot3;
  DADPlots[4]  := Plot4;
  DADPlots[5]  := Plot5;
  DADPlots[6]  := Plot6;
  DADPlots[7]  := Plot7;
  DADPlots[8]  := Plot8;
  DADPlots[9]  := Plot9;
  DADPlots[10] := Plot10;

  { Chargement des ressources graphiques }
  ResPack.ResPackLoad(AppDir+'GFXPack.rpk');

  CurBkgnd      := RandomRange(0,4);

  { creation du moteur MasterMind }
  MME           := TMasterMindEngine.Create(self);

  { assignation des gestionnaires d'evenements }
  MME.OnCheck   := DoCheck;
  MME.OnWin     := DoWin;
  MME.OnLose    := DoLose;
  MME.OnNewGame := DoNewGame;
  MME.OnEndGame := DoEndGame;

  { double buffer de la fiche principal pour eviter le scintillement des refresh }
  Form1.DoubleBuffered := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  { liberation des objets }
  ResPack.ResPackFree;
  MME.Free;
end;

{ ------------------------------------------------------------------------------------------------ }
{ GESTIONNAIRES DES EVENEMENTS DU MOTEUR DU JEUX ------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

procedure TForm1.DoCheck(Sender : TObject; const Solve,Check : TMMEStr; const win : boolean);
var I, SCM, SCB : integer;
begin
  { on remet les bonnes positions dans la combinaison qu'on vas jouer }
  for i := 1 to MME.MaxPlots do
      if Check[i] <> '1' then PlayedSolve[i] := '?';

  { Calcul des points ----- }
  SCB := 200 * MME.MaxPlots;

  if MNUDoublons.Checked then
     { on gagne plus de points si on utilise les doublons dans la combinaison secrete
       on en perd egalement plus aussi }
     SCB := SCB * 2;

  SCM := SCB;
  SCM := SCM - ((round(SCB/100)*10) * (MME.MaxSolves-MME.SolvesLeft));
  SCM := SCM - ((round(SCB/100)*10) * (CountChar('0',Check) * (MME.MaxSolves-MME.SolvesLeft+1)));
  SCM := SCM - ((round(SCB/100)*5) * CountChar('2',Check));
  SCM := SCM + ((round(SCB/100)*MME.SolvesLeft) * (CountChar('1',Check)+CombiMode));

  { on evite les scores negatif ... meme si ça pourrait etre amusant }
  Score := Max(0,Score+SCM);

  { on rafraichis l'affichage }
  paintbox1.Refresh;
end;

procedure TForm1.DoWin(Sender : TObject);
begin
  DrawWin         := true;
  Timer1.Interval := 45;
  PaintBox1.Refresh;
end;

procedure TForm1.DoLose(Sender : TObject);
begin
  DrawLose        := true;
  Timer1.Interval := 90;
  PaintBox1.Refresh;
end;

procedure TForm1.DoNewGame(Sender : TObject);
begin
  Timer1.Enabled := false;
  ANMA           := 180;
  ANMY           := 0;
  DrawWin        := false;
  DrawLose       := false;
  PlayedSolve    := DupeChar('?',MME.MaxPlots);
  Score          := 0;
  PaintBox1.Refresh;
end;

procedure TForm1.DoEndGame(Sender : TObject);
begin
//
end;

{ ------------------------------------------------------------------------------------------------ }
{ GESTION DU BOUTON "OK" / SUBMIT PLAYEDSOLVE ---------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

{
  le boutton OK etant affiché grace a 3 images, il faut donc géré trois etat :
   Normal (         )  buttonstate = 3
   Over   (MouseMove)  buttonstate = 4
   Press  (MouseDown)  buttonstate = 5
}

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  { si aucune partie en cours on sort }
  if not MME.IsInGame then exit;

  { si le boutton gauche de la souris n'est pas enfoncé }
  if not (ssLeft in Shift) then begin

     { si le curseur de souris et dans la zone du boutton }
     if inrange(X,PaintBox1.Width-112,PaintBox1.Width-18) and
        inrange(Y,PaintBox1.Height-71,PaintBox1.Height-21) then
        { on change l'etat 4 (Over) }
        ButtonState := 4
     else
        { sinon on reviens a l'etat 3 (Normal) }
        ButtonState := 3;

     { on rafraichis l'affichage }
     PaintBox1.Refresh;
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { si aucune partie en cours on sort }
  if not MME.IsInGame then exit;

  { si le boutton gauche de la souris et préssée et que l'etat du boutton est a 4 (Over) }
  if (ssLeft in Shift) and (ButtonState = 4) then begin
     { on change pour l'etat 5 (Press) }
     ButtonState := 5;

     { on rafraichis l'affichage }
     PaintBox1.Refresh;
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { si aucune partie en cours on sort }
  if not MME.IsInGame then exit;

  { si on relache dans la zone du boutton et que l'etat est a 5 (Press) }
  if inrange(X,PaintBox1.Width-112,PaintBox1.Width-18) and
     inrange(Y,PaintBox1.Height-71,PaintBox1.Height-21) and
     (buttonstate = 5) then begin

     { on reviens a l'etat 3 (Normal) }
     ButtonState := 3;

     { on valide la combinaison courrante }
     MME.SubmitSolve(PlayedSolve);
  end;
end;

{ ------------------------------------------------------------------------------------------------ }
{ DESSIN DU PLATEAU ------------------------------------------------------------------------------ }
{ ------------------------------------------------------------------------------------------------ }
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  { ce timer ne sert qu'a animer le texte quand on gagne ou perd }
  PaintBox1.Refresh;
end;

procedure DrawCombi(X,Y : integer; combi : TMMEStr; Canvas : TCanvas; mode : byte);
var I,P : integer;
begin
  { transforme les chaines Solves et Checks en dessin }
  with Canvas do begin
  for i := 1 to MME.MaxPlots do begin
      { zone secrete non affichée }
      if mode = 0 then begin
         draw(x+(36*(i-1)),y,GFXPLots[-1]);
      end else
      { combinaisons (Solve, Solves[n], Secret, PlayedSolve) }
      if mode = 1 then begin
         p := pos(Combi[i],MME.PlotStr);
         { affichage des trous}
         if p = 0 then
            draw(x+(36*(i-1))+2,y+2,GFXPLots[p])
         { affichage des pionts }
         else
            draw(x+(36*(i-1)),y,GFXPLots[p]);
      end else
      { verifications (checks, check) }
      if mode = 2 then begin
         p := pos(Combi[i],MME.CheckStr);
         if Combi[i] <> '?' then
            draw(x+(36*(i-1))+16,y,GFXChecks[p]);
      end;
  end;
  end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var GX,GY,I,ID,CX,PLW,SLW: integer;
    Buffer : TBitmap;
begin
  { creation du buffer }
  Buffer := TBitmap.Create;
  Buffer.PixelFormat := pf24bit;
  Buffer.Width := PaintBox1.Width;
  Buffer.Height:= PaintBox1.Height;

  { Animation Win/Lose ------------------- }
  if Timer1.Enabled then begin

     with Buffer.Canvas do begin
          { dessin du fond pour l'animation }
          Draw(0,0,GFXAnimBuff);

          { Congrats jump effect }
          if DrawWin then begin
             ANMY := round( 20 * sin(DegToRad(ANMA)) );
             Draw((PaintBox1.Width div 2)-160, ((PaintBox1.height div 2)-100)+ANMY, GFXYouWin);
             ANMA := ANMA + 10;
             if ANMA >= 360 then ANMA := 180;
          end else

          { Death shame effect }
          if DrawLose then begin
             Draw(
                 RandomRange((PaintBox1.Width div 2)-10,(PaintBox1.width div 2)+10)-160,
                 RandomRange((PaintBox1.height div 2)-10,(PaintBox1.height div 2)+10)-100,
                 GFXYouLose
                 );
          end;
     end;

     { dessin dans PaintBox }
     PaintBox1.Canvas.Draw(0,0,Buffer);

     { liberation du buffer }
     Buffer.Free;

     { on sort de la procedure }
     exit;
  end;

  { Affichage normal -------------------- }
  PLW:= 36*MME.MaxPlots;
  SLW:= 36*MME.MaxSolves;
  CX := (PaintBox1.Width div 2) - ((PLW+10) div 2);

  with Buffer.Canvas do begin
       brush.Style := bsclear;

       { dessin du fond d'ecran, image 128x128 répétée }
       for gx := 0 to (PaintBox1.Width div 128)+1 do
           for gy := 0 to (PaintBox1.Width div 128)+1 do
               draw(128*gx,128*gy,GFXBckGnd[CurBkgnd]);

       { dessin du cadre de fond pour l'affichage des pionts }
       Draw((PaintBox1.Width div 2)-150,5,GFXTspGnd);

       { dessin de la zone secrete }
       if DrawWin or DrawLose then
          DrawCombi(CX,8,MME.Secrets,Buffer.Canvas,1)
       else begin
          DrawCombi(CX,8,'secret',Buffer.Canvas,0)
       end;

       { dessin des solutions et verifications }
       for i := MME.MaxSolves downto 1 do begin
           id := MME.MaxSolves - i;
           DrawCombi(CX,54+(36*id),MME.Solves[i],Buffer.Canvas,1);
           DrawCombi(CX,54+(36*id),MME.Checks[i],Buffer.Canvas,2);
       end;

       { dessin de la solution dernierement soumise }
       DrawCombi(CX,69+SLW,PlayedSolve,Buffer.Canvas,1);

       { dessin de l'interface }
       Draw(0,0,GFXInterfac[1]);
       Draw(0,PaintBox1.Height-GFXInterfac[2].Height,GFXInterfac[2]);

       { dessin du boutton "OK" }
       Draw(PaintBox1.Width-GFXInterfac[ButtonState].Width,
            PaintBox1.Height-GFXInterfac[ButtonState].Height,
            GFXInterfac[ButtonState]);

       { dessin du score et chances restantes }
       Font.Name := 'Arial';
       Font.Style:= [fsBold,fsItalic];
       Font.Size := 12;
       Font.Color:= clWhite;

       TextOut(5,5,'Score : ');
       TextOut(5,24,inttostr(Score));

       TextOut(5,50,'Chances : ');
       TextOut(5,69,inttostr(MME.SolvesLeft));

       { recuperation de l'image en cours pour accelerer les animation de fin }
       if DrawWin or DrawLose then begin
          GFXAnimBuff.Assign(Buffer);
          Timer1.Enabled := true;
       end;
  end;

  { dessin dans PaintBox }
  PaintBox1.Canvas.Draw(0,0,Buffer);

  { liberation du buffer }
  Buffer.Free;
end;

{ ------------------------------------------------------------------------------------------------ }
{ DRAG AND DROP DES PIONTS ----------------------------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

var SenderBak : TObject = nil;
    SenderPos : TPoint;
    SenderID  : integer;
    MP        : TPoint;
    PlaceOrg  : TPoint;
    PosIndex  : integer;

procedure TForm1.Plot1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  { si pas de partie en cours on sort }
  if not MME.IsInGame then exit;

  if ssLeft in Shift then begin
     { on recupere la zone de drop pour les pionts }
     PlaceOrg.X   := ((PaintBox1.Width div 2) - (((36*MME.MaxPlots)+10) div 2)) +  PaintBox1.Left;
     PlaceOrg.Y   := 69+(36*MME.MaxSolves) + PaintBox1.Top;

     { on stock le sender }
     SenderBak := Sender;
     with (Sender as TImage) do begin
          { on viens en avant plan }
          BringToFront;
          { on recupere la position de depart }
          SenderPos := point(Left,Top);
          { on recuper le tag}
          SenderID  := Tag;
     end;
     { on recupere l'origine du click }
     MP := point(x,y);
  end;
end;

procedure TForm1.Plot1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  { si SenderBak est different de Nil }
  if assigned(SenderBak) then begin
     with (SenderBak as TImage) do begin
          { on reviens a la position de depart }
          Left := SenderPos.X;
          Top  := SenderPos.Y;

          { si le piont a été placé dans la zone de drop }
          if PosIndex <> 0 then
             { on place le code du piont dans la combinaison a jouer }
             PlayedSolve[PosIndex] := MME.PlotStr[SenderID];
     end;

     { on rafraichis l'affichage }
     Paintbox1.Refresh;
  end;

  { on remet le senderbak a Nil pour le prochain drop }
  SenderBak := nil;
  PosIndex  := 0;
end;

procedure TForm1.Plot1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i : integer;
begin
  { si SenderBak est different de Nil }
  if assigned(SenderBak) then begin
     with (SenderBak as TImage) do begin
          { on deplace le piont a la position de la souris }
          Left := Mouse.CursorPos.X - form1.ClientOrigin.X - MP.X;
          Top  := Mouse.CursorPos.Y - form1.ClientOrigin.Y - MP.Y;

          { on reset PosIndex a 0 }
          PosIndex := 0;

          { on cherche si la position du piont est dans l'une des cases de la zone de drop }
          for i := 0 to MME.MaxPlots-1 do
              { si tel est le cas }
              if inrange(Left+(width div 2),PlaceOrg.X+(36*i),PlaceOrg.X+(36*(i+1))) and
                 inrange(Top+(height div 2),PlaceOrg.Y,PlaceOrg.Y+36) then begin

                 { on applique un magnetisme a la zone de drop }
                 Left := PlaceOrg.X+(36*i);
                 Top  := PlaceOrg.Y;

                 { on recupere l'index pour la combinaison a jouer }
                 PosIndex := i+1;

                 { on rafraichis l'affichage }
                 PaintBox1.Refresh;
              end;
     end;
  end;
end;

{ ------------------------------------------------------------------------------------------------ }
{ CHOIX DE LA PARTIE ----------------------------------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

procedure TForm1.Parties1Click(Sender: TObject);
begin
  { activation / desactivation des menus selon les cas }
  MenuNewGame1.Enabled := not MME.IsInGame;
  MenuEndGame1.Enabled := MME.IsInGame;
end;

procedure TForm1.Options1Click(Sender: TObject);
begin
  { idem }
  MNUDoublons.Enabled := not MME.IsInGame;
end;


procedure TForm1.Baby1Click(Sender: TObject);
begin
  { BabyMind, 4 plots, 12 chances }
  MME.NewGame(4,12,CombiMode);
end;

procedure TForm1.Standar6plots12chances1Click(Sender: TObject);
begin
  { MasterMind, 6 plots, 12 chances }
  MME.NewGame(6,12,CombiMode);
end;

procedure TForm1.SuperMasterMind1Click(Sender: TObject);
begin
  { Super MasterMind, 8 plots, 12 chances }
  MME.NewGame(8,12,CombiMode);
end;

procedure TForm1.MenuEndGame1Click(Sender: TObject);
begin
  { abandon de la partie en cours }
  MME.EndGame;
end;

{ ------------------------------------------------------------------------------------------------ }
{ AUTRES ----------------------------------------------------------------------------------------- }
{ ------------------------------------------------------------------------------------------------ }

procedure TForm1.Fond41Click(Sender: TObject);
begin
  { choix manuel du fond d'ecran }
  CurBkgnd := (sender as TMenuItem).Tag;
  PaintBox1.Refresh;
end;

procedure TForm1.Quitter1Click(Sender: TObject);
begin
  { sortie du jeux }
  Form1.Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { fermeture de la fenetre }
  Timer1.Enabled := false;
  MME.EndGame;
end;

procedure TForm1.Simple1Click(Sender: TObject);
begin
  CombiMode := (Sender as TMenuItem).Tag;
end;

end.
