@echo off
:: Add 'Safe Mode' option to Windows 8-10 boot menu
setlocal
chcp 437
for /f "tokens=1,* delims= " %%a in (' bcdedit ^| findstr "description" ') do set CurrentOS=%%b
for /f "tokens=7 delims=. " %%i in (' bcdedit /copy {current} /d "%CurrentOS% Safe Mode with Networking" ') do set CurrentID=%%i
bcdedit /set %CurrentID% safeboot network
bcdedit /timeout 3
start cmd /k bcdedit
