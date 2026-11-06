# ==============================================================================
# Agent RTL Fix - Universal Windows Installer (v2.0.0)
# Supports: One-liner remote execution and local offline execution
# ==============================================================================

$ErrorActionPreference = "Stop"
$RepoOwner = "dalroot"
$RepoName = "agent-rtl-fix"
$Branch = "main"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Agent RTL Fix (v2.0.0) - Universal BiDi Setup Engine   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Install Fonts
$fontDest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontDest)) {
    New-Item -ItemType Directory -Path $fontDest -Force | Out-Null
}

Write-Host "[1/4] Installing Core Vazirmatn Fonts..." -ForegroundColor Yellow

$coreFonts = @(
    "Vazirmatn-Regular.ttf",
    "Vazirmatn-Medium.ttf",
    "Vazirmatn-SemiBold.ttf",
    "Vazirmatn-Bold.ttf"
)

$ScriptDir = ""
try {
    if ($MyInvocation.MyCommand.Definition) {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    }
} catch {}

$regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

foreach ($fontName in $coreFonts) {
    $target = Join-Path $fontDest $fontName
    $localFile = ""
    
    if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "fonts\Vazirmatn\$fontName"))) {
        $localFile = Join-Path $ScriptDir "fonts\Vazirmatn\$fontName"
    } elseif ($ScriptDir -and (Test-Path (Join-Path (Split-Path -Parent $ScriptDir) "fonts\Vazirmatn\$fontName"))) {
        $localFile = Join-Path (Split-Path -Parent $ScriptDir) "fonts\Vazirmatn\$fontName"
    }

    if ($localFile) {
        try { Copy-Item $localFile $target -Force -ErrorAction SilentlyContinue } catch {}
    } else {
        $fontUrl = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/$Branch/fonts/Vazirmatn/$fontName"
        try {
            Invoke-WebRequest -Uri $fontUrl -OutFile $target -UseBasicParsing -ErrorAction SilentlyContinue
        } catch {}
    }

    $regName = [System.IO.Path]::GetFileNameWithoutExtension($fontName) + " (TrueType)"
    New-ItemProperty -Path $regPath -Name $regName -Value $target -PropertyType String -Force | Out-Null
}
Write-Host "  [OK] Processed Vazirmatn typography system-wide." -ForegroundColor Green

# 2. Configure Global Antigravity AI Machine Rule
Write-Host "[2/4] Setting Up Global Antigravity AI Rules..." -ForegroundColor Yellow

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

# 3. Configure Local Project Rules (Cursor, Windsurf, Copilot, Claude, Cline)
Write-Host "[3/4] Checking Current Project Directory..." -ForegroundColor Yellow
$cwd = Get-Location
$isProject = (Test-Path (Join-Path $cwd ".git")) -or (Test-Path (Join-Path $cwd "package.json")) -or (Test-Path (Join-Path $cwd "go.mod"))

if ($isProject) {
    Write-Host "  -> Project workspace detected at $cwd" -ForegroundColor Cyan
    $agentsPath = Join-Path $cwd "AGENTS.md"
    if (-not (Test-Path $agentsPath)) {
        $agentsRule = @'
# Universal AI Agent RTL/LTR BiDi Formatting Standard

Whenever responding or generating documentation in right-to-left (RTL) languages (Persian, Arabic, Urdu, Hebrew):
1. **Outer RTL Boundary**: Wrap the complete response or markdown file inside `<div dir="rtl">...</div>`.
2. **Markdown Preservation**: Retain standard GitHub Flavored Markdown (GFM) inside the container. Do NOT convert Markdown tables to verbose raw HTML.
3. **BiDi Code & Log Isolation**: All code blocks (```lang ... ```), inline code (`code`), terminal logs, shell commands, URLs, and file paths must remain strictly LTR.
4. **Zero Exceptions**: Never emit uncontained or left-aligned RTL text.
'@
        Set-Content -Path $agentsPath -Value $agentsRule -Encoding UTF8
        Write-Host "  [OK] Added AGENTS.md to current project" -ForegroundColor Green
    }
}

# 4. Configure IDE Settings
Write-Host "[4/4] Configuring IDE Bidirectional Settings..." -ForegroundColor Yellow

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

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Agent RTL Fix installation completed successfully!     " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
