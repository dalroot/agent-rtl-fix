#!/usr/bin/env bash
# ==============================================================================
# Agent RTL Fix - Uninstaller for Linux & macOS
# ==============================================================================

echo "Removing Agent RTL Fix global rule..."
TARGET_RULE="$HOME/.gemini/config/rules/rtl-formatting.md"
if [ -f "$TARGET_RULE" ]; then
    rm -f "$TARGET_RULE"
    echo "Removed $TARGET_RULE"
else
    echo "Rule not found."
fi

echo "Uninstallation complete."
