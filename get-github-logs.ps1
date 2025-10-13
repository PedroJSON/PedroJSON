# Script to help get GitHub Actions logs
# You'll need to provide the run ID from the GitHub Actions page

param(
    [Parameter(Mandatory=$true)]
    [string]$RunId,
    
    [Parameter(Mandatory=$false)]
    [string]$Token = $env:GITHUB_TOKEN
)

if (-not $Token) {
    Write-Host "❌ Please set GITHUB_TOKEN environment variable or pass -Token parameter" -ForegroundColor Red
    Write-Host "You can create a token at: https://github.com/settings/tokens" -ForegroundColor Yellow
    exit 1
}

$owner = "PedroJSON"
$repo = "PedroJSON"
$url = "https://api.github.com/repos/$owner/$repo/actions/runs/$RunId/logs"

Write-Host "📥 Downloading logs for run ID: $RunId" -ForegroundColor Green

try {
    $headers = @{
        "Authorization" = "token $Token"
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-Script"
    }
    
    $response = Invoke-WebRequest -Uri $url -Headers $headers -OutFile "logs_$RunId.zip"
    Write-Host "✅ Logs downloaded to: logs_$RunId.zip" -ForegroundColor Green
    
    # Extract the zip file
    Expand-Archive -Path "logs_$RunId.zip" -DestinationPath "logs_$RunId" -Force
    Write-Host "✅ Logs extracted to: logs_$RunId/" -ForegroundColor Green
    
    # List the extracted files
    Write-Host "📁 Log files:" -ForegroundColor Cyan
    Get-ChildItem "logs_$RunId" | ForEach-Object { Write-Host "  - $($_.Name)" }
    
} catch {
    Write-Host "❌ Failed to download logs: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure the run ID is correct and your token has repo access" -ForegroundColor Yellow
}