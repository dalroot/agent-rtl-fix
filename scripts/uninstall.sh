#!/usr/bin/env bash
# ==============================================================================
# Agent RTL Fix - Uninstaller for Linux & macOS (v2.1.0)
# Supports: Standard rule removal and --full typography cleanup
# ==============================================================================

set -e

FULL=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --full) FULL=true; shift ;;
        *) shift ;;
    esac
done

echo "Removing Agent RTL Fix global configuration..."

# 1. Remove Global Rule & Skill
RULES_FILE="$HOME/.gemini/config/rules/rtl-formatting.md"
SKILLS_DIR="$HOME/.gemini/config/skills/agent-rtl-fix"

if [ -f "$RULES_FILE" ]; then
    rm -f "$RULES_FILE"
    echo "  [OK] Removed $RULES_FILE"
fi

if [ -d "$SKILLS_DIR" ]; then
    rm -rf "$SKILLS_DIR"
    echo "  [OK] Removed $SKILLS_DIR"
fi

# 2. Optional Full Cleanup
if [ "$FULL" = true ]; then
    echo "Cleaning up Vazirmatn fonts..."
    if [ "$(uname)" == "Darwin" ]; then
        FONT_DEST="$HOME/Library/Fonts"
        rm -f "$FONT_DEST"/Vazirmatn-*.ttf 2>/dev/null || true
    else
        FONT_DEST="$HOME/.local/share/fonts/Vazirmatn"
        rm -rf "$FONT_DEST" 2>/dev/null || true
        if command -v fc-cache >/dev/null 2>&1; then
            fc-cache -f >/dev/null 2>&1 || true
        fi
    fi
    echo "  [OK] Removed font files"
fi

echo "Uninstallation complete."
