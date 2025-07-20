@echo off
echo PedroJSON Library - Publishing Verification
echo ==========================================
echo.

echo Checking local Maven repository...
set MAVEN_PATH=%USERPROFILE%\.m2\repository\com\pedrojson\pedrojson-loader\1.0.4-alpha
if exist "%MAVEN_PATH%" (
    echo ✅ Library found in local Maven repository
    echo    Location: %MAVEN_PATH%
    echo.
    echo    Generated artifacts:
    dir /b "%MAVEN_PATH%"
    echo.
) else (
    echo ❌ Library not found in local Maven repository
    echo    Run publish.bat first
    pause
    exit /b 1
)

echo Library is ready for remote publishing!
echo.

echo Next steps:
echo 1. Set up Sonatype OSSRH account (see MAVEN_CENTRAL_GUIDE.md)
echo 2. Generate GPG keys (run setup-gpg.bat)
echo 3. Update local.properties with credentials
echo 4. Publish to Maven Central:
echo    gradlew :loader:publishMavenPublicationToOSSRHRepository
echo.

echo Or publish to GitHub Packages immediately:
echo 1. Set GitHub credentials in local.properties
echo 2. Run: gradlew :loader:publishGprPublicationToGitHubPackagesRepository
echo.

pause
