@echo off
setlocal enabledelayedexpansion
title rapidtweaks tweaking utility

:: enable ansi/vt100 colors in windows console
reg add "hkcu\console" /v "virtualterminallevel" /t reg_dword /d 1 /f >nul 2>&1

:: auto-elevate to administrator
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo requesting administrator privileges...
    powershell -command "start-process '%~f0' -verb runas"
    exit /b
)

:: ansi color codes
set "esc="
set "magenta=%esc%[95m"
set "cyan=%esc%[96m"
set "white=%esc%[97m"
set "gray=%esc%[90m"
set "red=%esc%[91m"
set "green=%esc%[92m"
set "yellow=%esc%[93m"
set "reset=%esc%[0m"
set "bold=%esc%[1m"

goto :main_menu


:: ============================================================
:: main menu
:: ============================================================
:main_menu
cls
echo.
echo %magenta%%bold%    ██████╗  █████╗ ██████╗ ██╗██████╗ ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗%reset%
echo %magenta%%bold%    ██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝%reset%
echo %magenta%%bold%    ██████╔╝███████║██████╔╝██║██║  ██║   ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗%reset%
echo %magenta%%bold%    ██╔══██╗██╔══██║██╔═══╝ ██║██║  ██║   ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║%reset%
echo %magenta%%bold%    ██║  ██║██║  ██║██║     ██║██████╔╝   ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║%reset%
echo %magenta%%bold%    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝    ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝%reset%
echo.
echo %cyan%                        tweaking utility  v1.0  ^|  extreme edition%reset%
echo %gray%                   ──────────────────────────────────────────────────%reset%
echo.
echo %white%   %cyan%[1]%reset% general system optimizations    %cyan%[2]%reset% power optimizations
echo %white%   %cyan%[3]%reset% keyboard and mouse              %cyan%[4]%reset% gpu optimizations
echo %white%   %cyan%[5]%reset% cpu optimizations               %cyan%[6]%reset% pc clean
echo %white%   %cyan%[7]%reset% system debloat                  %cyan%[8]%reset% storage optimizations
echo %white%   %cyan%[9]%reset% memory optimizations            %cyan%[10]%reset% additional / qol
echo %white%   %cyan%[11]%reset% uninstall useless apps         %cyan%[12]%reset% network optimizations
echo.
echo %gray%   ──────────────────────────────────────────────────────────────────%reset%
echo %white%   %yellow%[A]%reset% apply all tweaks at once        %yellow%[R]%reset% create restore point
echo %white%   %red%[X]%reset% exit
echo %gray%   ──────────────────────────────────────────────────────────────────%reset%
echo.
set /p "choice=%cyan%  > select option: %reset%"

if /i "%choice%"=="1"  goto :general_system
if /i "%choice%"=="2"  goto :power_opts
if /i "%choice%"=="3"  goto :keyboard_mouse
if /i "%choice%"=="4"  goto :gpu_opts
if /i "%choice%"=="5"  goto :cpu_opts
if /i "%choice%"=="6"  goto :pc_clean
if /i "%choice%"=="7"  goto :system_debloat
if /i "%choice%"=="8"  goto :storage_opts
if /i "%choice%"=="9"  goto :memory_opts
if /i "%choice%"=="10" goto :additional_qol
if /i "%choice%"=="11" goto :uninstall_apps
if /i "%choice%"=="12" goto :network_opts
if /i "%choice%"=="a"  goto :apply_all
if /i "%choice%"=="r"  goto :create_restore
if /i "%choice%"=="x"  goto :exit_script
goto :main_menu


:: ============================================================
:: helper - section header
:: ============================================================
:section_header
cls
echo.
echo %magenta%%bold%  rapidtweaks%reset% %cyan%^>%reset% %white%%bold%%~1%reset%
echo %gray%  ──────────────────────────────────────────────────────────────────%reset%
echo.
exit /b


:: ============================================================
:: helper - done message
:: ============================================================
:done_msg
echo.
echo %green%  [done]%reset% tweaks applied successfully.
echo %gray%  a restart is recommended for all changes to take effect.%reset%
echo.
pause
goto :main_menu


:: ============================================================
:: 1 - general system optimizations
:: ============================================================
:general_system
call :section_header "general system optimizations"

echo %cyan%  applying general system tweaks...%reset%

:: disable startup delay
reg add "hkcu\software\microsoft\windows\currentversion\explorer\serialize" /v "startupdelayinmsec" /t reg_dword /d "0" /f >nul 2>&1

:: speed up shutdown
reg add "hklm\system\currentcontrolset\control" /v "waittokilltimeout" /t reg_sz /d "200" /f >nul 2>&1
reg add "hkcu\control panel\desktop" /v "waittokilltimeout" /t reg_sz /d "200" /f >nul 2>&1
reg add "hkcu\control panel\desktop" /v "hungtimeout" /t reg_sz /d "200" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control" /v "servicesstimeout" /t reg_dword /d "200" /f >nul 2>&1

:: game task scheduler priority
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "affinity" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "background only" /t reg_sz /d "false" /f >nul 2>&1
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "clock rate" /t reg_dword /d "2710" /f >nul 2>&1
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "gpu priority" /t reg_dword /d "8" /f >nul 2>&1
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "priority" /t reg_dword /d "6" /f >nul 2>&1
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "scheduling category" /t reg_sz /d "high" /f >nul 2>&1
reg add "hklm\software\microsoft\windows nt\currentversion\multimedia\systemprofile\tasks\games" /v "sfio priority" /t reg_sz /d "high" /f >nul 2>&1

