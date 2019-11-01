@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION



REM =================
REM  INPUTS
REM =================

echo  ..
echo --EXPORT DATA  userinput --------------------------------------1

set /P paout="Enter destination path (MAIN PATH): "
pause  

set /P nunderscore="number of underscores in the mouse-subDirectory-name: "
pause 

echo destination path                : %paout%
echo number of scores in mousefolder : %nunderscore%

echo -------------------------------------------------------------------2





set pain=%cd%



REM =================
REM GET PATH AND FILE
REM =================
rem set /p paout="Enter destination (main) path: "
rem set paout=C:\Users\skoch\Desktop\batch\out

SLEEP 1




REM =================
echo input:  !pain!
echo output: !paout!

SETLOCAL
rem SET "sourcedir=C:\Users\skoch\Desktop\batch\inputXXX"
Set sourcedir=!pain!
PUSHD %sourcedir%

rem FOR /f "tokens=1,* delims=_" %%a IN ('dir /b /a-d "*_*.txt"') DO (
FOR /f "tokens=1,* delims=_" %%a IN ('dir /b /a-d "*.nii"') DO (


    REM Name the folder based on what is before the first token.
    REM MD %%a
    REM To get the full filename, concatenate the tokens back together.
    REM Copy "%%a_%%b" .\%%a\
    rem echo %%b
  
set s=__________________________________
echo !s!    
set w1=%%a
rem echo !w1!

REM =================
REM GET PATH AND FILE
REM =================


set pa=%%~pa
set fi=%%a_%%b
set fi_long=!pa!!fi!

echo pa          : !pa!
echo fi          : !fi!
echo fi_long     : !fi_long!   
echo paout       : !paout!

   

REM =================
REM DEFINE SUBFOLDER
REM =================
call :subfolder

set subfolder_long=!paout!\!subfolder!
set newfilename=!subfolder_long!\!fi!

echo subfolder      : !subfolder!
echo subfolder_long : !subfolder_long!
echo newfilename    : !newfilename!


REM =================
REM make folder and copy files
REM =================

call :copyfiles



)

 goto :eof

rem %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
REM  SUBROUTINES
rem %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

REM =================
REM  sub: make subfolder
REM =================

:subfolder
set input=!fi!
rem set "input=A123_101234_345_555_666"
set output=

rem set nunderscore=1

if %nunderscore% GEQ 0 (
 for /f "tokens=1 delims=_" %%a in ("%input%") do (
     set output=!output!%%a
     )
    )
if %nunderscore% GEQ 1 (
 for /f "tokens=2 delims=_" %%a in ("%input%") do (
     set output=!output!_%%a
     )
    )
if %nunderscore% GEQ 2 (
 for /f "tokens=3 delims=_" %%a in ("%input%") do (
     set output=!output!_%%a
     )
    )

set subfolder=!output!
 goto :eof


rem %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
:copyfiles
REM =================
REM  copyfiles
REM =================

MD !subfolder_long!
copy !fi_long! !newfilename!
 goto :eof















