@echo off
%windir%\System32\more +8 "%~f0" > "%temp%\%~n0.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\%~n0.ps1" %*

del %temp%\%~n0.ps1
exit /b

*** Ab hier PowerShell ***
function New-TempDir() {
    do {
        $dirPath = "$([System.IO.Path]::GetTempPath())tempworkdir-$(Get-Random)"
    } while (Test-Path $dirPath)
    return New-Item -Path $dirPath -ItemType Directory
}

$oldPidList = @()
$global:toMonitorPid = $null
$tempDir = New-TempDir

Write-Host "#################`n`nThis is the Host of the Temporary Work Directory $tempDir `nDo not close this Window. This window will be closed automatically about 30s after you close the Explorer Window.`n`n#################`n"

Get-Process -ProcessName "explorer" | ForEach-Object { $oldPidList += $_.Id }
$startProcess = Start-Process explorer -ArgumentList "$tempDir"
Start-Sleep -Seconds 1.0
do {
    Get-Process -ProcessName "explorer" | ForEach-Object { 
        if ($_.Id -eq $startProcess.Id) {
            continue
        }
        if ($oldPidList -notcontains $_.Id) {
            $global:toMonitorPid = $_.Id 
        }
    }
} while ($null -eq $global:toMonitorPid)

Write-Host $global:toMonitorPid
Write-Host $oldPidList

Wait-Process -Id $global:toMonitorPid

Write-Host "Process down"
Remove-Item -Recurse -Force $tempDir