:: disable autoplay
reg add "hkcu\software\microsoft\windows\currentversion\explorer\autoplayhandlers" /v "disableautoplay" /t reg_dword /d "1" /f >nul 2>&1

:: disable error reporting
reg add "hklm\software\microsoft\windows\windows error reporting" /v "disabled" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\software\microsoft\windows\windows error reporting" /v "dontsenddataqueueing" /t reg_dword /d "1" /f >nul 2>&1

:: disable hibernation
powercfg /hibernate off >nul 2>&1

:: disable fast startup
reg add "hklm\system\currentcontrolset\control\session manager\power" /v "hibernateenabled" /t reg_dword /d "0" /f >nul 2>&1

echo %green%  [ok]%reset% general system tweaks applied.
call :done_msg


:: ============================================================
:: 2 - power optimizations
:: ============================================================
:power_opts
call :section_header "power optimizations"

echo %cyan%  applying power tweaks...%reset%

:: disable all device-level power management flags across every enum key
for %%i in (
    EnhancedPowerManagementEnabled
    AllowIdleIrpInD3
    EnableSelectiveSuspend
    DeviceSelectiveSuspended
    SelectiveSuspendEnabled
    SelectiveSuspendOn
    EnumerationRetryCount
    ExtPropDescSemaphore
    WaitWakeEnabled
    D3ColdSupported
    WdfDirectedPowerTransitionEnable
    EnableIdlePowerManagement
    IdleInWorkingState
) do (
    for /f %%a in ('reg query "hklm\system\currentcontrolset\enum" /s /f "%%i" ^| findstr "hkey"') do (
        reg add "%%a" /v "%%i" /t reg_dword /d "0" /f >nul 2>&1
    )
)

:: disable hibernate and sleep study
powercfg /h off >nul 2>&1

:: power control flags
reg add "hklm\system\currentcontrolset\control\power" /v "energyestimationenabled" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\power" /v "sleepstudydisabled" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\power" /v "coalescingflushinterval" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\power" /v "coalescingtimerinterval" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\power" /v "msdisabled" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\power" /v "eventprocessorenabled" /t reg_dword /d "0" /f >nul 2>&1

:: disable wake-on via wmi for all devices
powershell -nop -noni -exec bypass -command "get-wmiobject mspower_deviceenable -namespace root\wmi | foreach-object { $_.enable = $false; $_.psbase.put(); }" >nul 2>&1

:: disable power throttling
reg add "hklm\system\currentcontrolset\control\power\powerthrottling" /v "powerthrottlingenabled" /t reg_dword /d "0" /f >nul 2>&1

:: import and activate custom sos power plan (extreme latency-optimised)
:: note: sos.pow must be present in %windir% - place it there before running
powercfg -delete 77777777-7777-7777-7777-777777777777 >nul 2>&1
if exist "%windir%\sos.pow" (
    powercfg -import "%windir%\sos.pow" 77777777-7777-7777-7777-777777777777 >nul 2>&1
    powercfg -setactive 77777777-7777-7777-7777-777777777777 >nul 2>&1
    echo %green%  [ok]%reset% sos.pow imported and set as active power plan.
) else (
    echo %yellow%  [warn]%reset% sos.pow not found in %windir%. falling back to ultimate performance plan.
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    for /f "tokens=4" %%g in ('powercfg /list ^| findstr /i "ultimate performance"') do (
        powercfg /setactive %%g >nul 2>&1
    )
)

:: delete built-in power plans (balanced, high performance, power saver)
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1

:: disable processor performance scaling and core parking
powercfg /setacvalueindex scheme_current sub_processor perfincpol 0 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor perfdecpol 0 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor cpmincores 100 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor cpmaxcores 100 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor procthrottlemin 100 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor idledisable 1 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1

echo %green%  [ok]%reset% power tweaks applied.
call :done_msg


:: ============================================================
:: 3 - keyboard and mouse optimizations
:: ============================================================
:keyboard_mouse
call :section_header "keyboard and mouse optimizations"

echo %cyan%  applying input device tweaks...%reset%

:: disable mouse acceleration
reg add "hkcu\control panel\mouse" /v "mouseaccelerationthreshold" /t reg_sz /d "0" /f >nul 2>&1
reg add "hkcu\control panel\mouse" /v "mousespeed" /t reg_sz /d "0" /f >nul 2>&1
reg add "hkcu\control panel\mouse" /v "mousethreshold1" /t reg_sz /d "0" /f >nul 2>&1
reg add "hkcu\control panel\mouse" /v "mousethreshold2" /t reg_sz /d "0" /f >nul 2>&1

:: minimum keyboard repeat delay, maximum repeat rate
reg add "hkcu\control panel\keyboard" /v "keyboarddelay" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\control panel\keyboard" /v "keyboardspeed" /t reg_dword /d "31" /f >nul 2>&1

echo %green%  [ok]%reset% keyboard and mouse tweaks applied.
call :done_msg


:: ============================================================
:: 4 - gpu optimizations
:: ============================================================
:gpu_opts
call :section_header "gpu optimizations"

echo %cyan%  applying universal gpu tweaks...%reset%

:: enable hags (hardware accelerated gpu scheduling)
reg add "hklm\system\currentcontrolset\control\graphicsdrivers" /v "hwschedulingmode" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\graphicsdrivers" /v "enablehwschedulingmode" /t reg_dword /d "2" /f >nul 2>&1

