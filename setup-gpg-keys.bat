@echo off
echo 🔐 GPG Setup for Maven Central Publishing
echo.

echo Step 1: Install GPG
echo Download GPG for Windows from: https://www.gnupg.org/download/
echo Or use Chocolatey: choco install gnupg
echo.
pause

echo Step 2: Generate GPG Key
echo.
echo Run this command and follow the prompts:
echo   gpg --full-generate-key
echo.
echo Choose these options:
echo   - Key type: RSA and RSA (default)
echo   - Key size: 4096 bits (recommended)
echo   - Key expiration: 0 (key does not expire) or set your preference
echo   - Real name: PedroJSON Team (or your name)
echo   - Email: aksandvick@icloud.com (must match build.gradle)
echo   - Comment: (optional)
echo.
pause

echo Step 3: Find your Key ID
echo.
echo Run this command to list your keys:
echo   gpg --list-secret-keys --keyid-format LONG
echo.
echo Look for a line like: sec   rsa4096/ABCD1234EFGH5678
echo Your KEY_ID is: ABCD1234EFGH5678
echo.
pause

echo Step 4: Upload Public Key to Keyserver
echo.
echo Replace YOUR_KEY_ID with your actual key ID:
echo   gpg --keyserver hkp://keyserver.ubuntu.com --send-keys YOUR_KEY_ID
echo.
echo Alternative keyservers if one fails:
echo   gpg --keyserver hkp://pool.sks-keyservers.net --send-keys YOUR_KEY_ID
echo   gpg --keyserver hkp://pgp.mit.edu --send-keys YOUR_KEY_ID
echo.
pause

echo Step 5: Export Private Key for GitHub Secrets
echo.
echo Replace YOUR_KEY_ID with your actual key ID:
echo   gpg --export-secret-keys --armor YOUR_KEY_ID ^> signing-key.asc
echo.
echo This creates signing-key.asc - you'll copy its contents to GitHub Secrets
echo ⚠️  KEEP THIS FILE SECURE - IT'S YOUR PRIVATE KEY!
echo.
pause

echo 🎯 Next: Configure GitHub Secrets and local gradle.properties
echo See the setup guide for details!
pause
