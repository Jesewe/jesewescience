@echo off
setlocal enabledelayedexpansion
title Windows 11 Performance Optimizer v2.0
chcp 65001 >nul 2>&1

REM ========================================
REM  Windows 11 Performance Optimizer v2.0
REM  Created by jesewe - Safe & Reversible
REM ========================================

echo.
echo ===============================================
echo     Windows 11 Performance Optimizer v2.0
echo ===============================================
echo.

REM Check for administrator privileges
echo [INFO] Checking administrator privileges...
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] This script must be run as Administrator!
    echo Right-click and select 'Run as administrator'
    echo.
    pause
    exit /b 1
)
echo [SUCCESS] Administrator privileges confirmed
echo.

REM System information
echo [INFO] System Information:
echo OS Version: %OS%
ver
echo Computer: %COMPUTERNAME%
echo User: %USERNAME%
echo Date: %DATE% %TIME%
echo.

REM Safety warning and backup creation
echo [WARNING] IMPORTANT SAFETY NOTICE:
echo This script will modify Windows registry settings for optimization.
echo A registry backup will be created automatically.
echo.
echo Press Ctrl+C to cancel, or any key to continue...
pause >nul

REM Create backup directory with proper date/time formatting
for /f "tokens=1-3 delims=/" %%a in ("%DATE%") do (
    set "MM=%%a"
    set "DD=%%b"
    set "YYYY=%%c"
)
for /f "tokens=1-3 delims=:" %%a in ("%TIME%") do (
    set "HH=%%a"
    set "MIN=%%b"
    set "SS=%%c"
)

REM Remove spaces and format properly
set "HH=!HH: =0!"
set "MM=!MM: =0!"
set "DD=!DD: =0!"
set "MIN=!MIN: =0!"
set "SS=!SS:~0,2!"

set "BACKUP_DIR=C:\Optimizer\Win11_Optimizer_Backup_!YYYY!!MM!!DD!"

echo.
echo [INFO] Creating system backup...
mkdir "!BACKUP_DIR!" 2>nul

REM Export registry backup
reg export "HKEY_CURRENT_USER" "!BACKUP_DIR!\HKCU_backup.reg" /y >nul 2>&1
reg export "HKEY_LOCAL_MACHINE\SOFTWARE" "!BACKUP_DIR!\HKLM_SOFTWARE_backup.reg" /y >nul 2>&1
reg export "HKEY_LOCAL_MACHINE\SYSTEM" "!BACKUP_DIR!\HKLM_SYSTEM_backup.reg" /y >nul 2>&1

if exist "!BACKUP_DIR!\HKCU_backup.reg" (
    echo [SUCCESS] Registry backup created at: !BACKUP_DIR!
) else (
    echo [WARNING] Backup creation failed - continuing anyway...
)

echo.
echo [INFO] Starting optimization process...
echo.

REM Initialize counters
set /a SUCCESS_COUNT=0
set /a TOTAL_COUNT=0

REM ========================================
REM  GAMING OPTIMIZATIONS
REM ========================================
echo ----------------------------------------
echo  Gaming Performance Optimizations
echo ----------------------------------------

call :ApplyReg "Disable GameDVR FSE Behavior" "HKCU\System\GameConfigStore" "GameDVR_FSEBehavior" "REG_DWORD" "2"
call :ApplyReg "Disable GameDVR" "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
call :ApplyReg "GameDVR DXGI Compatibility" "HKCU\System\GameConfigStore" "GameDVR_DXGIHonorFSEWindowsCompatible" "REG_DWORD" "1"
call :ApplyReg "GameDVR User Behavior Mode" "HKCU\System\GameConfigStore" "GameDVR_HonorUserFSEBehaviorMode" "REG_DWORD" "1"
call :ApplyReg "GameDVR Feature Flags" "HKCU\System\GameConfigStore" "GameDVR_EFSEFeatureFlags" "REG_DWORD" "0"
call :ApplyReg "GameDVR Policy Disable" "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"

call :ApplyReg "Game GPU Priority" "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" "REG_DWORD" "8"
call :ApplyReg "Game CPU Priority" "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" "REG_DWORD" "6"
call :ApplyReg "Game Scheduling Category" "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "REG_SZ" "High"
call :ApplyReg "Game SFIO Priority" "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Priority" "REG_SZ" "High"

REM ========================================
REM  SYSTEM PERFORMANCE OPTIMIZATIONS
REM ========================================
echo.
echo ----------------------------------------
echo  System Performance Optimizations
echo ----------------------------------------

call :ApplyReg "Disable Telemetry (Policy)" "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :ApplyReg "Disable Telemetry (Main)" "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :ApplyReg "Disable Feedback Notifications" "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "DoNotShowFeedbackNotifications" "REG_DWORD" "1"
call :ApplyReg "System Responsiveness" "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "REG_DWORD" "0"
call :ApplyReg "Network Throttling Index" "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" "REG_DWORD" "4294967295"
call :ApplyReg "Menu Show Delay" "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_DWORD" "1"
call :ApplyReg "Auto End Tasks" "HKCU\Control Panel\Desktop" "AutoEndTasks" "REG_DWORD" "1"
call :ApplyReg "Mouse Hover Time" "HKCU\Control Panel\Mouse" "MouseHoverTime" "REG_SZ" "400"
call :ApplyReg "IRP Stack Size" "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "IRPStackSize" "REG_DWORD" "30"
call :ApplyReg "Clear PageFile at Shutdown" "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" "REG_DWORD" "0"
call :ApplyReg "Disable Transparency Effects" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" "REG_DWORD" "0"
call :ApplyReg "Disable Prefetch" "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" "REG_DWORD" "0"

