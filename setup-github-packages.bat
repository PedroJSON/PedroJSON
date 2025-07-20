@echo off
echo GitHub Packages Credentials Setup
echo ==================================
echo.

echo You need a GitHub Personal Access Token to publish to GitHub Packages.
echo.

echo Step 1: Create GitHub Personal Access Token
echo -------------------------------------------
echo 1. Go to: https://github.com/settings/tokens
echo 2. Click "Generate new token (classic)"
echo 3. Give it a name like "PedroJSON Publishing"
echo 4. Select these scopes:
echo    [x] write:packages
echo    [x] read:packages
echo    [x] repo (if your repository is private)
echo 5. Click "Generate token"
echo 6. COPY THE TOKEN (you won't see it again!)
echo.

echo Step 2: Update local.properties
echo --------------------------------
echo Add these lines to your local.properties file:
echo.
echo gpr.user=your_github_username
echo gpr.key=ghp_your_personal_access_token_here
echo.

echo Step 3: Test Publishing
echo -----------------------
echo After setting up credentials, run:
echo gradlew :loader:publishGprPublicationToGitHubPackagesRepository
echo.

echo Step 4: Verify Publication
echo --------------------------
echo Check your package at:
echo https://github.com/pedrojson/PedroJSON/packages
echo.

echo Note: GitHub Actions will automatically publish when you create a release!
echo.

pause
