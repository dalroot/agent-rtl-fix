# ==============================================================================
# Agent RTL Fix - Universal Windows Installer (v2.1.0)
# Supports: One-liner remote execution, local offline execution, and CLI flags
# ==============================================================================

[CmdletBinding()]
param(
    [switch]$GlobalOnly,
    [switch]$ProjectOnly,
    [switch]$NoFonts,
    [switch]$Silent
)

$ErrorActionPreference = "Stop"
$RepoOwner = "dalroot"
$RepoName = "agent-rtl-fix"
$Branch = "main"

function Log-Info {
    param([string]$Message, [ConsoleColor]$Color = [ConsoleColor]::White)
    if (-not $Silent) {
        Write-Host $Message -ForegroundColor $Color
    }
}

Log-Info "==========================================================" Cyan
Log-Info "  Agent RTL Fix (v2.1.0) - Universal BiDi Setup Engine   " Cyan
Log-Info "==========================================================" Cyan

$ScriptDir = ""
try {
    if ($MyInvocation.MyCommand.Definition) {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    }
} catch {}

# ------------------------------------------------------------------------------
# 1. Install Fonts & Real-Time Windows Notification
# ------------------------------------------------------------------------------
if ((-not $ProjectOnly) -and (-not $NoFonts)) {
    Log-Info "[1/4] Installing Core Vazirmatn Fonts..." Yellow
    $fontDest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    if (-not (Test-Path $fontDest)) {
        New-Item -ItemType Directory -Path $fontDest -Force | Out-Null
    }

    $coreFonts = @(
        "Vazirmatn-Regular.ttf",
        "Vazirmatn-Medium.ttf",
        "Vazirmatn-SemiBold.ttf",
        "Vazirmatn-Bold.ttf"
    )

    $regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    # Define P/Invoke helper for real-time font activation without requiring logoff/reboot
    try {
        if (-not ([System.Management.Automation.PSTypeName]'BiDiFontHelper').Type) {
            Add-Type -TypeDefinition @'
            using System;
            using System.Runtime.InteropServices;
            public class BiDiFontHelper {
                [DllImport("gdi32.dll", EntryPoint = "AddFontResourceW", SetLastError = true)]
                public static extern int AddFontResource([In, MarshalAs(UnmanagedType.LPWStr)] string lpFileName);

                [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
                public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);

                public const uint WM_FONTCHANGE = 0x001D;
                public const uint SMTO_ABORTIFHUNG = 0x0002;
                public static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);

                public static void BroadcastChange(string fontPath) {
                    try {
                        AddFontResource(fontPath);
                        IntPtr result;
                        SendMessageTimeout(HWND_BROADCAST, WM_FONTCHANGE, IntPtr.Zero, IntPtr.Zero, SMTO_ABORTIFHUNG, 1000, out result);
                    } catch {}
                }
            }
'@ -ErrorAction SilentlyContinue | Out-Null
        }
    } catch {}

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

        try {
            [BiDiFontHelper]::BroadcastChange($target)
        } catch {}
    }
    Log-Info "  [OK] Processed Vazirmatn typography system-wide (real-time notification sent)." Green
} else {
    Log-Info "[1/4] Skipping typography installation (per flags)." DarkGray
}

# ------------------------------------------------------------------------------
# 2. Configure Global Antigravity AI Machine Rules & Skills
# ------------------------------------------------------------------------------
if (-not $ProjectOnly) {
    Log-Info "[2/4] Setting Up Global Antigravity AI Rules & Skills..." Yellow

    $globalConfigDir = "$env:USERPROFILE\.gemini\config"
    $globalRulesDir = Join-Path $globalConfigDir "rules"
    $globalSkillsDir = Join-Path $globalConfigDir "skills\agent-rtl-fix"

    if (-not (Test-Path $globalRulesDir)) {
        New-Item -ItemType Directory -Path $globalRulesDir -Force | Out-Null
    }
    if (-not (Test-Path $globalSkillsDir)) {
        New-Item -ItemType Directory -Path $globalSkillsDir -Force | Out-Null
    }

    $ruleContent = @'
---
trigger: always_on
description: Universal RTL/LTR BiDi formatting rule for right-to-left languages (Persian, Arabic, Urdu, Hebrew)
---
# Universal RTL/LTR BiDi Formatting Rule
- **Chat & Artifacts:** Every chat response and markdown artifact (.md) containing right-to-left text (Persian, Arabic, Urdu, Hebrew) MUST be wrapped completely inside `<div dir="rtl">...</div>` for native RTL rendering. For artifacts with YAML frontmatter, preserve the frontmatter at the top and enclose the markdown body inside `<div dir="rtl">`.
- **Markdown Integrity:** Bullet points, tables, headings, blockquotes, and code blocks inside the `<div dir="rtl">` container retain standard Markdown syntax (do NOT convert tables to raw HTML).
- **Code & LTR Isolation:** Keep inline code, code blocks, file paths, URLs, shell commands, logs, and LaTeX math formulas strictly LTR. Never reverse or break syntax brackets, slashes, or indentation.
- **Zero Exceptions:** Never produce uncontained or left-aligned RTL text in chat or artifacts.
'@

    $targetRule = Join-Path $globalRulesDir "rtl-formatting.md"
    Set-Content -Path $targetRule -Value $ruleContent -Encoding UTF8
    Log-Info "  [OK] Installed global agent rule: $targetRule" Green

    $skillContent = @'
---
name: agent-rtl-fix
description: Automatically configures Antigravity IDE, Cursor, and VS Code for native RTL/LTR BiDi support, Vazirmatn fonts, and global agent formatting rules.
---

# Agent RTL Fix Skill

Configures autonomous coding agents and editors for native Right-to-Left (Persian, Arabic, Urdu, Hebrew) and Left-to-Right bidirectional text support.

## Automated Actions
1. **Font Setup**: Installs clean Vazirmatn typography for seamless multilingual rendering.
2. **Editor Settings**: Configures `editor.unicodeHighlight.bidiCharacters: true`, clean font fallback (`'Vazirmatn', 'Fira Code', 'Consolas', monospace`), and balanced line-height.
3. **Global Agent Rule**: Installs machine-wide rule (`~/.gemini/config/rules/rtl-formatting.md`) so all agent responses render in proper RTL without token overhead.
'@

    $targetSkill = Join-Path $globalSkillsDir "SKILL.md"
    Set-Content -Path $targetSkill -Value $skillContent -Encoding UTF8
    Log-Info "  [OK] Installed global skill: $targetSkill" Green
} else {
    Log-Info "[2/4] Skipping global machine rules (per flags)." DarkGray
}