:: disable mpo (fixes flickering/stuttering on all gpus)
reg add "hklm\software\microsoft\windows\dwm" /v "overlaytestmode" /t reg_dword /d "5" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\graphicsdrivers" /v "disableoverlays" /t reg_dword /d "1" /f >nul 2>&1

:: detect gpu vendor
set "nv_found=0"
set "amd_found=0"
for /f "tokens=*" %%i in ('wmic path win32_videocontroller get name 2^>nul ^| findstr /i "nvidia"') do set "nv_found=1"
for /f "tokens=*" %%i in ('wmic path win32_videocontroller get name 2^>nul ^| findstr /i "amd radeon"') do set "amd_found=1"

if "%nv_found%"=="1" goto :nvidia_tweaks
if "%amd_found%"=="1" goto :amd_tweaks

echo %yellow%  [warn]%reset% no nvidia or amd gpu detected. universal tweaks still applied.
call :done_msg


:: ---- nvidia tweaks ----
:nvidia_tweaks
echo %cyan%  [nvidia detected] applying driver registry tweaks...%reset%

:: ensure wmi is running
reg add "hklm\system\currentcontrolset\services\winmgmt" /v "start" /t reg_dword /d "2" /f >nul 2>&1
sc config winmgmt start= auto >nul 2>&1
net start winmgmt >nul 2>&1

:: install wmic if missing
if not exist "%windir%\system32\wbem\wmic.exe" (
    dism /online /add-capability /capabilityname:wmic~~~~ >nul 2>&1
)

:: apply p-state and driver registry tweaks via class guid
for /f %%i in ('wmic path win32_videocontroller get pnpdeviceid ^| findstr /l "pci\ven_"') do (
    for /f "tokens=3" %%a in ('reg query "hklm\system\controlset001\enum\%%i" /v "driver" 2^>nul') do (
        for /f %%k in ('echo %%a ^| findstr "{"') do (

            :: p-state and performance locks
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "disabledynamicpstate" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "disableasyncpstates" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmperflimitsoverride" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmpcieltroverride" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmdeepl1entrylatencyusec" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "prefersystemmemorycontiguous" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmclkslowdown" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmoverrideidleslowdownsettings" /t reg_dword /d "1" /f >nul 2>&1
            :: 0x3322 = fixed perf on battery, dynamic on ac
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "perflevelsrc" /t reg_dword /d "13090" /f >nul 2>&1

            :: low latency
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "d3pclatency" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "lowlatency" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "node3dlowlatency" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmgspemaxftus" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmgspeminftus" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmgspcperiodus" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmlpwreiidlethresholdus" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmlpwrgridlethresholdus" /t reg_dword /d "1" /f >nul 2>&1
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmlpwrmsidlethresholdus" /t reg_dword /d "1" /f >nul 2>&1

            :: disable hdcp
            reg add "hklm\system\currentcontrolset\control\class\%%k" /v "rmhdcpkeyglobzero" /t reg_dword /d "1" /f >nul 2>&1
        )
    )
)

:: enable msi mode for nvidia gpu
for /f %%g in ('wmic path win32_videocontroller get pnpdeviceid ^| findstr /l "ven_"') do (
    reg add "hklm\system\currentcontrolset\enum\%%g\device parameters\interrupt management\messagesignalledinterruptproperties" /v "msisupported" /t reg_dword /d "1" /f >nul 2>&1
    reg add "hklm\system\currentcontrolset\enum\%%g\device parameters\interrupt management\affinity policy" /v "devicepriority" /t reg_dword /d "0" /f >nul 2>&1
)

:: nvidia hd audio d3cold fix (disable power sleep on hdmi audio to stop latency/popping)
for /f "tokens=*" %%i in ('reg query "hklm\system\currentcontrolset\control\class\{4d36e96c-e325-11ce-bfc1-08002be10318}" /s /f "nvidia high definition audio" 2^>nul ^| findstr "hkey"') do (
    reg add "%%i\powersettings" /v "conservationidletime" /t reg_binary /d "00000000" /f >nul 2>&1
    reg add "%%i\powersettings" /v "performanceidletime" /t reg_binary /d "00000000" /f >nul 2>&1
    reg add "%%i\powersettings" /v "idlepowerstate" /t reg_binary /d "00000000" /f >nul 2>&1
)

:: disable nvidia telemetry via image file execution redirect
reg add "hklm\software\microsoft\windows nt\currentversion\image file execution options\nvtelemetrycontainer.exe" /v "debugger" /t reg_sz /d "%windir%\system32\taskkill.exe" /f >nul 2>&1

:: disable dlss indicator and tray icon
reg add "hklm\software\nvidia corporation\global\ngxcore" /v "showdlssindicator" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\system\controlset001\services\nvlddmkm\parameters\nvtray" /v "startonlogin" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\system\controlset001\services\nvlddmkm\parameters\nvtray" /v "showinsedona" /t reg_dword /d "0" /f >nul 2>&1

:: disable nvidia container telemetry services
for %%s in ("nvtelemetrycontainer" "nvdisplay.containerls" "nvcplservice") do (
    sc config %%~s start= disabled >nul 2>&1
    net stop %%~s >nul 2>&1
)

echo %green%  [ok]%reset% nvidia tweaks applied.
call :done_msg


:: ---- amd tweaks ----
:amd_tweaks
echo %cyan%  [amd detected] applying driver registry tweaks...%reset%

set "amd_base=hklm\system\currentcontrolset\control\class\{4d36e968-e325-11ce-bfc1-08002be10318}"
set "amd_target="

