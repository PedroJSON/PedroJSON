@echo off
echo Publish PedroJSON with Custom Version
echo =====================================
echo.

if "%1"=="" (
    echo Usage: publish-version.bat [version]
    echo Example: publish-version.bat 1.0.5-alpha
    echo.
    echo Current version detection:
    call gradlew :loader:properties | findstr "version:"
    echo.
    echo To publish with current version, just run:
    echo gradlew :loader:publishGprPublicationToGitHubPackagesRepository
    echo.
    pause
    exit /b 1
)

set VERSION=%1
echo Publishing version: %VERSION%
echo.

echo Setting environment variable...
set RELEASE_VERSION=%VERSION%

echo Building with version %VERSION%...
call gradlew :loader:assembleRelease
if %errorlevel% neq 0 (
    echo ❌ Build failed!
    pause
    exit /b 1
)

echo ✅ Build successful!
echo.

echo Publishing to GitHub Packages...
call gradlew :loader:publishGprPublicationToGitHubPackagesRepository
if %errorlevel% neq 0 (
    echo ❌ Publishing failed!
    echo Make sure your GitHub credentials are correct in local.properties
    pause
    exit /b 1
)

echo.
echo 🎉 Successfully published version %VERSION% to GitHub Packages!
echo.
echo Your library is now available at:
echo https://github.com/pedrojson/PedroJSON/packages
echo.
echo Users can use it with:
echo dependencies {
echo     implementation 'com.pedrojson:pedrojson-loader:%VERSION%'
echo }
echo.

pause
