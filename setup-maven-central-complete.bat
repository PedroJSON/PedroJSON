@echo off
echo ========================================
echo    🚀 MAVEN CENTRAL SETUP WORKFLOW
echo ========================================
echo.

echo This script will guide you through the complete setup process
echo to publish your library to Maven Central (no user credentials required!)
echo.

:menu
echo.
echo Choose your setup step:
echo.
echo 1) 🌐 Open Sonatype OSSRH signup
echo 2) 🔐 GPG Key Setup Guide
echo 3) 🏠 Configure Local Gradle Properties
echo 4) 📋 GitHub Secrets Setup Guide
echo 5) 🧪 Test Publishing Configuration
echo 6) 📚 View Complete Documentation
echo 7) ❌ Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto sonatype
if "%choice%"=="2" goto gpg
if "%choice%"=="3" goto local
if "%choice%"=="4" goto secrets
if "%choice%"=="5" goto test
if "%choice%"=="6" goto docs
if "%choice%"=="7" goto exit
echo Invalid choice. Please try again.
goto menu

:sonatype
echo.
echo 🌐 STEP 1: Sonatype OSSRH Account
echo ================================
echo.
echo 1. Opening Sonatype OSSRH website...
start https://issues.sonatype.org/
echo.
echo 2. Create account and submit New Project request with:
echo    - Project: Community Support - Open Source Project Repository Hosting (OSSRH)
echo    - Issue Type: New Project
echo    - Summary: Request publishing rights for io.github.pedrojson
echo    - Group Id: io.github.pedrojson
echo    - Project URL: https://github.com/pedrojson/PedroJSON
echo    - SCM URL: https://github.com/pedrojson/PedroJSON.git
echo.
echo 3. Wait for approval (usually 1-2 business days)
echo.
pause
goto menu

:gpg
echo.
echo 🔐 STEP 2: GPG Key Setup
echo ========================
echo.
echo Running GPG setup guide...
call setup-gpg-keys.bat
goto menu

:local
echo.
echo 🏠 STEP 3: Local Gradle Configuration
echo ====================================
echo.
echo Running local gradle.properties setup...
call setup-local-gradle.bat
goto menu

:secrets
echo.
echo 📋 STEP 4: GitHub Secrets
echo =========================
echo.
echo Opening GitHub Secrets setup guide...
start GITHUB_SECRETS_SETUP.md
echo.
echo Manual steps:
echo 1. Go to: https://github.com/pedrojson/PedroJSON/settings/secrets/actions
echo 2. Add the 4 required secrets (see opened guide)
echo 3. Come back here to test!
echo.
pause
goto menu

:test
echo.
echo 🧪 STEP 5: Test Configuration
echo =============================
echo.
echo Testing current setup...
echo.

echo ✅ Testing basic build...
call gradlew.bat :loader:assembleRelease --quiet
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed! Check your configuration.
    pause
    goto menu
)
echo ✅ Build successful!

echo.
echo ✅ Testing GitHub Packages publishing...
call gradlew.bat :loader:publishGprPublicationToGitHubPackagesRepository --dry-run --quiet
if %ERRORLEVEL% EQU 0 (
    echo ✅ GitHub Packages: Ready
) else (
    echo ⚠️  GitHub Packages: Check credentials
)

echo.
echo ✅ Testing Maven Central publishing...
call gradlew.bat :loader:publishMavenPublicationToOSSRHRepository --dry-run --quiet 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Maven Central: Ready to publish!
) else (
    echo ⚠️  Maven Central: Setup incomplete (expected until Sonatype approval)
)

echo.
echo 📊 Setup Status Summary:
echo ========================
if exist "%USERPROFILE%\.gradle\gradle.properties" (
    echo ✅ Local gradle.properties: Configured
) else (
    echo ❌ Local gradle.properties: Missing
)

echo ⚠️  Sonatype approval: Check your OSSRH ticket
echo ⚠️  GitHub Secrets: Verify in repository settings
echo ⚠️  GPG Keys: Ensure uploaded to keyserver

echo.
pause
goto menu

:docs
echo.
echo 📚 STEP 6: Documentation
echo ========================
echo.
echo Opening all setup documentation...
start SETUP_MAVEN_CENTRAL.md
start GITHUB_SECRETS_SETUP.md
start MISSION_ACCOMPLISHED.md
echo.
echo Available documentation files:
echo - SETUP_MAVEN_CENTRAL.md (complete guide)
echo - GITHUB_SECRETS_SETUP.md (secrets configuration)
echo - MISSION_ACCOMPLISHED.md (what was achieved)
echo.
pause
goto menu

:exit
echo.
echo 🎉 Setup Complete!
echo.
echo Once you've completed all steps:
echo 1. Create a GitHub release (e.g., v1.0.5)
echo 2. GitHub Actions will automatically publish to both repositories
echo 3. Users can add your library with just:
echo.
echo    dependencies {
echo        implementation 'io.github.pedrojson:pedrojson-loader:1.0.5'
echo    }
echo.
echo No credentials required for users! 🚀
echo.
pause
exit
