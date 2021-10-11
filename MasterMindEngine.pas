unit MasterMindEngine;

{ MASTER MIND ENGINE -----------------------------------------------------------------------------
  by f0xi
  22/07/2006 - 24/07/2006

  version 1.4

 Utilisation -------------------------------------------------------------------------------------
   nouvelle partie :
     TMasterMindEngine.NewGame( longeur des combinaisons 4..8,
                                nombre de coups 10..20,
                                mode des combinaisons : 1 simple, 2 double, 3 triple ect...
                              );

   abandon de la partie :
     TMasterMindEngine.EndGame;

   soumettre une combinaison :
     TMasterMindEngine.SubmitSolve(combinaison TMMEStr 4..8);

   regler le nombre de plots et leur lettre d'identification (A..Z) :
     TMasterMindEngine.PlotStr := 'ABCDEFGHIJ';
     Appelez EndGame avant la modification et NewGame aprés modification 

   lecture des parametres (propriétés en lecture seule) :
     combinaison secrete  : TMasterMindEngine.Secrets;
     solutions jouées     : TMasterMindEngine.Solves[index];
     verifications        : TMasterMindEngine.Checks[index];
     nbr de coups a jouer : TMasterMindEngine.SolvesLeft;
     nbr de coups max     : TMasterMindEngine.MaxSolves;
     longeur des combi.   : TMasterMindEngine.MaxPlots;


 Evenements --------------------------------------------------------------------------------------
   TMasterMindEngine.OnCheck
      SubmitSolve();
      cet evenement est declanché aprés chaque appel a SubmitSolve();
      utilisez le pour rafraichir votre interface graphique (plateau de jeux)

   TMasterMindEngine.OnWin
      SubmitSolve();
      cet evenement est declanché si la combinaison secrete est resolue
      utilisez le pour transmettre au joueur le fait qu'il a reussi la partie

   TMasterMindEngine.OnLose
      SubmitSolve();
      cet evenement est declanché si la combinaison secrete n'a pas étée resolue
      utilisez le pour transmettre au joueur le fait qu'il a perdus

   TMasterMindEngine.OnNewGame
      NewGame();
      cet evenement est declanché aprés l'appel a la procedure NewGame.
      utilisez le pour initialisé les parametres du plateau de jeux, scores, variables ect...
         
   TMasterMindEngine.OnEndGame
      SubmitSolve(); EndGame();
      cet evenement est declanché quand il n'y a plus de coups a jouer ou quand la partie est gagnée
      utilisez le pour afficher la combinaison secrete qu'il fallait trouver

 ------------------------------------------------------------------------------------------------- }

interface
uses windows, sysutils, classes;

type
  TMMEStr = string[8];
  TMMEStrArray = array[1..20] of TMMEStr;

  TMMECheckEvent = procedure(Sender : TObject; const Solve,Check : TMMEStr; const Win : boolean) of object;

  TMasterMindEngine = class(TComponent)
  private
     fSecret     : TMMEStr;
     fSolves     : TMMEStrArray;
     fChecks     : TMMEStrArray;
     fSolvesLeft : integer;
     fMaxPlots   : byte;
     fMaxSolves  : byte;
     fPLotStr    : string;
     fCheckStr   : string;
     fInGame     : boolean;
     fOnCheck    : TMMECheckEvent;
     fOnWin      : TNotifyEvent;
     fOnLose     : TNotifyEvent;
     fOnNewGame  : TNotifyEvent;
     fOnEndGame  : TNotifyEvent;
     function GetMMESTR(index, mode : integer) : TMMEStr;
     procedure ResetArray;
  public
     constructor Create(AOwner : TComponent); override;
     property Secrets    : TMMEStr     read fSecret;
     property Solves[index : integer] : TMMEStr index 0 read GetMMESTR;
     property Checks[index : integer] : TMMEStr index 1 read GetMMESTR;
     property SolvesLeft : integer     read fSolvesLeft;
     property MaxSolves  : byte        read fMaxSolves;
     property MaxPlots   : byte        read fMaxPlots;
     procedure NewGame(const AMaxPlots, AMaxSolves, CombinaisonMode : byte);
     procedure EndGame;
     procedure SubmitSolve(const Solve : TMMEStr);
     function IsInGame : boolean;
  published
     property PlotStr    : string         read fPlotStr;
     property CheckStr   : string         read fCheckStr;
     property OnCheck    : TMMECheckEvent read fOnCheck    write fOnCheck;
     property OnWin      : TNotifyEvent   read fOnWin      write fOnWin;
     property OnLose     : TNotifyEvent   read fOnLose     write fOnLose;
     property OnNewGame  : TNotifyEvent   read fOnNewGame  write fOnNewGame;
     property OnEndGame  : TNotifyEvent   read fOnEndGame  write fOnEndGame;
  end;