for /f "tokens=*" %%a in ('reg query "%amd_base%" /k /f "*" ^| findstr /r "\\....$"') do (
    reg query "%%a" /v "providername" 2>nul | find /i "advanced micro devices, inc." >nul
    if !errorlevel! equ 0 (
        set "amd_target=%%a"
        goto :amd_apply
    )
)
echo %red%  [error]%reset% amd gpu not found in registry.
call :done_msg

:amd_apply
echo %cyan%  applying tweaks to: !amd_target!%reset%

:: telemetry / notifications
reg add "!amd_target!" /v "reportanalytics" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "notifysubscription" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "allowsubscription" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "showreleasenotes" /t reg_dword /d 0 /f >nul 2>&1

:: stutter and frame pacing
reg add "!amd_target!" /v "stuttermode" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_enableamdfendroptions" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_chillenabled" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_delagenabled" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_framepacingsupport" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_radeonboostenabled" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "daldisablestutter" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disableblockwrite" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablefbcsupport" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablefbcforfullscreenapp" /t reg_dword /d 1 /f >nul 2>&1

:: powerplay performance mode
reg add "!amd_target!" /v "pp_force3dperformancemode" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "pp_forcehighdpmlevel" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "pp_sclkdeepsleepdisable" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "pp_gfxoffcontrol" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "pp_enableracetoidle" /t reg_dword /d 0 /f >nul 2>&1

:: disable ulps (ultra low power state - causes boot hangs and stutters)
reg add "!amd_target!" /v "enableulps" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enableulps_na" /t reg_sz /d "0" /f >nul 2>&1
reg add "!amd_target!" /v "pp_disableulps" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_enableulps" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "kmd_forced3coldsupport" /t reg_dword /d 0 /f >nul 2>&1

:: pcie aspm disable
reg add "!amd_target!" /v "enableaspml0s" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enableaspml1" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enableaspml1ss" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "disableaspml0s" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disableaspml1" /t reg_dword /d 1 /f >nul 2>&1

:: clock gating disable
reg add "!amd_target!" /v "disablegfxclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablecvececlockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablesamuclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disableromgmcgclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablegfxcoarsegrainclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablegfxmediumgrainclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablegfxfinegrainclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablehdpmgclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "enablevceswclockgating" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enableuvdclockgating" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enablegfxclockgatingthrussmu" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enablesysclockgatingthrussmu" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "disablexdmasclkgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "dalfinegrainclockgating" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "disablerommediumgrainclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablenbiomediumgrainclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablemcmediumgrainclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "irqmgrdisableihclockgating" /t reg_dword /d 1 /f >nul 2>&1

:: power gating disable
reg add "!amd_target!" /v "disablegfxmgls" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablehdpclockpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disableuvdpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablevecepowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disableacppowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disabledrmdmapowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablegfxcgpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablestaticgfxmgpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disabledynamicgfxmgpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablecppowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablegdspowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablexdmapowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablegfxpipelinepowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablequickgfxmgpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "disablepowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "smu_disablemmhubpowergating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "smu_disableathubpowergating" /t reg_dword /d 1 /f >nul 2>&1

:: dal display clock
reg add "!amd_target!" /v "dalforcemaxdisplayclock" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "daldisableclockgating" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "daldisabledeepsleep" /t reg_dword /d 1 /f >nul 2>&1
reg add "!amd_target!" /v "daldisablediv2" /t reg_dword /d 1 /f >nul 2>&1

:: spread spectrum disable
reg add "!amd_target!" /v "enablespreadspectrum" /t reg_dword /d 0 /f >nul 2>&1
reg add "!amd_target!" /v "enablevcepllspreadspectrum" /t reg_dword /d 0 /f >nul 2>&1

:: disable amd crash / telemetry services
for %%s in ("amd crash defender service" "amdfendr" "amdfendrmgr" "amdlog") do (
    reg query "hklm\system\currentcontrolset\services\%%~s" >nul 2>&1
    if !errorlevel! equ 0 (
        reg add "hklm\system\currentcontrolset\services\%%~s" /v "start" /t reg_dword /d "4" /f >nul 2>&1
        net stop "%%~s" >nul 2>&1
    )
)

echo %green%  [ok]%reset% amd tweaks applied.
call :done_msg


:: ============================================================
:: 5 - cpu optimizations
:: ============================================================
:cpu_opts
call :section_header "cpu optimizations"

echo %cyan%  applying cpu tweaks...%reset%

:: boost foreground app priority
reg add "hklm\system\currentcontrolset\control\prioritycontrol" /v "win32priorityseparation" /t reg_dword /d "26" /f >nul 2>&1

:: global timer resolution request
reg add "hklm\system\currentcontrolset\control\session manager\kernel" /v "globaltimerresolutionrequests" /t reg_dword /d "1" /f >nul 2>&1

:: disable idle power savings on processor
powercfg /setacvalueindex scheme_current sub_processor idlestatethreshold 0 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor idledemote 0 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor idlepromote 0 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor idledisable 1 >nul 2>&1

echo %green%  [ok]%reset% cpu tweaks applied.
call :done_msg


:: ============================================================
:: 6 - pc clean
:: ============================================================
:pc_clean
call :section_header "pc clean"

echo %cyan%  cleaning temporary files...%reset%

