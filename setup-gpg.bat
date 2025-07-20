@echo off
echo Setting up GPG for Maven Central publishing...
echo.

echo Step 1: Install GPG for Windows
echo Download from: https://www.gnupg.org/download/index.html
echo Or install with Chocolatey: choco install gnupg
echo.

echo Step 2: Generate GPG key (run this after installing GPG)
echo gpg --gen-key
echo.

echo Step 3: List your keys to get the key ID
echo gpg --list-secret-keys --keyid-format LONG
echo.

echo Step 4: Export your public key
echo gpg --armor --export YOUR_KEY_ID
echo.

echo Step 5: Upload your public key to keyserver
echo gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID
echo.

echo Step 6: Export your secret key for GitHub Actions
echo gpg --export-secret-keys YOUR_KEY_ID | base64 -w 0
echo.

echo Step 7: Update local.properties with your signing configuration
echo Add the following lines to local.properties:
echo signing.keyId=YOUR_KEY_ID
echo signing.password=YOUR_GPG_PASSPHRASE
echo signing.secretKeyRingFile=C:\\Users\\%USERNAME%\\.gnupg\\secring.gpg
echo.

pause
