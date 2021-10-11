@echo off
echo Suppression des anciens fichiers :
del .\GFXPack\GfxResPack.res
del GFXPack.rpk
del *.dcu
del *.~*
echo  OK
echo.

echo Construction de la ressource :
BRCC32 -r -foGFXPack\GfxResPack.res GFXPack\GfxResPack.rc
echo  OK
echo.

echo Compilation du pack ressource :
DCC32 GFXPack\GFXPack.dpr
echo OK
echo.

echo Compilation du programme :
DCC32 MasterMind.dpr -B -UPngLib
echo OK
echo.

echo.
pause