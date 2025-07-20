@echo off
echo Publishing PedroJSON to GitHub Packages...
echo.

echo Checking credentials...
if not defined gpr.user (
    echo ❌ GitHub username not found in local.properties
    echo Please add: gpr.user=your_github_username
    echo Run setup-github-packages.bat for help
    pause
    exit /b 1
)

if not defined gpr.key (
    echo ❌ GitHub token not found in local.properties
    echo Please add: gpr.key=your_github_token
    echo Run setup-github-packages.bat for help
    pause
    exit /b 1
)

echo Building library...
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
echo 🎉 Successfully published to GitHub Packages!
echo.
echo Your library is now available at:
echo https://github.com/pedrojson/PedroJSON/packages
echo.
echo Users can add it to their projects with:
echo.
echo repositories {
echo     maven {
echo         name = "GitHubPackages"
echo         url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
echo         credentials {
echo             username = "github_username"
echo             password = "github_token"
echo         }
echo     }
echo }
echo.
echo dependencies {
echo     implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
echo }
echo.

pause