rd /s /q "%temp%" >nul 2>&1
md "%temp%" >nul 2>&1
rd /s /q "%systemroot%\temp" >nul 2>&1
md "%systemroot%\temp" >nul 2>&1
rd /s /q "%systemroot%\prefetch" >nul 2>&1
md "%systemroot%\prefetch" >nul 2>&1
rd /s /q "%localappdata%\microsoft\windows\wer" >nul 2>&1
del /f /q "%systemroot%\*.log" >nul 2>&1
del /f /q "%systemroot%\minidump\*" >nul 2>&1
del /f /q "%systemroot%\memory.dmp" >nul 2>&1

:: flush windows update cache
net stop wuauserv >nul 2>&1
rd /s /q "%systemroot%\softwaredistribution\download" >nul 2>&1
net start wuauserv >nul 2>&1

:: flush dns
ipconfig /flushdns >nul 2>&1

echo %green%  [ok]%reset% pc cleaned.
call :done_msg


:: ============================================================
:: 7 - system debloat
:: ============================================================
:system_debloat
call :section_header "system debloat"

echo %cyan%  disabling telemetry and bloat services...%reset%

:: telemetry registry
reg add "hklm\software\policies\microsoft\windows\datacollection" /v "allowtelemetry" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\software\microsoft\windows\currentversion\policies\datacollection" /v "allowtelemetry" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\input\tipc" /v "enabled" /t reg_dword /d "0" /f >nul 2>&1

:: general bloat services
for %%s in (
    "sysmain" "diagtrack" "bam" "gameinputsvc" "acpipmi" "gpuenergydrv"
    "acpitime" "wpnservice" "wercplsupport"
    "diagnosticshub.standardcollector.service" "mcpmanagementservice"
    "wmiacpi" "prm" "edgeupdate" "kdnic" "wsearch"
    "compositebus" "sessionenv" "pla" "netlogon" "ndu" "wecsvc" "wersvc"
    "diagsvc" "intelpmt" "dusmsvc" "vdrvroot" "dmwappushservice" "pcasvc"
    "dps" "rmsvc" "svsvc" "vid" "acpipagr" "luafv" "rdpbus" "dssvc"
    "wdisystemhost" "dam" "wdiservicehost" "umbus" "troubleshootingsvc" "wmiapsrv"
) do (
    sc config %%s start= disabled >nul 2>&1
    net stop %%s >nul 2>&1
)

echo %green%  [ok]%reset% core bloat services disabled.
echo.

:: optional groups
choice /c yn /n /m "%yellow%  disable printer services? [y/n]: %reset%"
if %errorlevel%==1 (
    for %%s in ("printnotify" "spooler" "usbprint" "printscanbrokerservice" "printworkflowusersvc" "printdeviceconfigurationservice" "stisvc") do (
        sc config %%~s start= disabled >nul 2>&1
        net stop %%~s >nul 2>&1
    )
    echo %green%  [ok]%reset% printer services disabled.
)

choice /c yn /n /m "%yellow%  disable bluetooth services? [y/n]: %reset%"
if %errorlevel%==1 (
    for %%s in ("bluetoothuserservice" "bthusb" "bthmodem" "bthport" "btagservice" "bthenum" "rfcomm" "bthhfenum" "bthleenum" "bthmini" "microsoft_bluetooth_avrcptransport" "bthavctpsvc" "btha4dp" "hidbth" "bthserv") do (
        sc config %%~s start= disabled >nul 2>&1
        net stop %%~s >nul 2>&1
    )
    echo %green%  [ok]%reset% bluetooth services disabled.
)

choice /c yn /n /m "%yellow%  disable vpn services? [y/n]: %reset%"
if %errorlevel%==1 (
    for %%s in ("winhttpautoproxysvc" "ikeext" "sstpsvc" "rasman" "ndisvirtualbus" "iphlpsvc") do (
        sc config %%~s start= disabled >nul 2>&1
        net stop %%~s >nul 2>&1
    )
    echo %green%  [ok]%reset% vpn services disabled.
)

choice /c yn /n /m "%red%  disable windows defender? [y/n] (extreme - tamper protection must be off): %reset%"
if %errorlevel%==1 (
    reg add "hklm\software\policies\microsoft\windows defender" /v "disableantispyware" /t reg_dword /d "1" /f >nul 2>&1
    reg add "hklm\software\policies\microsoft\windows defender\real-time protection" /v "disablerealtimemonitoring" /t reg_dword /d "1" /f >nul 2>&1
    sc config windefend start= disabled >nul 2>&1
    sc config securityhealthservice start= disabled >nul 2>&1
    sc config sense start= disabled >nul 2>&1
    echo %green%  [ok]%reset% windows defender disabled.
)

call :done_msg


:: ============================================================
:: 8 - storage optimizations
:: ============================================================
:storage_opts
call :section_header "storage optimizations"

echo %cyan%  applying storage tweaks...%reset%

:: disable ntfs last access time
fsutil behavior set disablelastaccess 1 >nul 2>&1

:: disable 8.3 short name creation
fsutil behavior set disable8dot3 1 >nul 2>&1

:: ntfs memory usage
fsutil behavior set memoryusage 2 >nul 2>&1

:: registry mirror
reg add "hklm\system\currentcontrolset\control\filesystem" /v "ntfsdisable8dot3namecreation" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\filesystem" /v "ntfsdisablelastaccess" /t reg_dword /d "1" /f >nul 2>&1

