@echo off
echo 🏠 Setting up local gradle.properties for Maven Central
echo.

echo This will create/update your global gradle.properties file
echo Location: %USERPROFILE%\.gradle\gradle.properties
echo.

if not exist "%USERPROFILE%\.gradle" (
    echo Creating .gradle directory...
    mkdir "%USERPROFILE%\.gradle"
)

echo.
echo Adding Maven Central and signing configuration...
echo.

(
echo # Maven Central Publishing Configuration
echo # Replace these values with your actual credentials
echo.
echo # Sonatype OSSRH Credentials
echo ossrhUsername=your_sonatype_username
echo ossrhPassword=your_sonatype_password
echo.
echo # GPG Signing Configuration
echo signing.keyId=YOUR_GPG_KEY_ID
echo signing.password=your_gpg_key_passphrase
echo signing.secretKeyRingFile=%USERPROFILE%\.gnupg\secring.gpg
echo.
echo # GitHub Packages (existing)
echo gpr.user=your_github_username
echo gpr.key=your_github_token
echo.
echo # Notes:
echo # - Replace YOUR_GPG_KEY_ID with your 8-character key ID
echo # - signing.secretKeyRingFile path may vary based on your GPG installation
echo # - Keep this file secure - it contains sensitive credentials!
) >> "%USERPROFILE%\.gradle\gradle.properties"

echo.
echo ✅ Template gradle.properties created at:
echo    %USERPROFILE%\.gradle\gradle.properties
echo.
echo 🔧 Next steps:
echo 1. Edit the file with your actual credentials
echo 2. Replace YOUR_GPG_KEY_ID with your real key ID
echo 3. Update the secring.gpg path if needed
echo.

echo Opening the file for editing...
notepad "%USERPROFILE%\.gradle\gradle.properties"

pause
