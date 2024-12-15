@echo off
:: Orkitt: Flutter Project Automation Script for Windows
:: Usage: orkitt <command> [project_name]
:: Commands:
::   create <project_name>      - Create a new Flutter project with template
::   run [platform]             - Run the Flutter project (defaults to 'all')
::   build <platform>           - Build release APK, IPA, or web
::   clean                      - Clean build and cache
::   pub-get                    - Run 'flutter pub get'
::   help                       - Show this help menu

set TEMPLATE_DIR=%USERPROFILE%\Templates\orkitt_template  :: Directory containing the template
set FLUTTER_CMD=flutter

:: Create Project Function
:create_project
set project_name=%1
set project_path=%CD%\%project_name%

if "%project_name%"=="" (
    echo Error: Project name is required for 'create' command
    exit /b 1
)

if exist "%project_path%" (
    echo Error: Project "%project_name%" already exists in the current directory
    exit /b 1
)

echo Creating new Flutter project: %project_name%
%FLUTTER_CMD% create "%project_path%"

:: Navigate into the project directory
cd "%project_path%"

echo Copying template into %project_name%\lib...
xcopy /E /I /H "%TEMPLATE_DIR%" "%project_path%\lib\"

echo Updating imports to match project name: %project_name%
for /R "%project_path%\lib" %%f in (*.dart) do (
    powershell -Command "(Get-Content '%%f') -replace 'template_project', '%project_name%' | Set-Content '%%f'"
)

echo Creating assets directories...
mkdir "%project_path%\assets\fonts"
mkdir "%project_path%\assets\images"
mkdir "%project_path%\assets\icons"

echo Removing comments from pubspec.yaml...
powershell -Command "(Get-Content '%project_path%\pubspec.yaml') | Where-Object {$_ -notmatch '^\s*#.*$'} | Set-Content '%project_path%\pubspec.yaml'"

echo Updating pubspec.yaml with assets and dependencies...
echo. >> "%project_path%\pubspec.yaml"
echo assets: >> "%project_path%\pubspec.yaml"
echo. >> "%project_path%\pubspec.yaml"
echo   - assets/images/ >> "%project_path%\pubspec.yaml"
echo   - assets/fonts/ >> "%project_path%\pubspec.yaml"
echo   - assets/icons/ >> "%project_path%\pubspec.yaml"
echo. >> "%project_path%\pubspec.yaml"

goto :EOF

:: Run Project Function
:run_project
set platform=%1
if "%platform%"=="" set platform=all

:: Make sure we're in the correct project directory
if not exist "pubspec.yaml" (
    echo Error: No pubspec.yaml file found. Please create the project first.
    exit /b 1
)

echo Running Flutter project on %platform%...
%FLUTTER_CMD% run -d %platform%

goto :EOF

:: Build Release Function
:build_release
set platform=%1
if "%platform%"=="" (
    echo Error: Platform (apk, ipa, or web) is required for 'build' command
    exit /b 1
)

:: Make sure we're in the correct project directory
if not exist "pubspec.yaml" (
    echo Error: No pubspec.yaml file found. Please create the project first.
    exit /b 1
)

if "%platform%"=="apk" (
    echo Building APK release...
    %FLUTTER_CMD% build apk --release
)

if "%platform%"=="ipa" (
    echo Building IPA release...
    %FLUTTER_CMD% build ipa --release
)

if "%platform%"=="web" (
    echo Building web release...
    %FLUTTER_CMD% build web --release
)

goto :EOF

:: Clean Project Function
:clean_project
:: Make sure we're in the correct project directory
if not exist "pubspec.yaml" (
    echo Error: No pubspec.yaml file found. Please create the project first.
    exit /b 1
)

echo Cleaning Flutter build and cache...
%FLUTTER_CMD% clean
%FLUTTER_CMD% pub cache repair
echo Clean completed!

goto :EOF

:: Run Pub Get Function
:pub_get
:: Make sure we're in the correct project directory
if not exist "pubspec.yaml" (
    echo Error: No pubspec.yaml file found. Please create the project first.
    exit /b 1
)

echo Running 'flutter pub get'...
%FLUTTER_CMD% pub get
echo "'flutter pub get' completed!"

goto :EOF

:: Display Help Function
:display_help
echo Orkitt: Flutter Project Automation Script
echo Usage: orkitt <command> [arguments]
echo Commands:
echo   create <project_name>      - Create a new Flutter project with template
echo   run [platform]            - Run the Flutter project (defaults to 'all')
echo   build <platform>          - Build release APK, IPA, or web
echo   clean                     - Clean build and cache
echo   pub-get                  - Run 'flutter pub get'
echo   help                      - Show this help menu

goto :EOF

:: Main menu loop
:menu
cls
echo Orkitt: Flutter Project Automation Script
echo.
echo 1. Create a new project
echo 2. Run Flutter project
echo 3. Build release (APK, IPA, or Web)
echo 4. Clean project
echo 5. Run 'flutter pub get'
echo 6. Display help
echo 7. Exit
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" (
    set /p project_name="Enter the project name: "
    call :create_project %project_name%
)

if "%choice%"=="2" (
    set /p platform="Enter the platform to run (apk, ipa, web, or all): "
    call :run_project %platform%
)

if "%choice%"=="3" (
    set /p platform="Enter the platform to build (apk, ipa, web): "
    call :build_release %platform%
)

if "%choice%"=="4" (
    call :clean_project
)

if "%choice%"=="5" (
    call :pub_get
)

if "%choice%"=="6" (
    call :display_help
)

if "%choice%"=="7" (
    echo Exiting script...
    exit /b 0
)

goto :menu