:: trim ssd drives
for /f "tokens=1" %%d in ('wmic logicaldisk where "drivetype=3" get deviceid 2^>nul ^| findstr ":"') do (
    defrag %%d /u /v /retrim >nul 2>&1
)

echo %green%  [ok]%reset% storage tweaks applied.
call :done_msg


:: ============================================================
:: 9 - memory optimizations
:: ============================================================
:memory_opts
call :section_header "memory optimizations"

echo %cyan%  applying memory tweaks...%reset%

:: keep kernel in ram
reg add "hklm\system\currentcontrolset\control\session manager\memory management" /v "disablepagingexecutive" /t reg_dword /d "1" /f >nul 2>&1

:: large system cache off (favor apps not disk cache)
reg add "hklm\system\currentcontrolset\control\session manager\memory management" /v "largesystemcache" /t reg_dword /d "0" /f >nul 2>&1

:: svchost split (one process per service - better isolation and responsiveness)
reg add "hklm\system\controlset001\control" /v "svchostsplitthresholdinkb" /t reg_dword /d "4294967295" /f >nul 2>&1

:: prefetch on, superfetch off
reg add "hklm\system\currentcontrolset\control\session manager\memory management\prefetchparameters" /v "enableprefetcher" /t reg_dword /d "3" /f >nul 2>&1
reg add "hklm\system\currentcontrolset\control\session manager\memory management\prefetchparameters" /v "enablesuperfetch" /t reg_dword /d "0" /f >nul 2>&1

:: don't clear page file at shutdown
reg add "hklm\system\currentcontrolset\control\session manager\memory management" /v "clearpagefileatshutdown" /t reg_dword /d "0" /f >nul 2>&1

echo %green%  [ok]%reset% memory tweaks applied.
call :done_msg


:: ============================================================
:: 10 - additional / qol
:: ============================================================
:additional_qol
call :section_header "additional / qol tweaks"

echo %cyan%  applying qol and ui tweaks...%reset%

:: dark mode and no transparency
reg add "hkcu\software\microsoft\windows\currentversion\themes\personalize" /v "appsuselighttheme" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\themes\personalize" /v "systemuseslighttheme" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\themes\personalize" /v "enabletransparency" /t reg_dword /d "0" /f >nul 2>&1

:: disable settings cloud sync
reg add "hkcu\software\microsoft\windows\currentversion\settingsync" /v "syncpolicy" /t reg_dword /d "5" /f >nul 2>&1
reg add "hklm\software\policies\microsoft\windows\settingsync" /v "disablesettingssync" /t reg_dword /d "2" /f >nul 2>&1
reg add "hklm\software\policies\microsoft\windows\settingsync" /v "disablesettingssyncuseroverride" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\software\policies\microsoft\windows\settingsync" /v "disablesynconpaidnetwork" /t reg_dword /d "1" /f >nul 2>&1
for %%g in (accessibility appsync browsersettings credentials desktoptheme language packagestate personalization startlayout windows) do (
    reg add "hkcu\software\microsoft\windows\currentversion\settingsync\groups\%%g" /v "enabled" /t reg_dword /d "0" /f >nul 2>&1
)

:: taskbar cleanup
reg add "hkcu\software\microsoft\windows\currentversion\explorer\advanced" /v "showtaskviewbutton" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\explorer\advanced" /v "taskbarda" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\search" /v "searchboxtaskbarmode" /t reg_dword /d "0" /f >nul 2>&1

:: align taskbar left
reg add "hkcu\software\microsoft\windows\currentversion\explorer\advanced" /v "taskbaral" /t reg_dword /d "0" /f >nul 2>&1

:: disable game bar and dvr
reg add "hkcu\software\microsoft\gamebar" /v "allowautogamemode" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\gamebar" /v "autogamemodeenabled" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\gamebar" /v "gamepanelstartuptipindex" /t reg_dword /d "3" /f >nul 2>&1
reg add "hkcu\software\microsoft\gamebar" /v "showstartuppanel" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\gamebar" /v "usenexusforgamebarenabled" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\gamedvr" /v "appcaptureenabled" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\software\policies\microsoft\windows\gamedvr" /v "allowgamedvr" /t reg_dword /d "0" /f >nul 2>&1
reg add "hklm\software\microsoft\policymanager\default\applicationmanagement\allowgamedvr" /v "value" /t reg_dword /d "0" /f >nul 2>&1

:: classic context menu windows 11
reg add "hkcu\software\classes\clsid\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\inprocserver32" /ve /t reg_sz /d "" /f >nul 2>&1

:: hide start menu recommended section
reg add "hklm\software\policies\microsoft\windows\explorer" /v "hiderecommendedsection" /t reg_dword /d "1" /f >nul 2>&1
reg add "hklm\software\microsoft\policymanager\current\device\start" /v "hiderecommendedsection" /t reg_dword /d "1" /f >nul 2>&1

:: file explorer
reg add "hkcu\software\microsoft\windows\currentversion\explorer\advanced" /v "hidefileext" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\explorer\advanced" /v "disallowshaking" /t reg_dword /d "1" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\policies\explorer" /v "noinstrumentation" /t reg_dword /d "1" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\explorer\advanced" /v "dontprettypath" /t reg_dword /d "1" /f >nul 2>&1

