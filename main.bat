@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title ClassM Manager by https://github.com/studentprivacy
mode con cols=65 lines=22
color 0f

:: 관리자 권한 확인 및 승인 요청
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:MAIN_MENU
cls
echo.
echo  =============================================================
echo   # ClassM Manager v1.0
echo  =============================================================
echo.
echo    [1] 컴퓨터 관리 프로세스 중지 (되돌릴 수 없음)
echo    [2] 시스템 재부팅 (정상 상태 복구)
echo    [3] 프로그램 종료
echo.
echo  =============================================================
echo.
set /p choice="  메뉴를 선택하세요 (1-3): "

if "%choice%"=="1" goto KILL_BATCH_CREATE
if "%choice%"=="2" goto REBOOT_SYS
if "%choice%"=="3" exit
goto MAIN_MENU

:KILL_BATCH_CREATE
set "TEMP_BAT=%TEMP%\temp_script_%RANDOM%%RANDOM%.bat"
echo @echo off > "%TEMP_BAT%"
echo :KILL_LOOP >> "%TEMP_BAT%"
echo taskkill /f /im ClassM_Client.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im ClassM_Client_Service.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im SysCtrl.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im mvnc.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im hscagent.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im hscdm.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im hscfm.exe >nul 2>&1 >> "%TEMP_BAT%"
echo taskkill /f /im hscrelay.exe >nul 2>&1 >> "%TEMP_BAT%"
echo timeout /t 1 /nobreak >nul >> "%TEMP_BAT%"
echo goto KILL_LOOP >> "%TEMP_BAT%"
cls
goto KILL_BATCH_RUN

:KILL_BATCH_RUN
Set WinScriptHost = CreateObject( "WScript.shell" )
WinScriptHost.Run Chr(34) & "%TEMP_BAT%" & Chr(34), 0
Set WinScriptHost = Nothing
cls
echo.
echo  =============================================================
echo   [!] ClassM 프로세스 강제 종료 루프가 시작되었습니다.
echo  =============================================================
echo.
echo   * ClassM 프로세스를 지속적으로 탐지하고 차단합니다.
echo   * 이 작업은 중단할 수 없으며, 백그라운드에서 계속 실행됩니다.
echo   * 정상 상태로 복구하려면 시스템을 재부팅해야 합니다.
echo.
echo  =============================================================
echo.
echo   [!] 아무 키나 눌러 메인 메뉴로 돌아가십시오.
pause >nul
goto MAIN_MENU


:REBOOT_SYS
cls
echo.
echo  =============================================================
echo   [!] 시스템을 재부팅합니다.
echo  =============================================================
echo.
echo   * 5초 후 컴퓨터가 다시 시작됩니다.
echo   * 모든 모니터링 프로그램이 정상 복구됩니다.
echo.
echo  =============================================================
echo.
shutdown /r /t 5 /c "ClassM Manager: 원래 상태로 복구 중..."
pause
exit