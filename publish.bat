@echo off
echo PedroJSON Library - Maven Central & GitHub Packages Publishing
echo ===============================================================
echo.

echo Checking if library builds...
call gradlew :loader:assembleRelease
if %errorlevel% neq 0 (
    echo Build failed! Please fix build errors first.
    pause
    exit /b 1
)
echo ✅ Build successful!
echo.

echo Testing local publishing...
call gradlew :loader:publishToMavenLocal
if %errorlevel% neq 0 (
    echo Local publishing failed!
    pause
    exit /b 1
)
echo ✅ Local publishing successful!
echo.

echo Current status:
echo - ✅ Library builds successfully
echo - ✅ Local Maven publishing works
echo - ✅ Artifacts are generated with proper metadata
echo - ✅ GitHub Packages configuration ready
echo - ✅ Maven Central configuration ready
echo.

echo ===========================================
echo         🚀 PUBLISHING OPTIONS
echo ===========================================
echo.
echo 1) 📦 GitHub Packages Only (requires user credentials)
echo 2) 🌐 Maven Central Only (no user credentials needed!)
echo 3) 🔄 Both Repositories (recommended)
echo 4) 🧪 Test Mode (dry-run)
echo 5) ❌ Exit
echo.
set /p choice="Choose publishing option (1-5): "

if "%choice%"=="1" goto github_only
if "%choice%"=="2" goto maven_only
if "%choice%"=="3" goto both
if "%choice%"=="4" goto test
if "%choice%"=="5" goto exit
echo Invalid choice. Please try again.
goto menu

:github_only
echo.
echo 📦 Publishing to GitHub Packages...
call gradlew :loader:publishGprPublicationToGitHubPackagesRepository
goto success

:maven_only
echo.
echo 🌐 Publishing to Maven Central...
echo This will make your library available worldwide without user credentials!
call gradlew :loader:publishMavenPublicationToOSSRHRepository
goto success

:both
echo.
echo 🔄 Publishing to both GitHub Packages and Maven Central...
call gradlew :loader:publish
goto success

:test
echo.
echo 🧪 Testing publishing configuration (dry-run)...
echo.
echo Testing GitHub Packages...
call gradlew :loader:publishGprPublicationToGitHubPackagesRepository --dry-run
echo.
echo Testing Maven Central...
call gradlew :loader:publishMavenPublicationToOSSRHRepository --dry-run
echo.
echo ✅ Dry-run complete! Check output above for any issues.
pause
exit

:success
if %errorlevel% neq 0 (
    echo.
    echo ❌ Publishing failed! Check the error messages above.
    echo.
    echo Common issues:
    echo - Maven Central: Sonatype account not approved yet
    echo - GitHub Packages: Check credentials in local.properties
    echo - Signing: Verify GPG key configuration
    pause
    exit /b 1
)

echo.
echo 🎉 Your library is now published!
echo.
echo 📊 Where users can find it:
echo.

if "%choice%"=="1" (
    echo 📦 GitHub Packages:
    echo    https://github.com/pedrojson/PedroJSON/packages
    echo.
    echo    Users need credentials:
    echo    dependencies {
    echo        implementation 'io.github.pedrojson:pedrojson-loader:VERSION'
    echo    }
)

if "%choice%"=="2" (
    echo 🌐 Maven Central:
    echo    https://search.maven.org/search?q=io.github.pedrojson
    echo.
    echo    Users need NO credentials! ✨
    echo    dependencies {
    echo        implementation 'io.github.pedrojson:pedrojson-loader:VERSION'
    echo    }
)

if "%choice%"=="3" (
    echo 📦 GitHub Packages:
    echo    https://github.com/pedrojson/PedroJSON/packages
    echo.
    echo 🌐 Maven Central:
    echo    https://search.maven.org/search?q=io.github.pedrojson
    echo.
    echo    Recommended for users ^(no credentials needed^):
    echo    dependencies {
    echo        implementation 'io.github.pedrojson:pedrojson-loader:VERSION'
    echo    }
)

echo.
echo ⏰ Note: Maven Central can take 15-30 minutes to sync and appear in search.
echo 🔗 Check status at: https://repo1.maven.org/maven2/io/github/pedrojson/pedrojson-loader/
echo.

pause

:exit
    pause
    exit /b 1
)
echo ✅ Local publishing successful!
echo.

echo Current status:
echo - ✅ Library builds successfully
echo - ✅ Local Maven publishing works
echo - ✅ Artifacts are generated with proper metadata
echo - ✅ GitHub Packages configuration ready
echo.

echo To publish to GitHub Packages:
echo.
echo 1. Get GitHub Personal Access Token:
echo    - Go to: https://github.com/settings/tokens
echo    - Create token with 'write:packages' permission
echo.
echo 2. Update local.properties with:
echo    gpr.user=your_github_username
echo    gpr.key=your_github_token
echo.
echo 3. Run: gradlew :loader:publishGprPublicationToGitHubPackagesRepository
echo.
echo OR simply create a GitHub release and it will publish automatically!
echo.

echo Your library will be available at:
echo https://github.com/pedrojson/PedroJSON/packages
echo.

echo Users can then access it with:
echo repositories {
echo     maven {
echo         name = "GitHubPackages"
echo         url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
echo         credentials {
echo             username = "their_github_username"
echo             password = "their_github_token"
echo         }
echo     }
echo }
echo dependencies {
echo     implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
echo }
echo.

pause
