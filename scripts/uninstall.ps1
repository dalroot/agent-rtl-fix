# ==============================================================================
# Agent RTL Fix - Uninstaller for Windows
# ==============================================================================

Write-Host "Removing Agent RTL Fix global rule..." -ForegroundColor Yellow
$targetRule = "$env:USERPROFILE\.gemini\config\rules\rtl-formatting.md"
if (Test-Path $targetRule) {
    Remove-Item $targetRule -Force
    Write-Host "Removed $targetRule" -ForegroundColor Green
} else {
    Write-Host "Rule not found." -ForegroundColor DarkGray
}

Write-Host "Uninstallation complete." -ForegroundColor Green
