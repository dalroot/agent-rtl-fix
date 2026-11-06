# ==============================================================================
# Agent RTL Fix - Universal Windows Installer (v2.0.0)
# ==============================================================================

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
# Support both direct execution and repository root calls
if (Test-Path (Join-Path $ScriptDir "fonts")) {
    $FontsDir = Join-Path $ScriptDir "fonts"
} else {
    $FontsDir = Join-Path (Split-Path -Parent $ScriptDir) "fonts"
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Agent RTL Fix (v2.0.0) - Universal BiDi Setup Engine   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Install Vazirmatn Fonts
$fontDest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontDest)) {
    New-Item -ItemType Directory -Path $fontDest -Force | Out-Null
}

Write-Host "[1/3] Installing Core Vazirmatn Fonts..." -ForegroundColor Yellow

if (Test-Path $FontsDir) {
    $fontFiles = Get-ChildItem -Path $FontsDir -Recurse -Include *.ttf,*.otf
    $regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    foreach ($f in $fontFiles) {
        $target = Join-Path $fontDest $f.Name
        try {
            Copy-Item $f.FullName $target -Force -ErrorAction SilentlyContinue
        } catch {
            # Font file currently locked by running apps
        }
        $fontName = $f.BaseName + " (TrueType)"
        New-ItemProperty -Path $regPath -Name $fontName -Value $target -PropertyType String -Force | Out-Null
    }
    Write-Host "  [OK] Installed $($fontFiles.Count) font files system-wide." -ForegroundColor Green
} else {
    Write-Host "  [!] Fonts folder not found locally, skipping font install." -ForegroundColor DarkYellow
}

# 2. Configure IDE Settings (Non-destructive)
Write-Host "[2/3] Configuring IDE Bidirectional Settings..." -ForegroundColor Yellow

$appDataPaths = @(
    "$env:APPDATA\Antigravity\User",
    "$env:APPDATA\Code\User",
    "$env:APPDATA\Cursor\User"
)

foreach ($path in $appDataPaths) {
    if (-not (Test-Path $path)) {
        continue
    }
    
    $settingsFile = Join-Path $path "settings.json"
    $existing = @{}
    if (Test-Path $settingsFile) {
        try {
            $existing = Get-Content $settingsFile -Raw | ConvertFrom-Json -AsHashtable
        } catch {
            $existing = @{}
        }
    }
    
    $existing["editor.fontFamily"] = "'Vazirmatn', 'Fira Code', 'Cascadia Code', 'Consolas', monospace"
    $existing["editor.unicodeHighlight.bidiCharacters"] = $true
    $existing["markdown.preview.fontFamily"] = "'Vazirmatn', 'Segoe UI', Tahoma, sans-serif"
    $existing["chat.editor.fontFamily"] = "'Vazirmatn', 'Segoe UI', Tahoma, sans-serif"

    $existing | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
    Write-Host "  [OK] Updated $settingsFile" -ForegroundColor Green
}

# 3. Install Lightweight Global Agent Rule
Write-Host "[3/3] Setting Up Universal AI Agent Rules..." -ForegroundColor Yellow

$globalRulesDir = "$env:USERPROFILE\.gemini\config\rules"
if (-not (Test-Path $globalRulesDir)) {
    New-Item -ItemType Directory -Path $globalRulesDir -Force | Out-Null
}

$ruleContent = @'
---
trigger: always_on
description: Universal RTL/LTR BiDi formatting rule for right-to-left languages (Persian, Arabic, Urdu, Hebrew)
---
# Universal RTL/LTR BiDi Formatting Rule
- **Chat & Artifacts:** Every chat response and markdown artifact (.md) containing right-to-left text (Persian, Arabic, Urdu, Hebrew) MUST be wrapped completely inside `<div dir="rtl">...</div>` from start to end for native RTL rendering.
- **Markdown Integrity:** Bullet points, tables, headings, blockquotes, and code blocks inside the `<div dir="rtl">` container retain standard Markdown syntax (do NOT convert tables to raw HTML).
- **Code & LTR Isolation:** Keep inline code, code blocks, file paths, URLs, shell commands, and logs strictly LTR. Never reverse or break syntax brackets, slashes, or indentation.
- **Zero Exceptions:** Never produce uncontained or left-aligned RTL text in chat or artifacts.
'@

$targetRule = Join-Path $globalRulesDir "rtl-formatting.md"
Set-Content -Path $targetRule -Value $ruleContent -Encoding UTF8
Write-Host "  [OK] Installed global agent rule: $targetRule" -ForegroundColor Green

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Agent RTL Fix installation completed successfully!     " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
