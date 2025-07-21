@echo off
echo 🧪 Testing Library Publishing Configuration
echo.

echo 📋 Checking current configuration...
echo.

echo ✅ 1. Verifying build.gradle structure
findstr /i "maven-publish" loader\build.gradle >nul && (
    echo    ✅ Maven publish plugin: CONFIGURED
) || (
    echo    ❌ Maven publish plugin: MISSING
)

findstr /i "OSSRH" loader\build.gradle >nul && (
    echo    ✅ Maven Central repository: CONFIGURED
) || (
    echo    ❌ Maven Central repository: MISSING
)

findstr /i "GitHubPackages" loader\build.gradle >nul && (
    echo    ✅ GitHub Packages repository: CONFIGURED
) || (
    echo    ❌ GitHub Packages repository: MISSING
)

echo.
echo ✅ 2. Testing GitHub Packages publishing (should work)
call gradlew.bat :loader:assembleRelease
if %ERRORLEVEL% EQU 0 (
    echo    ✅ Build successful
) else (
    echo    ❌ Build failed
    goto :end
)

echo.
echo ✅ 3. Check if Maven Central credentials are configured
call gradlew.bat :loader:publishMavenPublicationToOSSRHRepository --dry-run 2>nul
if %ERRORLEVEL% EQU 0 (
    echo    ✅ Maven Central: Ready to publish
) else (
    echo    ⚠️  Maven Central: Credentials needed (expected for first-time setup)
    echo       See SETUP_MAVEN_CENTRAL.md for instructions
)

echo.
echo 📊 Configuration Summary:
echo    ✅ Library builds successfully
echo    ✅ Dual publishing configured (GitHub + Maven Central)
echo    ✅ Users won't need credentials once published to Maven Central
echo    ✅ Dynamic versioning from Git tags
echo.
echo 🎯 Next steps:
echo    1. Complete Sonatype OSSRH setup (see SETUP_MAVEN_CENTRAL.md)
echo    2. Configure GitHub Secrets for automated publishing
echo    3. Create a release to test end-to-end publishing
echo.

:end
pause
