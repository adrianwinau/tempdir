import os, shutil, zipfile

VBS = "..\\tempdir.vbs"
PS = "..\\tempdir-main.ps1"
UNINSTALL = "..\\uninstall.cmd"
INSTALL_PS1 = ".\\install.ps1"
VERSION = input("Version number: ")
TARGET_PATH = f".\\version\\{VERSION}"
INSTALLER = f"{TARGET_PATH}\\tempdir-installer.cmd"
ZIP = f"{TARGET_PATH}\\tempdir-installer.zip"
all_text = f"""\
@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
%windir%\System32\more +10 "%~f0" > "%temp%\%~n0.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\%~n0.ps1" %*

del %temp%\%~n0.ps1
exit /b

*** Ab hier PowerShell ***
"""
install_ps_text = ""

if os.path.exists(TARGET_PATH):
    shutil.rmtree(TARGET_PATH)
os.mkdir(TARGET_PATH)

with open(INSTALL_PS1, 'r') as file:
    install_ps_text = file.read()



with open(PS, 'r') as file:
    install_ps_text = install_ps_text.replace("<<<psFile>>>", file.read())

with open(VBS, 'r') as file:
    install_ps_text = install_ps_text.replace("<<<vbsFile>>>", file.read())

with open(UNINSTALL, 'r') as file:
    install_ps_text = install_ps_text.replace("<<<uninstallFile>>>", file.read())

all_text += install_ps_text

with open(INSTALLER, 'w+') as file:
    file.write(all_text)

with zipfile.ZipFile(ZIP, 'w') as zip_installer:
    zip_installer.write(INSTALLER, INSTALLER.split("\\")[-1])