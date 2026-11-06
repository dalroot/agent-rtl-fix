#!/usr/bin/env bash
# ==============================================================================
# Agent RTL Fix - Universal Linux & macOS Installer (v2.0.0)
# Supports: One-liner remote execution and local offline execution
# ==============================================================================

set -e

REPO_OWNER="dalroot"
REPO_NAME="agent-rtl-fix"
BRANCH="main"

echo "=========================================================="
echo "  Agent RTL Fix (v2.0.0) - Universal BiDi Setup Engine   "
echo "=========================================================="

# 1. Install Fonts
echo "[1/4] Installing Core Vazirmatn Typography..."
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

SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

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
echo "  [OK] Installed Vazirmatn fonts to $FONT_DEST"

# 2. Configure Global Antigravity Machine Rule
echo "[2/4] Setting Up Global Antigravity AI Rules..."
RULES_DIR="$HOME/.gemini/config/rules"
mkdir -p "$RULES_DIR"

cat << 'EOF' > "$RULES_DIR/rtl-formatting.md"
---
trigger: always_on
description: Universal RTL/LTR BiDi formatting rule for right-to-left languages (Persian, Arabic, Urdu, Hebrew)
---
# Universal RTL/LTR BiDi Formatting Rule
- **Chat & Artifacts:** Every chat response and markdown artifact (.md) containing right-to-left text (Persian, Arabic, Urdu, Hebrew) MUST be wrapped completely inside `<div dir="rtl">...</div>` from start to end for native RTL rendering.
- **Markdown Integrity:** Bullet points, tables, headings, blockquotes, and code blocks inside the `<div dir="rtl">` container retain standard Markdown syntax (do NOT convert tables to raw HTML).
- **Code & LTR Isolation:** Keep inline code, code blocks, file paths, URLs, shell commands, and logs strictly LTR. Never reverse or break syntax brackets, slashes, or indentation.
- **Zero Exceptions:** Never produce uncontained or left-aligned RTL text in chat or artifacts.
EOF

echo "  [OK] Global Antigravity rule installed at: $RULES_DIR/rtl-formatting.md"

# 3. Configure Local Project Rules (Cursor, Windsurf, Copilot, Claude, Cline)
echo "[3/4] Checking Current Project Directory..."
CWD="$(pwd)"
if [ -d "$CWD/.git" ] || [ -f "$CWD/package.json" ] || [ -f "$CWD/go.mod" ] || [ -f "$CWD/Cargo.toml" ] || [ -f "$CWD/pyproject.toml" ]; then
    echo "  -> Project workspace detected at $CWD"
    
    # Universal AGENTS.md
    if [ ! -f "$CWD/AGENTS.md" ]; then
        cat << 'EOF' > "$CWD/AGENTS.md"
# Universal AI Agent RTL/LTR BiDi Formatting Standard

Whenever responding or generating documentation in right-to-left (RTL) languages (Persian, Arabic, Urdu, Hebrew):
1. **Outer RTL Boundary**: Wrap the complete response or markdown file inside `<div dir="rtl">...</div>`.
2. **Markdown Preservation**: Retain standard GitHub Flavored Markdown (GFM) inside the container. Do NOT convert Markdown tables to verbose raw HTML.
3. **BiDi Code & Log Isolation**: All code blocks (```lang ... ```), inline code (`code`), terminal logs, shell commands, URLs, and file paths must remain strictly LTR.
4. **Zero Exceptions**: Never emit uncontained or left-aligned RTL text.
EOF
        echo "  [OK] Added AGENTS.md to current project"
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
        echo "  [OK] Added .cursor/rules/bidi.mdc"
    fi

    # GitHub Copilot
    if [ -d "$CWD/.github" ]; then
        cat << 'EOF' > "$CWD/.github/copilot-instructions.md"
# GitHub Copilot RTL/LTR BiDi Formatting Instructions
Wrap all RTL language responses (Persian, Arabic, Urdu, Hebrew) inside `<div dir="rtl">...</div>`. Keep all code snippets, paths, and commands in standard LTR.
EOF
        echo "  [OK] Added .github/copilot-instructions.md"
    fi
else
    echo "  (No project root in current folder; global machine configs applied)"
fi

# 4. Update VS Code / Antigravity / Cursor settings if present
echo "[4/4] Updating Editor Settings (Font & BiDi Highlighting)..."
CONFIG_DIRS=(
    "$HOME/.config/Antigravity/User"
    "$HOME/.config/Code/User"
    "$HOME/.config/Cursor/User"
    "$HOME/Library/Application Support/Antigravity/User"
    "$HOME/Library/Application Support/Code/User"
    "$HOME/Library/Application Support/Cursor/User"
)

for cdir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$cdir" ]; then
        sfile="$cdir/settings.json"
        if [ ! -f "$sfile" ]; then
            echo "{}" > "$sfile"
        fi
        if command -v python3 >/dev/null 2>&1; then
            python3 -c "
import json
try:
    with open('$sfile', 'r', encoding='utf-8') as f:
        data = json.load(f)
except Exception:
    data = {}
data['editor.fontFamily'] = \"'Vazirmatn', 'Fira Code', 'Cascadia Code', 'Consolas', monospace\"
data['editor.unicodeHighlight.bidiCharacters'] = True
data['markdown.preview.fontFamily'] = \"'Vazirmatn', 'Segoe UI', Tahoma, sans-serif\"
data['chat.editor.fontFamily'] = \"'Vazirmatn', 'Segoe UI', Tahoma, sans-serif\"
with open('$sfile', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=4, ensure_ascii=False)
" 2>/dev/null && echo "  [OK] Updated $sfile" || true
        fi
    fi
done

echo "=========================================================="
echo "  Agent RTL Fix installation completed successfully!     "
echo "=========================================================="
