#!/usr/bin/env bash
# ==============================================================================
# Agent RTL Fix - Universal Linux & macOS Installer (v2.1.0)
# Supports: One-liner remote execution, local offline execution, and CLI flags
# ==============================================================================

set -e

REPO_OWNER="dalroot"
REPO_NAME="agent-rtl-fix"
BRANCH="main"

GLOBAL_ONLY=false
PROJECT_ONLY=false
NO_FONTS=false
SILENT=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --global-only) GLOBAL_ONLY=true; shift ;;
        --project-only) PROJECT_ONLY=true; shift ;;
        --no-fonts) NO_FONTS=true; shift ;;
        --silent) SILENT=true; shift ;;
        -h|--help)
            echo "Usage: ./install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --global-only   Install machine-wide rules, skills, and fonts (skip current project)"
            echo "  --project-only  Install rules in current workspace only (skip system-wide changes)"
            echo "  --no-fonts      Skip font installation"
            echo "  --silent        Run silently without banner output"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *) shift ;;
    esac
done

log() {
    if [ "$SILENT" = false ]; then
        echo -e "$1"
    fi
}

log "=========================================================="
log "  Agent RTL Fix (v2.1.0) - Universal BiDi Setup Engine   "
log "=========================================================="

SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# ------------------------------------------------------------------------------
# 1. Install Fonts
# ------------------------------------------------------------------------------
if [ "$PROJECT_ONLY" = false ] && [ "$NO_FONTS" = false ]; then
    log "[1/4] Installing Core Vazirmatn Typography..."
    if [ "$(uname)" == "Darwin" ]; then
        FONT_DEST="$HOME/Library/Fonts"
    else
        FONT_DEST="$HOME/.local/share/fonts/Vazirmatn"
    fi

    mkdir -p "$FONT_DEST"

    CORE_FONTS=(
        "Vazirmatn-Regular.ttf"
        "Vazirmatn-Medium.ttf"
        "Vazirmatn-SemiBold.ttf"
        "Vazirmatn-Bold.ttf"
    )

    for font in "${CORE_FONTS[@]}"; do
        if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/fonts/Vazirmatn/$font" ]; then
            cp -f "$SCRIPT_DIR/fonts/Vazirmatn/$font" "$FONT_DEST/"
        elif [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/../fonts/Vazirmatn/$font" ]; then
            cp -f "$SCRIPT_DIR/../fonts/Vazirmatn/$font" "$FONT_DEST/"
        else
            font_url="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/fonts/Vazirmatn/$font"
            curl -fsSL "$font_url" -o "$FONT_DEST/$font" 2>/dev/null || true
        fi
    done

    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$FONT_DEST" >/dev/null 2>&1 || true
    fi
    log "  [OK] Installed Vazirmatn fonts to $FONT_DEST"
else
    log "[1/4] Skipping typography installation (per flags)."
fi

# ------------------------------------------------------------------------------
# 2. Configure Global Antigravity AI Machine Rules & Skills
# ------------------------------------------------------------------------------
if [ "$PROJECT_ONLY" = false ]; then
    log "[2/4] Setting Up Global Antigravity AI Rules & Skills..."
    RULES_DIR="$HOME/.gemini/config/rules"
    SKILLS_DIR="$HOME/.gemini/config/skills/agent-rtl-fix"
    mkdir -p "$RULES_DIR"
    mkdir -p "$SKILLS_DIR"

    cat << 'EOF' > "$RULES_DIR/rtl-formatting.md"
---
trigger: always_on
description: Universal RTL/LTR BiDi formatting rule for right-to-left languages (Persian, Arabic, Urdu, Hebrew)
---
# Universal RTL/LTR BiDi Formatting Rule
- **Chat & Artifacts:** Every chat response and markdown artifact (.md) containing right-to-left text (Persian, Arabic, Urdu, Hebrew) MUST be wrapped completely inside `<div dir="rtl">...</div>` for native RTL rendering. For artifacts with YAML frontmatter, preserve the frontmatter at the top and enclose the markdown body inside `<div dir="rtl">`.
- **Markdown Integrity:** Bullet points, tables, headings, blockquotes, and code blocks inside the `<div dir="rtl">` container retain standard Markdown syntax (do NOT convert tables to raw HTML).
- **Code & LTR Isolation:** Keep inline code, code blocks, file paths, URLs, shell commands, logs, and LaTeX math formulas strictly LTR. Never reverse or break syntax brackets, slashes, or indentation.
- **Zero Exceptions:** Never produce uncontained or left-aligned RTL text in chat or artifacts.
EOF
    log "  [OK] Global Antigravity rule installed at: $RULES_DIR/rtl-formatting.md"

    cat << 'EOF' > "$SKILLS_DIR/SKILL.md"
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
EOF
    log "  [OK] Global Antigravity skill installed at: $SKILLS_DIR/SKILL.md"
else
    log "[2/4] Skipping global machine rules (per flags)."
fi

# ------------------------------------------------------------------------------
# 3. Configure Local Project Rules (Universal AGENTS.md, Cursor, Copilot, Zed)
# ------------------------------------------------------------------------------
if [ "$GLOBAL_ONLY" = false ]; then
    log "[3/4] Checking Current Project Directory..."
    CWD="$(pwd)"
    IS_SELF_REPO=false
    if [ -f "$CWD/rules/AGENTS.md" ] && [ -d "$CWD/fonts/Vazirmatn" ]; then
        IS_SELF_REPO=true
    fi

    if { [ -d "$CWD/.git" ] || [ -f "$CWD/package.json" ] || [ -f "$CWD/go.mod" ] || [ -f "$CWD/Cargo.toml" ] || [ -f "$CWD/pyproject.toml" ] || [ -d "$CWD/.cursor" ] || [ -d "$CWD/.github" ] || [ -d "$CWD/.zed" ]; } && [ "$IS_SELF_REPO" = false ]; then
        log "  -> Project workspace detected at $CWD"
        
        # Universal AGENTS.md
        if [ ! -f "$CWD/AGENTS.md" ]; then
            cat << 'EOF' > "$CWD/AGENTS.md"
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
EOF
            log "  [OK] Added AGENTS.md to current project"
        fi

        # Cursor
        if [ -d "$CWD/.cursor" ]; then
            mkdir -p "$CWD/.cursor/rules"
            cat << 'EOF' > "$CWD/.cursor/rules/bidi.mdc"
---
description: Universal RTL/LTR BiDi formatting rule
globs: *
alwaysApply: true
---
Wrap all responses containing RTL languages (Persian, Arabic, Urdu, Hebrew) in `<div dir="rtl">...</div>`. Keep code and terminal blocks strictly LTR.
EOF
            log "  [OK] Added .cursor/rules/bidi.mdc"
        fi

        # GitHub Copilot
        if [ -d "$CWD/.github" ]; then
            cat << 'EOF' > "$CWD/.github/copilot-instructions.md"
# GitHub Copilot RTL/LTR BiDi Formatting Instructions
Wrap all RTL language responses (Persian, Arabic, Urdu, Hebrew) inside `<div dir="rtl">...</div>`. Keep all code snippets, paths, and commands in standard LTR.
EOF
            log "  [OK] Added .github/copilot-instructions.md"
        fi

        # Zed
        if [ -d "$CWD/.zed" ]; then
            if [ ! -f "$CWD/.zed/settings.json" ]; then
                cat << 'EOF' > "$CWD/.zed/settings.json"
{
  "buffer_font_family": "Vazirmatn",
  "ui_font_family": "Vazirmatn"
}
EOF
                log "  [OK] Added .zed/settings.json"
            fi
        fi
    else
        log "  (No project root in current folder; global machine configs applied)"
    fi
else
    log "[3/4] Skipping project-level configuration (per flags)."
fi

# ------------------------------------------------------------------------------
# 4. Update Editor Settings (VS Code, Cursor, Antigravity, Zed)
# ------------------------------------------------------------------------------
if [ "$PROJECT_ONLY" = false ]; then
    log "[4/4] Updating Editor Settings (Font & BiDi Highlighting)..."
    CONFIG_DIRS=(
        "$HOME/.config/Antigravity/User"
        "$HOME/.config/Code/User"
        "$HOME/.config/Cursor/User"
        "$HOME/.config/zed"
        "$HOME/Library/Application Support/Antigravity/User"
        "$HOME/Library/Application Support/Code/User"
        "$HOME/Library/Application Support/Cursor/User"
        "$HOME/Library/Application Support/Zed"
    )

    for cdir in "${CONFIG_DIRS[@]}"; do
        if [ -d "$cdir" ]; then
            sfile="$cdir/settings.json"
            if [ ! -f "$sfile" ]; then
                echo "{}" > "$sfile"
            fi
            if command -v python3 >/dev/null 2>&1; then
                python3 -c "
import json, sys
sfile = '$sfile'
try:
    with open(sfile, 'r', encoding='utf-8') as f:
        data = json.load(f)
except Exception:
    data = {}

if 'zed' in sfile.lower():
    data['buffer_font_family'] = 'Vazirmatn'
    data['ui_font_family'] = 'Vazirmatn'
else:
    data['editor.fontFamily'] = \"'Vazirmatn', 'Fira Code', 'Cascadia Code', 'Consolas', monospace\"
    data['editor.unicodeHighlight.bidiCharacters'] = True
    data['markdown.preview.fontFamily'] = \"'Vazirmatn', 'Segoe UI', Tahoma, sans-serif\"
    data['chat.editor.fontFamily'] = \"'Vazirmatn', 'Segoe UI', Tahoma, sans-serif\"

with open(sfile, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=4, ensure_ascii=False)
" 2>/dev/null && log "  [OK] Updated $sfile" || true
            fi
        fi
    done
else
    log "[4/4] Skipping editor settings update (per flags)."
fi

log "=========================================================="
log "  Agent RTL Fix installation completed successfully!     "
log "=========================================================="
