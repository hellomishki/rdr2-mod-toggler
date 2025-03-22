@echo off
setlocal

:: ==========================================================================
:: RDR2 Mod Toggler - Configuration Section
:: ==========================================================================
:: IMPORTANT: Change these paths to match your system before using!
:: Common Steam path: C:\Program Files (x86)\Steam\steamapps\common\Red Dead Redemption 2
:: Change below suit your needs
set "RDR2_FOLDER=C:\path\to\Red Dead Redemption 2"
set "MODS_BACKUP=C:\path\to\mods_backup"

:: List of common mod files - Add or remove files as needed for your specific mods
:: Each filename should be separated by a space
set "MOD_FILES=asiloader.log dinput8.dll dlsstweaks.ini"

:: List of common mod folders - Add or remove folders as needed for your specific mods
:: Each folder name should be separated by a space
set "MOD_FOLDERS=LennysSimpleTrainer lml reshade-shaders"
:: ==========================================================================

title RDR2 Mod Toggler
echo =========================================
echo         RDR2 Mod Toggler v1.0
echo =========================================
echo.

:: Check if paths have been configured
if "%RDR2_FOLDER%"=="C:\path\to\Red Dead Redemption 2" (
    echo IMPORTANT: You need to configure this script before using it.
    echo.
    echo 1. Right-click on RDR2_Mod_Toggler.bat and select Edit, Notepad works fine
    echo 2. Change the RDR2_FOLDER path to your RDR2 installation
    echo    Example: C:\Program Files (x86)\Steam\steamapps\common\Red Dead Redemption 2
    echo 3. Change the MODS_BACKUP path to where you want mod files stored
    echo    Example: C:\RDR2_Mods_Backup
    echo 4. Update MOD_FILES and MOD_FOLDERS lists to match your own
    echo.
    echo Press any key to exit...
    pause > nul
    exit /b
)

:: Validate paths
if not exist "%RDR2_FOLDER%" (
    echo ERROR: RDR2 folder not found at "%RDR2_FOLDER%"
    echo Please edit the script to set the correct path.
    goto :END
)

:: Check if the backup folder exists, if not create it
if not exist "%MODS_BACKUP%" mkdir "%MODS_BACKUP%"

:: Detect Steam running
tasklist /fi "imagename eq steam.exe" | find /i "steam.exe" > nul
if not errorlevel 1 (
    echo WARNING: Steam is currently running.
    echo It's recommended to close Steam before switching mods.
    echo.
    choice /c YN /m "Continue anyway? (Y/N)"
    if errorlevel 2 goto :END
    echo.
)

:: Show menu instead of automatic toggle
if exist "%MODS_BACKUP%\.mods_active" (
    echo Mods are currently ACTIVE [Story Mode]
) else (
    echo Mods are currently DISABLED [Online Mode]
)
echo.
echo Choose an option:
echo [1] Enable Mods (for Story Mode)
echo [2] Disable Mods (for Red Dead Online)
echo [3] Exit
echo.
choice /c 123 /n /m "Enter your choice (1-3): "

if errorlevel 3 goto :END
if errorlevel 2 goto :DISABLE_MODS
if errorlevel 1 goto :ENABLE_MODS

:DISABLE_MODS
echo.
echo Disabling mods for Red Dead Online...

:: Move each mod file to backup (now to root backup folder)
for %%f in (%MOD_FILES%) do (
    if exist "%RDR2_FOLDER%\%%f" (
        echo Moving %%f to backup...
        move /Y "%RDR2_FOLDER%\%%f" "%MODS_BACKUP%\%%f"
    )
)

:: Move each mod folder to backup
for %%d in (%MOD_FOLDERS%) do (
    if exist "%RDR2_FOLDER%\%%d" (
        echo Moving %%d folder to backup...
        if not exist "%MODS_BACKUP%\%%d" mkdir "%MODS_BACKUP%\%%d"
        xcopy /E /I /Y "%RDR2_FOLDER%\%%d" "%MODS_BACKUP%\%%d"
        rd /S /Q "%RDR2_FOLDER%\%%d"
    )
)

