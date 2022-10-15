$installDir = "C:\Program Files\Temporary Directory Utility"
$shortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\tempdir.lnk"
$uninstallFile = "$installDir\uninstall.cmd"
$vbsFile = "$installDir\tempdir.vbs"
$psFile = "$installDir\tempdir-main.ps1"

$uninstallText = @'
<<<uninstallFile>>>
'@
$vbsText = @'
<<<vbsFile>>>
'@
$psText = @'
<<<psFile>>>
'@


if (Test-Path $installDir) {
    Remove-Item -Path $installDir -Recurse -Force
}

New-Item -Path $installDir -ItemType Directory
New-Item -Path $uninstallFile -ItemType File
New-Item -Path $vbsFile -ItemType File
New-Item -Path $psFile -ItemType File
Set-Content -Path $uninstallFile -Value $uninstallText
Set-Content -Path $vbsFile -Value $vbsText
Set-Content -Path $psFile -Value $psText

$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $vbsFile
$shortcut.WorkingDirectory = $installDir
$shortcut.Save()

Write-Host -ForegroundColor Green "Installation successful. You can close this window."