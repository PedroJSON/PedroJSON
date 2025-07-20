@echo off
echo Testing Version Extraction
echo ============================
echo.

echo Current version detection:
echo.

echo 1. Checking for RELEASE_VERSION environment variable:
if defined RELEASE_VERSION (
    echo    ✅ RELEASE_VERSION = %RELEASE_VERSION%
) else (
    echo    ❌ RELEASE_VERSION not set
)
echo.

echo 2. Checking for Git tags:
git describe --tags --exact-match HEAD 2>nul
if %errorlevel% equ 0 (
    echo    ✅ Current commit has a Git tag
) else (
    echo    ❌ Current commit has no Git tag
)
echo.

echo 3. Testing Gradle version resolution:
call gradlew :loader:properties | findstr "version:"
echo.

echo To test with a specific version:
echo set RELEASE_VERSION=1.0.5-alpha
echo gradlew :loader:assembleRelease
echo.

echo To publish with current version:
echo gradlew :loader:publishGprPublicationToGitHubPackagesRepository
echo.

pause