:: remove bloat folders from this pc view
for %%k in (
    "{088e3905-0323-4b02-9826-5d99428e115f}"
    "{1cf1260c-4dd0-4ebb-811f-33c572699fde}"
    "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
    "{374de290-123f-4565-9164-39c4925e467b}"
    "{3add1653-eb32-4cb0-bbd7-dfa0abb5acca}"
    "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
    "{a0953c92-50dc-43bf-be83-3742fed03c9c}"
    "{a8cdff1c-4878-43be-b5fd-f8091c1c60d0}"
    "{b4bfcc3a-db2c-424c-b029-7fe99a87c641}"
    "{d3162b92-9365-467a-956b-92703aca08af}"
    "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
) do (
    reg delete "hklm\software\microsoft\windows\currentversion\explorer\mycomputer\namespace\%%k" /f >nul 2>&1
)

:: disable sleep study
wevtutil.exe set-log "microsoft-windows-sleepstudy/diagnostic" /e:false >nul 2>&1
wevtutil.exe set-log "microsoft-windows-kernel-processor-power/diagnostic" /e:false >nul 2>&1
wevtutil.exe set-log "microsoft-windows-usermodepowerservice/diagnostic" /e:false >nul 2>&1
schtasks /change /tn "\microsoft\windows\power efficiency diagnostics\analyzesystem" /disable >nul 2>&1

:: ps1 open with powershell by default
reg add "hkey_classes_root\microsoft.powershellscript.1\shell\open\command" /ve /t reg_sz /d "\"%windir%\system32\windowspowershell\v1.0\powershell.exe\" -file \"%%1\"" /f >nul 2>&1

:: remove shortcut arrow overlay
reg add "hklm\software\microsoft\windows\currentversion\explorer\shell icons" /v "29" /t reg_sz /d "" /f >nul 2>&1

:: disable cortana
reg add "hklm\software\policies\microsoft\windows\windows search" /v "allowcortana" /t reg_dword /d "0" /f >nul 2>&1
reg add "hkcu\software\microsoft\windows\currentversion\search" /v "bingsearchenabled" /t reg_dword /d "0" /f >nul 2>&1

echo %green%  [ok]%reset% qol tweaks applied.
call :done_msg


:: ============================================================
:: 11 - uninstall useless apps
:: ============================================================
:uninstall_apps
call :section_header "uninstall useless apps"

echo %cyan%  removing pre-installed windows bloatware...%reset%

powershell -command "$apps = @('microsoft.microsoftsolitairecollection','microsoft.bingweather','microsoft.bingnews','microsoft.bingsports','microsoft.bingfinance','microsoft.gethelp','microsoft.getstarted','microsoft.mixedreality.portal','microsoft.windowsfeedbackhub','microsoft.windowsmaps','microsoft.zunemusic','microsoft.zunevideo','microsoft.windowscommunicationsapps','microsoft.skypeapp','microsoft.people','microsoft.print3d','microsoft.3dbuilder','clipchamp.clipchamp','microsoft.549981c3f5f10','microsoft.msteams','cortana'); foreach ($app in $apps) { get-appxpackage -name $app -allusers | remove-appxpackage -allusers -ea silentlycontinue; get-appxprovisionedpackage -online | where displayname -like $app | remove-appxprovisionedpackage -online -ea silentlycontinue }" 2>nul

echo %green%  [ok]%reset% bloatware removed.
call :done_msg


:: ============================================================
:: 12 - network optimizations
:: ============================================================
:network_opts
call :section_header "network optimizations"

echo %cyan%  applying network and tcp tweaks...%reset%

:: tcp global settings
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global initialtothreshold=65535 >nul 2>&1

:: nagle's algorithm disable per interface
for /f "tokens=*" %%i in ('powershell -noprofile -command "(get-ciminstance -classname win32_networkadapter | select-object -expandproperty guid | where-object { $_ -like ''*{*'' })"') do (
    reg add "hklm\system\currentcontrolset\services\tcpip\parameters\interfaces\%%i" /v "tcpdelackticks" /t reg_dword /d "0" /f >nul 2>&1
    reg add "hklm\system\currentcontrolset\services\tcpip\parameters\interfaces\%%i" /v "tcpackfrequency" /t reg_dword /d "1" /f >nul 2>&1
)

