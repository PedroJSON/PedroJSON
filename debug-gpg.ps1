# Enhanced GPG debugging script

Write-Host "=== GPG Key Diagnostics ===" -ForegroundColor Cyan
Write-Host

$signingKey = $env:SIGNING_KEY

if (-not $signingKey) {
    Write-Host "SIGNING_KEY environment variable is not set" -ForegroundColor Red
    exit 1
}

Write-Host "Key length: $($signingKey.Length) characters" -ForegroundColor Green
Write-Host

# Check for proper headers
if ($signingKey.StartsWith("-----BEGIN PGP PRIVATE KEY BLOCK-----")) {
    Write-Host "✓ Key starts with correct header" -ForegroundColor Green
} else {
    Write-Host "✗ Key does not start with correct header" -ForegroundColor Red
    Write-Host "First 50 chars: '$($signingKey.Substring(0, [Math]::Min(50, $signingKey.Length)))'" -ForegroundColor Yellow
}

if ($signingKey.Contains("-----END PGP PRIVATE KEY BLOCK-----")) {
    Write-Host "✓ Key contains correct footer" -ForegroundColor Green
} else {
    Write-Host "✗ Key does not contain correct footer" -ForegroundColor Red
}

# Check line endings and structure
$lines = $signingKey -split "`r?`n"
Write-Host "Number of lines: $($lines.Length)" -ForegroundColor Yellow

if ($lines.Length -lt 5) {
    Write-Host "⚠️ Key appears to be on too few lines (possibly corrupted line endings)" -ForegroundColor Yellow
    Write-Host "Attempting to fix line endings..." -ForegroundColor Yellow
    
    # Try to fix common line ending issues
    $fixedKey = $signingKey -replace "`r`n", "`n" -replace "`r", "`n"
    $fixedLines = $fixedKey -split "`n"
    Write-Host "After line ending fix: $($fixedLines.Length) lines" -ForegroundColor Yellow
}

# Save key to temporary file for testing
$tempKeyFile = Join-Path $env:TEMP "test-gpg-key.asc"
try {
    # Use UTF8 encoding without BOM
    [System.IO.File]::WriteAllText($tempKeyFile, $signingKey, [System.Text.UTF8Encoding]::new($false))
    Write-Host "✓ Key saved to temporary file: $tempKeyFile" -ForegroundColor Green
    
    # Show file size
    $fileInfo = Get-Item $tempKeyFile
    Write-Host "File size: $($fileInfo.Length) bytes" -ForegroundColor Yellow
    
    # Test GPG import from file
    Write-Host
    Write-Host "Testing GPG import from file..." -ForegroundColor Cyan
    
    $tempGpgHome = Join-Path $env:TEMP "debug-gpg-$(Get-Random)"
    New-Item -ItemType Directory -Path $tempGpgHome -Force | Out-Null
    $env:GNUPGHOME = $tempGpgHome
    
    $importResult = & gpg --batch --import $tempKeyFile 2>&1
    Write-Host "GPG import result: $importResult" -ForegroundColor Yellow
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Yellow
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ GPG import successful!" -ForegroundColor Green
        
        # Test signing
        Write-Host
        Write-Host "Testing signing..." -ForegroundColor Cyan
        $signingPassword = $env:SIGNING_PASSWORD
        if ($signingPassword) {
            "test content" | & gpg --batch --yes --passphrase $signingPassword --pinentry-mode loopback --armor --detach-sign 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Signing test successful!" -ForegroundColor Green
            } else {
                Write-Host "✗ Signing test failed (exit code: $LASTEXITCODE)" -ForegroundColor Red
            }
        } else {
            Write-Host "⚠️ SIGNING_PASSWORD not set, skipping signing test" -ForegroundColor Yellow
        }
    }
    
    # Cleanup
    Remove-Item -Path $tempGpgHome -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item Env:GNUPGHOME -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "✗ Error during testing: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Cleanup temp file
    if (Test-Path $tempKeyFile) {
        Remove-Item $tempKeyFile -Force -ErrorAction SilentlyContinue
    }
}

Write-Host
Write-Host "=== Recommendations ===" -ForegroundColor Cyan

# Check if we can export the existing key
Write-Host
Write-Host "Your existing GPG key:" -ForegroundColor Green
& gpg --list-secret-keys --keyid-format=short

Write-Host
Write-Host "To re-export your key correctly:" -ForegroundColor Yellow
Write-Host "gpg --armor --export-secret-keys B4B2C6F2B6154719E1CC7C3CDA642791E9611F13" -ForegroundColor Cyan