# ------------------------------------------------------------------------------
# 3. Configure Local Project Rules (Universal AGENTS.md, Cursor, Copilot, Zed)
# ------------------------------------------------------------------------------
if (-not $GlobalOnly) {
    Log-Info "[3/4] Checking Current Project Directory..." Yellow
    $cwd = Get-Location
    $isProject = (Test-Path (Join-Path $cwd ".git")) -or 
                 (Test-Path (Join-Path $cwd "package.json")) -or 
                 (Test-Path (Join-Path $cwd "go.mod")) -or 
                 (Test-Path (Join-Path $cwd "Cargo.toml")) -or 
                 (Test-Path (Join-Path $cwd "pyproject.toml")) -or 
                 (Test-Path (Join-Path $cwd ".cursor")) -or 
                 (Test-Path (Join-Path $cwd ".github")) -or 
                 (Test-Path (Join-Path $cwd ".zed"))

    $isSelfRepo = (Test-Path (Join-Path $cwd "rules\AGENTS.md")) -and (Test-Path (Join-Path $cwd "fonts\Vazirmatn"))

    if ($isProject -and (-not $isSelfRepo)) {
        Log-Info "  -> Project workspace detected at $cwd" Cyan
        $agentsPath = Join-Path $cwd "AGENTS.md"
        if (-not (Test-Path $agentsPath)) {
            $agentsRule = @'
# Universal AI Agent RTL/LTR BiDi Formatting Standard

This specification defines the universal bidirectional text formatting protocol for autonomous AI agents, coding assistants, and LLM runtimes (including Antigravity, Cursor, Windsurf, Copilot, Claude Code, Cline, Zed, and Aider).

## 1. Rule Definition

Whenever responding or generating documentation in right-to-left (RTL) languages (Persian, Arabic, Urdu, Hebrew):

1. **Outer RTL Boundary**: Wrap the complete response or markdown file body inside `<div dir="rtl">...</div>`.
2. **Markdown Preservation**: Retain standard GitHub Flavored Markdown (GFM) inside the container. Do NOT convert Markdown tables to verbose raw HTML.
3. **BiDi Code & Log Isolation**: All code blocks (````lang ... ````), inline code (`code`), terminal logs, shell commands, URLs, and file paths must remain strictly LTR. Do not flip brackets, slashes, or indentation.
4. **Inline Technical Tokens & Punctuation**: When embedding inline code, variables, or commands within RTL sentences, ensure surrounding punctuation (such as parentheses, colons, and quotes) remains properly oriented.
5. **Frontmatter & Math Isolation**: If generating Markdown files with YAML frontmatter (`---`), place the frontmatter at the very top of the file, then enclose the content body in `<div dir="rtl">...</div>`. Keep multi-line math blocks (`$$...$$`) LTR.
6. **Zero Left-Aligned RTL**: Never emit uncontained right-to-left text.
'@
            Set-Content -Path $agentsPath -Value $agentsRule -Encoding UTF8
            Log-Info "  [OK] Added AGENTS.md to current project" Green
        }

        # Cursor
        if (Test-Path (Join-Path $cwd ".cursor")) {
            $cursorRuleDir = Join-Path $cwd ".cursor\rules"
            if (-not (Test-Path $cursorRuleDir)) { New-Item -ItemType Directory -Path $cursorRuleDir -Force | Out-Null }
            $cursorRulePath = Join-Path $cursorRuleDir "bidi.mdc"
            if (-not (Test-Path $cursorRulePath)) {
                $cursorRule = @'
---
description: Universal RTL/LTR BiDi formatting rule for right-to-left languages (Persian, Arabic, Urdu, Hebrew)
globs: *
alwaysApply: true
---
Wrap all responses containing RTL languages (Persian, Arabic, Urdu, Hebrew) in `<div dir="rtl">...</div>`. Keep code and terminal blocks strictly LTR.
'@
                Set-Content -Path $cursorRulePath -Value $cursorRule -Encoding UTF8
                Log-Info "  [OK] Added .cursor\rules\bidi.mdc" Green
            }
        }

        # GitHub Copilot
        if (Test-Path (Join-Path $cwd ".github")) {
            $copilotPath = Join-Path $cwd ".github\copilot-instructions.md"
            if (-not (Test-Path $copilotPath)) {
                $copilotRule = @'
# GitHub Copilot RTL/LTR BiDi Formatting Instructions
Wrap all RTL language responses (Persian, Arabic, Urdu, Hebrew) inside `<div dir="rtl">...</div>`. Keep all code snippets, paths, and commands in standard LTR.
'@
                Set-Content -Path $copilotPath -Value $copilotRule -Encoding UTF8
                Log-Info "  [OK] Added .github\copilot-instructions.md" Green
            }
        }
    } else {
        Log-Info "  (No project root in current folder; global machine configs applied)" DarkGray
    }
} else {
    Log-Info "[3/4] Skipping project-level configuration (per flags)." DarkGray
}

