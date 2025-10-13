# Test script to verify GPG setup for Maven Central publishing (Windows PowerShell)
# Run this script to test your GPG configuration locally

Write-Host "Testing GPG setup for Maven Central publishing..." -ForegroundColor Cyan
Write-Host

# Check if GPG is installed
try {
    $gpgVersion = & gpg --version 2>$null | Select-Object -First 1
    Write-Host "GPG is installed: $gpgVersion" -ForegroundColor Green
} catch {
    Write-Host "GPG is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Install GPG from: https://gnupg.org/download/" -ForegroundColor Yellow
    exit 1
}

# Check environment variables
Write-Host
Write-Host "Environment variables:" -ForegroundColor Cyan

$signingKey = $env:SIGNING_KEY
if ($signingKey) {
    Write-Host "  SIGNING_KEY: SET ($($signingKey.Length) characters)" -ForegroundColor Green
    
    # Test if it's base64 encoded
    try {
        $decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($signingKey))
        if ($decoded -like "*BEGIN PGP PRIVATE KEY BLOCK*") {
            Write-Host "    Format: Base64 encoded" -ForegroundColor Green
            Write-Host "    Content: Contains GPG private key block" -ForegroundColor Green
        } else {
            Write-Host "    Format: Base64, but content unclear" -ForegroundColor Yellow
        }
    } catch {
        if ($signingKey -like "*BEGIN PGP PRIVATE KEY BLOCK*") {
            Write-Host "    Format: ASCII armored" -ForegroundColor Green
        } else {
            Write-Host "    Format: Unknown format" -ForegroundColor Red
        }
    }
} else {
    Write-Host "  SIGNING_KEY: ❌ NOT SET" -ForegroundColor Red
}

$signingPassword = $env:SIGNING_PASSWORD
if ($signingPassword) {
    Write-Host "  SIGNING_PASSWORD: SET" -ForegroundColor Green
} else {
    Write-Host "  SIGNING_PASSWORD: NOT SET" -ForegroundColor Red
}

$centralUsername = $env:CENTRAL_PORTAL_USERNAME
if ($centralUsername) {
    Write-Host "  CENTRAL_PORTAL_USERNAME: SET ($centralUsername)" -ForegroundColor Green
} else {
    Write-Host "  CENTRAL_PORTAL_USERNAME: NOT SET" -ForegroundColor Red
}

$centralPassword = $env:CENTRAL_PORTAL_PASSWORD
if ($centralPassword) {
    Write-Host "  CENTRAL_PORTAL_PASSWORD: SET" -ForegroundColor Green
} else {
    Write-Host "  CENTRAL_PORTAL_PASSWORD: NOT SET" -ForegroundColor Red
}

# Test GPG import (if key is provided)
if ($signingKey -and $signingPassword) {
    Write-Host
    Write-Host "Testing GPG key import..." -ForegroundColor Cyan
    
    # Create a temporary GPG home
    $tempGpgHome = Join-Path $env:TEMP "test-gpg-$(Get-Random)"
    New-Item -ItemType Directory -Path $tempGpgHome -Force | Out-Null
    $env:GNUPGHOME = $tempGpgHome
    
    try {
        # Try to import the key
        Write-Host "Key preview (first 100 chars): $($signingKey.Substring(0, [Math]::Min(100, $signingKey.Length)))" -ForegroundColor Yellow
        
        if ($signingKey -like "*BEGIN PGP PRIVATE KEY BLOCK*") {
            # ASCII armored
            Write-Host "Attempting to import ASCII armored key..." -ForegroundColor Yellow
            $importResult = $signingKey | & gpg --batch --import 2>&1
            Write-Host "GPG import output: $importResult" -ForegroundColor Yellow
            Write-Host "GPG exit code: $LASTEXITCODE" -ForegroundColor Yellow
        } else {
            # Assume base64 encoded
            Write-Host "Attempting to decode and import base64 key..." -ForegroundColor Yellow
            $decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($signingKey))
            $importResult = $decoded | & gpg --batch --import 2>&1
            Write-Host "GPG import output: $importResult" -ForegroundColor Yellow
            Write-Host "GPG exit code: $LASTEXITCODE" -ForegroundColor Yellow
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "GPG key imported successfully" -ForegroundColor Green
            
            # List imported keys
            Write-Host "Imported keys:" -ForegroundColor Cyan
            & gpg --list-secret-keys --keyid-format=short
            
            # Test signing
            Write-Host "Testing signing capability..." -ForegroundColor Cyan
            "test" | & gpg --batch --yes --passphrase $signingPassword --pinentry-mode loopback --armor --detach-sign 2>$null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "GPG signing test successful" -ForegroundColor Green
            } else {
                Write-Host "GPG signing test failed" -ForegroundColor Red
            }
        } else {
            Write-Host "GPG key import failed" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error testing GPG: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        # Cleanup
        Remove-Item -Path $tempGpgHome -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item Env:GNUPGHOME -ErrorAction SilentlyContinue
    }
}

Write-Host
Write-Host "To fix GPG issues:" -ForegroundColor Yellow
Write-Host "1. Make sure your SIGNING_KEY is either:"
Write-Host "   - ASCII armored (starts with -----BEGIN PGP PRIVATE KEY BLOCK-----)"
Write-Host "   - Base64 encoded ASCII armored key"
Write-Host "2. Set SIGNING_PASSWORD to your GPG key passphrase"
Write-Host "3. Set CENTRAL_PORTAL_USERNAME to your Sonatype Central Portal username"
Write-Host "4. Set CENTRAL_PORTAL_PASSWORD to your Sonatype Central Portal password"
Write-Host
Write-Host "To export your GPG key:" -ForegroundColor Cyan
Write-Host "  gpg --armor --export-secret-keys YOUR_KEY_ID"
Write-Host "To base64 encode it:" -ForegroundColor Cyan
Write-Host "  `$key = gpg --armor --export-secret-keys YOUR_KEY_ID"
Write-Host "  [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(`$key))"