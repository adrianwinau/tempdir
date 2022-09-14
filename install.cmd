@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "installDir=C:\Program Files\Temporary Directory Utility"
if not exist "%installDir%" goto :createAll

set /p "input=Temporary Directory Utility already exist. Replace files with new version? [y/n] "
echo "%input%"
if /i not "%input%"=="y" goto :abort
goto :copyNewFiles

:createAll
mkdir "%installDir%"

:copyNewFiles
copy /y ".\tempdir.vbs" "%installDir%\tempdir.vbs"
copy /y ".\tempdir-main.cmd" "%installDir%\tempdir-main.cmd"
copy /y ".\uninstall.cmd" "%installDir%\uninstall.cmd"

set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\tempdir.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%installDir%\tempdir.vbs" >> %SCRIPT%
echo oLink.WorkingDirectory = "%installDir%" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%

echo Installation successfully.
goto :end

:abort
echo Installation aborted.

:end
pause
exit