:: network adapter advanced tweaks
for /f %%p in ('reg query "hklm\system\currentcontrolset\control\class\{4d36e972-e325-11ce-bfc1-08002be10318}" /v "*SpeedDuplex" /s 2^>nul ^| findstr "hkey"') do (
    reg.exe add "%%p" /v "enableadaptivequeuing" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*priorityvlantag" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*interruptmoderation" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "dynamicltr" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablecoalesce" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "vmqsupported" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*storebadpackets" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enabletss" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "storebadpackets" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "drophighlyfragmentedpacket" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "allowflowcontrolframes" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*vmq" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*wakeonpattern" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*devicesleepongdisconnect" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*selectivesuspend" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*nicautopowersaver" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*pmwifirekeyoffload" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*modernstandbywolmagicpacket" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*ssidletimeout" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*wakeonmagicpacket" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "eeelinhadvertisement" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "eeephyenable" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*eee" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*enabledynamicpowergating" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*flowcontrol" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "*tcpchecksumoffloadipv6" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*lsov2ipv4" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*pmarpoffload" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*usoipv6" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*tcpudpchecksumoffloadipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*ipchecksumoffloadipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*lsov2ipv6" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*udpchecksumoffloadipv6" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*tcpconnectionoffloadipv6" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*pmnsoffload" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*usoipv4" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*tcpconnectionoffloadipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*udprsc" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*ipsecoffloadv2ipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*udpchecksumoffloadipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*tcpchecksumoffloadipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*ipsecoffloadv2" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*rscipv6" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*lsov1ipv4" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*rscipv4" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*ipsecoffloadv1ipv4" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "*tcpudpchecksumoffloadipv6" /t reg_sz /d 3 /f >nul 2>&1
    reg.exe add "%%p" /v "forcersccenabled" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*packetdirect" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*encapsulatedpackettaskoffloadvxlan" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*encapsulatedpackettaskoffload" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "*encapsulatedpackettaskoffloadnvgre" /t reg_sz /d 1 /f >nul 2>&1
    reg.exe add "%%p" /v "wakeonmagicpacketfroms5" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablegreenethernet" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "powersavingmode" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablepme" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "wakeonlink" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "allowallspeedslplu" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablephyflexiblespeed" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enabled3coldins0" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "savepowerenabled" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablemodernstandby" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "reducespeedonpowerdown" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "powerdownpll" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "loglinkestateevent" /t reg_sz /d 16 /f >nul 2>&1
    reg.exe add "%%p" /v "ulpmode" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "obffenabled" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablepowermanagement" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablephywakeup" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "waitautonegcomplete" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enableaspm" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "enablesavepowernow" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "wakeupmodecap" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "autopowersavemodeenabled" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "gigalite" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "ltrobff" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "dmacoalescing" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "latencytolerancereporting" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "s5wakeonlan" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "wakeon" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "wakefroms5" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "pnpcapabilities" /t reg_dword /d 24 /f >nul 2>&1
    reg.exe add "%%p" /v "s0mgcpkt" /t reg_sz /d 0 /f >nul 2>&1
    reg.exe add "%%p" /v "wolshutdownlinkspeed" /t reg_sz /d 2 /f >nul 2>&1
    reg.exe add "%%p" /v "wakeonslot" /t reg_sz /d 0 /f >nul 2>&1
)

:: disable useless network bindings
powershell -command "disable-netadapterbinding -name '*' -componentid 'ms_server','ms_lltdio','ms_msclient','ms_lldp','ms_rspndr','ms_implat' -confirm:$false" >nul 2>&1

:: disable receive segment coalescing and packet coalescing
powershell -command "set-netoffloadglobalsetting -receivesegmentcoalescing disabled" >nul 2>&1
powershell -command "set-netoffloadglobalsetting -packetcoalescingfilter disabled" >nul 2>&1

echo %green%  [ok]%reset% network tweaks applied.
call :done_msg


:: ============================================================
:: apply all
:: ============================================================
:apply_all
call :section_header "apply all tweaks"

echo %magenta%  applying all rapidtweaks modules sequentially...%reset%
echo %gray%  this may take several minutes. do not close this window.%reset%
echo.

echo %cyan%  [1/12]%reset% general system...
call :general_system_run

echo %cyan%  [2/12]%reset% power...
call :power_run

echo %cyan%  [3/12]%reset% keyboard and mouse...
call :kb_run

echo %cyan%  [4/12]%reset% gpu (will detect vendor)...
call :gpu_run

echo %cyan%  [5/12]%reset% cpu...
call :cpu_run

echo %cyan%  [6/12]%reset% pc clean...
call :clean_run

echo %cyan%  [7/12]%reset% system debloat (will prompt for optional groups)...
call :system_debloat

echo %cyan%  [8/12]%reset% storage...
call :storage_run

echo %cyan%  [9/12]%reset% memory...
call :memory_run

echo %cyan%  [10/12]%reset% additional qol...
call :qol_run

echo %cyan%  [11/12]%reset% uninstall bloatware...
call :apps_run

echo %cyan%  [12/12]%reset% network...
call :net_run

echo.
echo %green%%bold%  all modules complete!%reset%
echo %yellow%  restart your pc to apply all changes fully.%reset%
echo.
pause
goto :main_menu

:: silent runners for apply-all (skip menu return)
:general_system_run
call :general_system >nul 2>&1
exit /b

:power_run
call :power_opts >nul 2>&1
exit /b

:kb_run
call :keyboard_mouse >nul 2>&1
exit /b

:gpu_run
call :gpu_opts
exit /b

:cpu_run
call :cpu_opts >nul 2>&1
exit /b

:clean_run
call :pc_clean >nul 2>&1
exit /b

:storage_run
call :storage_opts >nul 2>&1
exit /b

:memory_run
call :memory_opts >nul 2>&1
exit /b

:qol_run
call :additional_qol >nul 2>&1
exit /b

:apps_run
call :uninstall_apps >nul 2>&1
exit /b

:net_run
call :network_opts >nul 2>&1
exit /b


:: ============================================================
:: create restore point
:: ============================================================
:create_restore
call :section_header "create restore point"

echo %cyan%  creating system restore point...%reset%

powershell -command "enable-computerrestore -drive '%systemdrive%\'" >nul 2>&1
powershell -command "checkpoint-computer -description 'rapidtweaks - pre-tweak backup' -restorepttype 'modify_settings'" 2>nul

if %errorlevel% equ 0 (
    echo %green%  [ok]%reset% restore point created: rapidtweaks - pre-tweak backup
) else (
    echo %yellow%  [warn]%reset% restore point failed. disable the 24h restriction or try again.
)

echo.
pause
goto :main_menu


:: ============================================================
:: exit
:: ============================================================
:exit_script
cls
echo.
echo %magenta%%bold%  rapidtweaks%reset% %gray%^|%reset% %white%goodbye. restart your pc to apply all changes.%reset%
echo.
timeout /t 2 /nobreak >nul
exit /b 0