REM ========================================
REM  PRIVACY & BLOATWARE OPTIMIZATIONS
REM ========================================
echo.
echo ----------------------------------------
echo  Privacy and Bloatware Optimizations
echo ----------------------------------------

call :ApplyReg "Disable Content Delivery" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" "REG_DWORD" "0"
call :ApplyReg "Disable OEM Pre-installed Apps" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" "REG_DWORD" "0"
call :ApplyReg "Disable Pre-installed Apps" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" "REG_DWORD" "0"
call :ApplyReg "Disable Pre-installed Apps (Ever)" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEverEnabled" "REG_DWORD" "0"
call :ApplyReg "Disable Silent App Install" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" "REG_DWORD" "0"
call :ApplyReg "Disable Subscribed Content 338387" "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" "REG_DWORD" "0"
call :ApplyReg "Disable Subscribed Content 338388" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" "REG_DWORD" "0"
call :ApplyReg "Disable Subscribed Content 338389" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" "REG_DWORD" "0"
call :ApplyReg "Disable Subscribed Content 353698" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353698Enabled" "REG_DWORD" "0"
call :ApplyReg "Disable System Pane Suggestions" "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
call :ApplyReg "Disable Consumer Features" "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" "REG_DWORD" "1"

REM ========================================
REM  INTERFACE & FEATURES OPTIMIZATIONS  
REM ========================================
echo.
echo ----------------------------------------
echo  Interface and Features Optimizations
echo ----------------------------------------

call :ApplyReg "Disable Windows Feeds" "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" "EnableFeeds" "REG_DWORD" "0"
call :ApplyReg "Hide Feeds Taskbar" "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" "ShellFeedsTaskbarViewMode" "REG_DWORD" "2"
call :ApplyReg "Hide Meet Now Button" "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAMeetNow" "REG_DWORD" "1"
call :ApplyReg "Disable Activity Feed" "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
call :ApplyReg "Disable Activity Publishing" "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" "REG_DWORD" "0"
call :ApplyReg "Disable Activity Upload" "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" "REG_DWORD" "0"

REM ========================================
REM  NETWORK & CONNECTIVITY OPTIMIZATIONS
REM ========================================
echo.
echo ----------------------------------------
echo  Network and Connectivity Optimizations
echo ----------------------------------------

call :ApplyReg "Disable WiFi HotSpot Reporting" "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "Value" "REG_DWORD" "0"
call :ApplyReg "Disable WiFi Sense Auto-Connect" "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Value" "REG_DWORD" "0"
call :ApplyReg "Optimize NDU Service" "HKLM\SYSTEM\ControlSet001\Services\Ndu" "Start" "REG_DWORD" "2"

REM ========================================
REM  ADDITIONAL PRIVACY OPTIMIZATIONS
REM ========================================
echo.
echo ----------------------------------------
echo  Additional Privacy Optimizations
echo ----------------------------------------

call :ApplyReg "Disable SIUF" "HKCU\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" "REG_DWORD" "0"
call :ApplyReg "Disable Tailored Experiences" "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableTailoredExperiencesWithDiagnosticData" "REG_DWORD" "1"
call :ApplyReg "Disable Advertising Info (Policy)" "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
call :ApplyReg "Disable Advertising Info (User)" "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" "REG_DWORD" "0"
call :ApplyReg "Disable Error Reporting" "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "1"
call :ApplyReg "Disable Location Services" "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "1"
call :ApplyReg "Disable Remote Assistance" "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" "REG_DWORD" "0"
call :ApplyReg "Disable Biometrics" "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" "Enabled" "REG_DWORD" "0"

REM ========================================
REM  COMPLETION SUMMARY
REM ========================================
echo.
echo ===============================================
echo          OPTIMIZATION COMPLETED!
echo ===============================================
echo.
echo [SUMMARY] Results:
echo Successfully applied: !SUCCESS_COUNT!/!TOTAL_COUNT! optimizations
echo.
if exist "!BACKUP_DIR!\HKCU_backup.reg" (
    echo [BACKUP] Location: !BACKUP_DIR!
    echo.
)
echo [IMPORTANT] Next Steps:
echo - Restart your computer to ensure all changes take effect
echo - If you experience issues, restore from the backup files
echo - Some changes may require a Windows restart to be fully applied
echo.
set /p "RESTART_CHOICE=Would you like to restart now? (Y/N): "
if /i "!RESTART_CHOICE!"=="Y" (
    echo [INFO] Restarting in 10 seconds... Press Ctrl+C to cancel
    timeout /t 10
    shutdown /r /t 0
) else (
    echo [INFO] Please restart manually when convenient.
)

echo.
echo [SUCCESS] Thank you for using Windows 11 Performance Optimizer!
echo.
pause
exit /b 0

REM ========================================
REM  FUNCTIONS
REM ========================================

:ApplyReg
set /a TOTAL_COUNT+=1
set "DESCRIPTION=%~1"
set "KEY_PATH=%~2"
set "VALUE_NAME=%~3"
set "VALUE_TYPE=%~4"
set "VALUE_DATA=%~5"

reg add "!KEY_PATH!" /v "!VALUE_NAME!" /t !VALUE_TYPE! /d "!VALUE_DATA!" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [SUCCESS] !DESCRIPTION!
    set /a SUCCESS_COUNT+=1
) else (
    echo [FAILED] !DESCRIPTION!
)
goto :eof