function DupeChar(const AChar: Char; ACount: Integer): string;
function CountChar(const AChar : char; const S : string) : integer;

implementation

uses math;

function DupeChar(const AChar: Char; ACount: Integer): string;
var i : integer;
begin
  SetLength(Result, ACount);
  for i := 1 to ACount do result[i] := AChar;
end;

function CountChar(const AChar : char; const S : string) : integer;
var i : integer;
begin
  result := 0;
  for i := 1 to length(s) do
      if AChar = S[i] then inc(result);
end;

constructor TMasterMindEngine.Create(AOwner : TComponent);
begin
  inherited create(AOwner);
  fInGame     := false;
  fPlotStr    := 'ABCDEFGHIJ';
  fCheckStr   := '12';
  fSolvesLeft := 0;
  fSecret     := '??????';
  fMaxPlots   := 6;
  fMaxSolves  := 12;
  ResetArray;
end;

procedure TMasterMindEngine.ResetArray;
var Dc : TMMEStr;
    i  : integer;
begin
  Dc := DupeChar('?',fMaxPlots);
  for i := 1 to high(fSolves) do begin
      fSolves[i] := Dc;
      fChecks[i] := Dc;
  end;
end;

procedure TMasterMindEngine.NewGame(const AMaxPlots, AMaxSolves, CombinaisonMode : byte);
var i : integer;
    r : Char;
begin
  if fInGame then exit;
  fInGame     := true;
  fMaxPlots   := AMaxPlots;
  fMaxSolves  := 12;

  fSolvesLeft := AMaxSolves;

  SetLength(fSecret,fMaxPlots);
  Randomize;
  for i := RandomRange(1,11) to RandomRange(20,31) do Random(666);
  for i := 1 to fMaxPlots do begin
      r := PlotStr[randomrange(1,Length(PlotStr)+1)];
      if CombinaisonMode > 1 then begin
         while (pos(r,fSecret) <> 0) and (countChar(r,fSecret) = CombinaisonMode) do
               r := PlotStr[randomrange(1,Length(PlotStr)+1)];
      end else
         while (pos(r,fSecret) <> 0) do
               r := PlotStr[randomrange(1,Length(PlotStr)+1)];
      fSecret[i] := r;
  end;

  ResetArray;
  if assigned(fOnNewGame) then fOnNewGame(self);
end;

procedure TMasterMindEngine.EndGame;
begin
  if not fInGame then exit;
  fInGame := false;
  if assigned(fOnEndGame) then fOnEndGame(self);
end;

function TMasterMindEngine.GetMMESTR(index, mode : integer) : TMMEStr;
begin
  case Mode of
    0 : result := fSolves[index];
    1 : result := fChecks[index];
  end;
end;

procedure TMasterMindEngine.SubmitSolve(const Solve : TMMEStr);
var i,idx : integer;
    win   : boolean;
    schk  : string;
begin
  if not fInGame then exit;
  if pos('?',Solve) <> 0 then exit;
  if length(Solve) <> Self.MaxPlots then exit;

  if fSolvesLeft = 0 then EndGame;

  win := true;
  dec(fSolvesLeft);
  idx := fMaxSolves - fSolvesLeft;
  fSolves[idx] := Solve;
  schk := '';
  fChecks[idx] := dupechar('0',fMaxPlots);

  for i := 1 to fMaxPlots do
      if Solve[i] = fSecret[i] then begin
         fChecks[idx][i] := '1';
         schk := schk + Solve[i];
      end;

  for i := 1 to fMaxPlots do
      if Solve[i] = fSecret[i] then begin
         fChecks[idx][i] := '1';
      end else
      if pos(Solve[i],fsecret) <> 0 then begin
         if countchar(solve[i],fsecret) > countchar(solve[i],schk) then begin
            fChecks[idx][i] := '2';
            schk := schk + solve[i];
         end;
      end;

  for i := 1 to fMaxPlots do
      win := win and (fChecks[idx][i] = '1');

  if assigned(fOnCheck) then fOnCheck(self,fSolves[idx],fChecks[idx], Win);

  if win then begin
     fSolvesLeft := 0;
     if assigned(fOnWin) then fOnWin(self);
  end;

  if (fSolvesLeft = 0) then begin
     if (not Win) and assigned(fOnLose) then fOnLose(self);
     if assigned(fOnEndGame) then fOnEndGame(self);
     fInGame := false;
  end;
end;

function TMasterMindEngine.IsInGame : boolean;
begin
  result := fInGame;
end;

end.
 