@echo off
echo 🚀 GitHub Secrets Setup for Automated Publishing
echo =================================================
echo.

echo Your GitHub Actions workflow is ready for automated publishing!
echo You need to add 4 secrets to your GitHub repository.
echo.

echo 🌐 Step 1: Open GitHub Secrets Page
echo.
start https://github.com/pedrojson/PedroJSON/settings/secrets/actions
echo.
echo ✅ GitHub Secrets page opened in browser
echo.

echo 📋 Step 2: Add These 4 Secrets
echo.
echo Click "New repository secret" for each one:
echo.

echo 1️⃣  SECRET NAME: OSSRH_USERNAME
echo    VALUE: 2PfqGB
echo.

echo 2️⃣  SECRET NAME: OSSRH_PASSWORD  
echo    VALUE: g4FzE7nEVe81RclawctigQcJvx6RXj1DW
echo.

echo 3️⃣  SECRET NAME: SIGNING_PASSWORD
echo    VALUE: 100%%Ch0nk
echo.

echo 4️⃣  SECRET NAME: SIGNING_KEY
echo    VALUE: [Your complete GPG private key - see instructions below]
echo.

echo 🔐 Getting Your GPG Private Key (for SECRET #4):
echo.
echo Open a terminal and run:
echo   gpg --export-secret-keys --armor B4B2C6F2B6154719E1CC7C3CDA642791E9611F13
echo.
echo Copy the ENTIRE output including:
echo   -----BEGIN PGP PRIVATE KEY BLOCK-----
echo   [lots of lines]
echo   -----END PGP PRIVATE KEY BLOCK-----
echo.

pause

echo.
echo ✅ Once you've added all 4 secrets, you can test automated publishing!
echo.

echo 🎯 Step 3: Create Your First Release
echo.
echo 1. Go to: https://github.com/pedrojson/PedroJSON/releases
echo 2. Click "Create a new release"
echo 3. Tag: v1.0.5
echo 4. Title: Release 1.0.5  
echo 5. Description: First public release with Maven Central support
echo 6. Click "Publish release"
echo.

echo 🚀 What happens automatically:
echo   ✅ GitHub Actions builds your library
echo   ✅ Signs with your GPG key
echo   ✅ Publishes to GitHub Packages
echo   ✅ Publishes to Maven Central
echo   ✅ Users can install without credentials!
echo.

echo 📊 After publishing, check:
echo   - GitHub Packages: https://github.com/pedrojson/PedroJSON/packages
echo   - Maven Central: https://search.maven.org/search?q=io.github.pedrojson
echo.

echo 🎉 Your library will be available worldwide with zero user setup!
echo.

pause
