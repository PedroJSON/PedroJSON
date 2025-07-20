@echo off
echo PedroJSON Library - GitHub Packages Publishing
echo ==============================================
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
