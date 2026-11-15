# Zed Editor BiDi RTL/LTR & Typography Configuration

To enable clean Vazirmatn typography and bidirectional text support in Zed:

### 1. Editor Configuration (`~/.config/zed/settings.json` or `%APPDATA%\Zed\settings.json`)
```json
{
  "buffer_font_family": "Vazirmatn",
  "buffer_font_size": 15,
  "ui_font_family": "Vazirmatn",
  "ui_font_size": 15
}
```

### 2. AI Assistant Rule
When interacting with Zed's integrated Assistant panel, add this instruction or place `AGENTS.md` in the workspace root:

- Whenever responding in right-to-left languages (Persian, Arabic, Urdu, Hebrew), wrap conversational and explanatory text inside `<div dir="rtl">...</div>`.
- Keep all code blocks, diffs, terminal commands, and file paths strictly LTR.
- Maintain standard GitHub Flavored Markdown for headings, lists, and tables inside the container.
