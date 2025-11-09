# Test Gradle-style GPG signing
# This mimics what Gradle does internally

Write-Host "=== Testing Gradle-Style GPG Signing ===" -ForegroundColor Cyan

$signingKey = $env:SIGNING_KEY
$signingPassword = $env:SIGNING_PASSWORD

if (-not $signingKey -or -not $signingPassword) {
    Write-Host "Missing SIGNING_KEY or SIGNING_PASSWORD environment variables" -ForegroundColor Red
    exit 1
}

# Save key to temporary file
$tempKeyFile = Join-Path $env:TEMP "gradle-test-key.asc"
try {
    [System.IO.File]::WriteAllText($tempKeyFile, $signingKey, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Key saved to: $tempKeyFile" -ForegroundColor Green
    
    # Test importing the key with the specific passphrase
    $tempGpgHome = Join-Path $env:TEMP "gradle-gpg-test-$(Get-Random)"
    New-Item -ItemType Directory -Path $tempGpgHome -Force | Out-Null
    $env:GNUPGHOME = $tempGpgHome
    
    Write-Host "Testing key import..." -ForegroundColor Yellow
    $importResult = & gpg --batch --import $tempKeyFile 2>&1
    Write-Host "Import result: $importResult" -ForegroundColor Yellow
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Key imported successfully" -ForegroundColor Green
        
        # List the imported key
        Write-Host "Imported key details:" -ForegroundColor Cyan
        & gpg --list-secret-keys --keyid-format=short
        
        # Try to sign with the exact method Gradle uses
        Write-Host "Testing signing with passphrase..." -ForegroundColor Yellow
        
        # Create test content
        $testContent = "This is test content for signing"
        $testFile = Join-Path $env:TEMP "test-content.txt"
        [System.IO.File]::WriteAllText($testFile, $testContent)
        
        # Test different passphrase methods
        Write-Host "Method 1: Using --passphrase parameter" -ForegroundColor Yellow
        $signResult1 = & gpg --batch --yes --passphrase $signingPassword --pinentry-mode loopback --armor --detach-sign $testFile 2>&1
        Write-Host "Result 1: $signResult1" -ForegroundColor Yellow
        Write-Host "Exit code 1: $LASTEXITCODE" -ForegroundColor Yellow
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "SUCCESS: Method 1 worked!" -ForegroundColor Green
        } else {
            Write-Host "Method 1 failed, trying method 2..." -ForegroundColor Yellow
            
            # Method 2: Using passphrase file
            $passphraseFile = Join-Path $env:TEMP "passphrase.txt"
            [System.IO.File]::WriteAllText($passphraseFile, $signingPassword)
            
            $signResult2 = & gpg --batch --yes --passphrase-file $passphraseFile --pinentry-mode loopback --armor --detach-sign $testFile 2>&1
            Write-Host "Result 2: $signResult2" -ForegroundColor Yellow
            Write-Host "Exit code 2: $LASTEXITCODE" -ForegroundColor Yellow
            
            Remove-Item $passphraseFile -ErrorAction SilentlyContinue
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "SUCCESS: Method 2 worked!" -ForegroundColor Green
            } else {
                Write-Host "Both methods failed - passphrase issue likely" -ForegroundColor Red
            }
        }
        
        Remove-Item $testFile -ErrorAction SilentlyContinue
    }
    
    # Cleanup
    Remove-Item -Path $tempGpgHome -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item Env:GNUPGHOME -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    Remove-Item $tempKeyFile -ErrorAction SilentlyContinue
}

Write-Host
Write-Host "=== Diagnosis ===" -ForegroundColor Cyan
Write-Host "If both methods failed, the issue is likely:" -ForegroundColor Yellow
Write-Host "1. Wrong passphrase in SIGNING_PASSWORD" -ForegroundColor Yellow
Write-Host "2. GPG key was exported with a different passphrase" -ForegroundColor Yellow
Write-Host "3. Key corruption during copy/paste" -ForegroundColor Yellow
Write-Host
Write-Host "To fix:" -ForegroundColor Green
Write-Host "1. Verify your passphrase is correct" -ForegroundColor Green
Write-Host "2. Re-export your key: gpg --armor --export-secret-keys YOUR_KEY_ID" -ForegroundColor Green
Write-Host "3. Make sure you use the same passphrase when setting SIGNING_PASSWORD" -ForegroundColor Green