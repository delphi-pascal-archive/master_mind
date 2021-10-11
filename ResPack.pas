unit ResPack;

interface

uses Windows, SysUtils, Classes, Graphics, ExtCtrls, JPEG, PNGImage, math;

var
  GFXPlots    : array[-1..10] of TPNGObject = (nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil);
  GFXChecks   : array[0..2]   of TPNGObject = (nil,nil,nil);
  GFXCDR      : array[1..3]   of TPNGObject = (nil,nil,nil);
  GFXInterfac : array[1..5]   of TPNGObject = (nil,nil,nil,nil,nil);

  GFXTspGnd   : TPNGObject = nil;
  GFXYouWin   : TPNGObject = nil;
  GFXYouLose  : TPNGObject = nil;
  GFXBckGnd   : array[0..3] of TJPegImage = (nil,nil,nil,nil);
  DADPlots    : array[1..10] of TImage = (nil,nil,nil,nil,nil,nil,nil,nil,nil,nil);
  GFXAnimBuff : TBitmap = nil;

function ResPackLoad(const FileName : string) : boolean;
procedure ResPackFree;

implementation

function ResPackLoad(const FileName : string) : boolean;
var i : integer;
    HGFX : THandle;
    RES  : TResourceStream;
begin
  result := false;
  if not FileExists(FileName) then exit;
  HGFX := windows.LoadLibrary(pchar(FileName));
  if HGFX = Windows.INVALID_HANDLE_VALUE then exit;

  { creations des objets }

  GFXTspGnd    := TPNGObject.Create;
  GFXYouWin    := TPNGObject.Create;
  GFXYouLose   := TPNGObject.Create;
  GFXPlots[-1] := TPNGObject.Create;
  GFXAnimBuff  := TBitmap.Create;

  { chargement des diverses images }
  GFXTspGnd.LoadFromResourceName(HGFX,'TSPGND');
  GFXYouWin.LoadFromResourceName(HGFX,'YOUWIN');
  GFXYouLose.LoadFromResourceName(HGFX,'YOULSE');
  GFXPlots[-1].LoadFromResourceName(HGFX,'PLOTSC');

  for i := 0 to 3 do begin
      GFXBckGnd[i] := TJpegImage.Create;
      RES := TResourceStream.Create(HGFX,format('GND%.2d',[i]),RT_RCDATA);
      GFXBckGnd[i].LoadFromStream(RES);
      RES.Free;
  end;

  for i := 0 to 2 do begin
      GFXChecks[i] := TPNGObject.Create;
      GFXChecks[i].LoadFromResourceName(HGFX,format('CHK%.2d',[i]));
  end;

  for i := 0 to 10 do begin
      GFXPlots[i] := TPNGObject.Create;
      GFXPlots[i].LoadFromResourceName(HGFX,format('PLOT%.2d',[i]));
  end;

  for i := 1 to 10 do begin
      GFXPlots[i].SaveToFile(ExtractFilePath(FileName)+'temp'+inttostr(i)+'.png');
      DADPlots[i].Picture.LoadFromFile(ExtractFilePath(FileName)+'temp'+inttostr(i)+'.png');
      deletefile(ExtractFilePath(FileName)+'temp'+inttostr(i)+'.png');
      DADPlots[i].Tag := i;
  end;

  for i := 1 to 5 do begin
      GFXInterfac[i] := TPNGObject.Create;
      GFXInterfac[i].LoadFromResourceName(HGFX,format('INTF%.2d',[i]));
  end;

  { GFX PACK LOADING //End//}
  result := windows.FreeLibrary(HGFX);
end;

procedure ResPackFree;
var i : integer;
begin
  for i := -1 to 10 do GFXPlots[i].Free;
  for i := 1 to 10 do  DADPlots[i].Free;
  for i := 0 to 2 do   GFXChecks[i].Free;
  for i := 1 to 5 do   GFXInterfac[i].Free;
  for i := 0 to 3 do   GFXBckGnd[i].Free;
  GFXTspGnd.Free;
  GFXYouWin.Free;
  GFXYouLose.Free;
  GFXAnimBuff.Free;
end;

end.