# ------------------------------------------------------------------------------
# 4. Configure IDE Settings (PowerShell 5.1 & Core safe, preserves existing JSON)
# ------------------------------------------------------------------------------
if (-not $ProjectOnly) {
    Log-Info "[4/4] Configuring IDE Bidirectional Settings..." Yellow

    function Update-IdeSettings {
        param(
            [string]$DirectoryPath,
            [hashtable]$NewSettings,
            [bool]$ForceCreate = $false
        )

        if ((-not $ForceCreate) -and (-not (Test-Path $DirectoryPath))) {
            return
        }

        if (-not (Test-Path $DirectoryPath)) {
            New-Item -ItemType Directory -Path $DirectoryPath -Force | Out-Null
        }

        $settingsFile = Join-Path $DirectoryPath "settings.json"
        $settings = [ordered]@{}

        if (Test-Path $settingsFile) {
            try {
                $jsonRaw = Get-Content $settingsFile -Raw -Encoding UTF8
                if (-not [string]::IsNullOrWhiteSpace($jsonRaw)) {
                    $parsed = ConvertFrom-Json $jsonRaw
                    if ($parsed) {
                        foreach ($prop in $parsed.PSObject.Properties) {
                            $settings[$prop.Name] = $prop.Value
                        }
                    }
                }
            } catch {}
        }

        foreach ($k in $NewSettings.Keys) {
            $settings[$k] = $NewSettings[$k]
        }

        # Convert to JSON and normalize single quotes (avoid \u0027)
        $cleanJson = ($settings | ConvertTo-Json -Depth 10) -replace '\\u0027', "'"
        Set-Content -Path $settingsFile -Value $cleanJson -Encoding UTF8
        Log-Info "  [OK] Updated $settingsFile" Green
    }

    $vscodeSettings = @{
        "editor.fontFamily" = "'Vazirmatn', 'Fira Code', 'Cascadia Code', 'Consolas', monospace"
        "editor.unicodeHighlight.bidiCharacters" = $true
        "markdown.preview.fontFamily" = "'Vazirmatn', 'Segoe UI', Tahoma, sans-serif"
        "chat.editor.fontFamily" = "'Vazirmatn', 'Segoe UI', Tahoma, sans-serif"
    }

    # Ensure Antigravity IDE configuration directory is initialized
    Update-IdeSettings -DirectoryPath "$env:APPDATA\Antigravity\User" -NewSettings $vscodeSettings -ForceCreate $true

    # Update Code and Cursor if installed
    Update-IdeSettings -DirectoryPath "$env:APPDATA\Code\User" -NewSettings $vscodeSettings
    Update-IdeSettings -DirectoryPath "$env:APPDATA\Cursor\User" -NewSettings $vscodeSettings

    # Update Zed if present on Windows
    $zedSettings = @{
        "buffer_font_family" = "Vazirmatn"
        "ui_font_family" = "Vazirmatn"
    }
    Update-IdeSettings -DirectoryPath "$env:APPDATA\Zed" -NewSettings $zedSettings
} else {
    Log-Info "[4/4] Skipping IDE settings update (per flags)." DarkGray
}

Log-Info "==========================================================" Cyan
Log-Info "  Agent RTL Fix installation completed successfully!     " Green
Log-Info "==========================================================" Cyan
