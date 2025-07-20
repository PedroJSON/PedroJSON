@echo off
echo Security Check for PedroJSON Repository
echo =======================================
echo.

echo Checking for exposed secrets...
echo.

echo 1. Checking gradle.properties for credentials:
findstr /i "ghp_\|gpr\.user.*@\|gpr\.key.*ghp" gradle.properties >nul 2>&1
if %errorlevel% equ 0 (
    echo ❌ WARNING: Found potential credentials in gradle.properties
    echo    Please remove them and use global gradle.properties instead
) else (
    echo ✅ gradle.properties is clean (no credentials found)
)
echo.

echo 2. Checking if local.properties is properly ignored:
git check-ignore local.properties >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ local.properties is properly ignored by Git
) else (
    echo ❌ WARNING: local.properties might not be ignored by Git
)
echo.

echo 3. Checking Git status for uncommitted secrets:
git status --porcelain | findstr "local\.properties\|github\.properties" >nul 2>&1
if %errorlevel% equ 0 (
    echo ❌ WARNING: Credential files appear in Git status
) else (
    echo ✅ No credential files in Git status
)
echo.

echo 4. Checking for credentials in staged files:
git diff --cached | findstr /i "ghp_\|token.*ghp" >nul 2>&1
if %errorlevel% equ 0 (
    echo ❌ WARNING: Found potential credentials in staged changes
    echo    Run: git reset HEAD .
    echo    Then remove credentials before committing
) else (
    echo ✅ No credentials found in staged changes
)
echo.

echo 5. Verifying .gitignore covers credential files:
findstr /c:"local.properties" .gitignore >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ .gitignore includes local.properties
) else (
    echo ❌ WARNING: .gitignore missing local.properties
)
echo.

echo Security check complete!
echo.
echo Safe to commit files:
echo - gradle.properties (should only have commented examples)
echo - .gitignore (updated with security patterns)
echo - build.gradle (no credentials)
echo - Documentation files
echo.
echo NOT safe to commit:
echo - local.properties (contains actual credentials)
echo - Any files with actual tokens/passwords
echo.

pause