:: Look for any remaining .asi files (common mod files)
for %%f in ("%RDR2_FOLDER%\*.asi") do (
    echo Found additional mod file: %%~nxf
    move /Y "%%f" "%MODS_BACKUP%\%%~nxf"
)

:: Remove the status file to indicate mods are now disabled
if exist "%MODS_BACKUP%\.mods_active" del "%MODS_BACKUP%\.mods_active"

echo.
echo Mods disabled! You can now play Red Dead Online.
echo Creating shortcut to launch Red Dead Online directly...

:: Create a shortcut to launch RDO directly
echo @echo off > "%USERPROFILE%\Desktop\Launch RDO.bat"
echo start steam://rungameid/1404210 >> "%USERPROFILE%\Desktop\Launch RDO.bat"
echo Created shortcut on desktop: "Launch RDO.bat"

goto :END

:ENABLE_MODS
echo.
echo Enabling mods for Story Mode...

:: Check if we have mods backed up
set "FOUND_MODS=0"
for %%f in (%MOD_FILES%) do (
    if exist "%MODS_BACKUP%\%%f" set "FOUND_MODS=1"
)
for %%d in (%MOD_FOLDERS%) do (
    if exist "%MODS_BACKUP%\%%d" set "FOUND_MODS=1"
)

if "%FOUND_MODS%"=="0" (
    echo No mod files or folders found in the backup folder.
    echo Make sure you've run this script at least once with mods installed.
    goto :END
)

:: Check mod files in game directory and only restore if they're missing
set "RESTORED_FILES=0"
for %%f in (%MOD_FILES%) do (
    if exist "%MODS_BACKUP%\%%f" (
        if not exist "%RDR2_FOLDER%\%%f" (
            echo Restoring %%f...
            move /Y "%MODS_BACKUP%\%%f" "%RDR2_FOLDER%\%%f"
            set /a "RESTORED_FILES+=1"
        )
    )
)

:: Check for other backed up files that might not be in our list
for %%f in ("%MODS_BACKUP%\*.asi" "%MODS_BACKUP%\*.dll" "%MODS_BACKUP%\*.log" "%MODS_BACKUP%\*.ini") do (
    if not exist "%RDR2_FOLDER%\%%~nxf" (
        echo Restoring additional file: %%~nxf...
        move /Y "%%f" "%RDR2_FOLDER%\%%~nxf"
        set /a "RESTORED_FILES+=1"
    )
)

:: Check each mod folder and only restore if missing in game directory
set "RESTORED_FOLDERS=0"
for %%d in (%MOD_FOLDERS%) do (
    if exist "%MODS_BACKUP%\%%d" (
        if not exist "%RDR2_FOLDER%\%%d" (
            echo Restoring %%d folder...
            if not exist "%RDR2_FOLDER%\%%d" mkdir "%RDR2_FOLDER%\%%d"
            xcopy /E /I /Y "%MODS_BACKUP%\%%d" "%RDR2_FOLDER%\%%d"
            set /a "RESTORED_FOLDERS+=1"
        )
    )
)

:: Summary of what was done
if %RESTORED_FILES% EQU 0 (
    if %RESTORED_FOLDERS% EQU 0 (
        echo All mod files and folders already present in game directory.
        echo No restoration needed.
    ) else (
        echo Restored %RESTORED_FOLDERS% mod folders to game directory.
    )
) else (
    if %RESTORED_FOLDERS% EQU 0 (
        echo Restored %RESTORED_FILES% mod files to game directory.
    ) else (
        echo Restored %RESTORED_FILES% mod files and %RESTORED_FOLDERS% folders to game directory.
    )
)

:: Create a status file to keep track of mod state
echo. > "%MODS_BACKUP%\.mods_active"

echo.
echo Mods enabled! You can now play Story Mode with mods.
echo Creating shortcut to launch RDR2 Story Mode directly...

:: Create a shortcut to launch Story Mode directly
echo @echo off > "%USERPROFILE%\Desktop\Launch RDR2 Story.bat"
echo start steam://rungameid/1174180 >> "%USERPROFILE%\Desktop\Launch RDR2 Story.bat"
echo Created shortcut on desktop: "Launch RDR2 Story.bat"

goto :END

:END
echo.
echo =========================================
echo Press any key to exit...
pause > nul
endlocal
