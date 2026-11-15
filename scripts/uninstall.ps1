# ==============================================================================
# Agent RTL Fix - Uninstaller for Windows (v2.1.0)
# Supports: Standard rule removal and -Full typography cleanup
# ==============================================================================

[CmdletBinding()]
param(
    [switch]$Full
)

Write-Host "Removing Agent RTL Fix global configuration..." -ForegroundColor Yellow

# 1. Remove Global Rule & Skill
$targetRule = "$env:USERPROFILE\.gemini\config\rules\rtl-formatting.md"
$targetSkill = "$env:USERPROFILE\.gemini\config\skills\agent-rtl-fix"

if (Test-Path $targetRule) {
    Remove-Item $targetRule -Force
    Write-Host "  [OK] Removed global rule: $targetRule" -ForegroundColor Green
}

if (Test-Path $targetSkill) {
    Remove-Item $targetSkill -Recurse -Force
    Write-Host "  [OK] Removed global skill: $targetSkill" -ForegroundColor Green
}

# 2. Optional Full Cleanup (Fonts & Registry)
if ($Full) {
    Write-Host "Cleaning up Vazirmatn fonts and registry keys..." -ForegroundColor Yellow
    $fontDest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    $regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    $coreFonts = @(
        "Vazirmatn-Regular.ttf",
        "Vazirmatn-Medium.ttf",
        "Vazirmatn-SemiBold.ttf",
        "Vazirmatn-Bold.ttf"
    )

    foreach ($fontName in $coreFonts) {
        $fontPath = Join-Path $fontDest $fontName
        if (Test-Path $fontPath) {
            try { Remove-Item $fontPath -Force } catch {}
        }
        $regName = [System.IO.Path]::GetFileNameWithoutExtension($fontName) + " (TrueType)"
        try { Remove-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue } catch {}
    }
    Write-Host "  [OK] Removed installed Vazirmatn fonts and registry entries." -ForegroundColor Green
}

Write-Host "Uninstallation complete." -ForegroundColor Green
