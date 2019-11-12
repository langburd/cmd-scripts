@echo off
:: Enable System Restore and configure daily creation of Restore Point

Set ITDir=%SystemDrive%\IT\Scripts
md %ITDir%
Set CreateSystemRestorePoint=%ITDir%\CreateSystemRestorePoint.ps1

echo # https://www.itprotoday.com/windows-7/controlling-system-restore-powershell>%CreateSystemRestorePoint%
echo:>>%CreateSystemRestorePoint%
:: Enable System Restore on System Drive
echo Enable-ComputerRestore -Drive $Env:SystemDrive>>%CreateSystemRestorePoint%
:: Set Max Usage by System Restore on 10% of System Drive
echo vssadmin Resize ShadowStorage /on=$Env:SystemDrive /for=$Env:SystemDrive /MaxSize=10%%>>%CreateSystemRestorePoint%
:: Create Restore Point
echo Checkpoint-Computer -Description $((get-date).ToLocalTime()).ToString("yyyy-MM-dd_HH-mm-ss") -RestorePointType "MODIFY_SETTINGS">>%CreateSystemRestorePoint%

:: Create Task in Task Scheduler
SCHTASKS /Create /SC DAILY /RU SYSTEM /RL HIGHEST /F /TN "CreateSystemRestorePoint" /TR "powershell.exe -ExecutionPolicy Bypass -File %CreateSystemRestorePoint%" /ST 21:00
SCHTASKS /Run /TN "CreateSystemRestorePoint"
