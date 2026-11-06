# 🌐 Agent RTL Fix

<p align="center">
  <b>Universal BiDi (RTL/LTR) Formatting Standard & Typography for AI Coding Agents</b>
  <br />
  <i>Zero-token bloat, native Markdown preservation, and isolated LTR code blocks for Persian, Arabic, Urdu, and Hebrew.</i>
</p>

<p align="center">
  <a href="https://github.com/dalroot/agent-rtl-fix/releases"><img src="https://img.shields.io/badge/release-v2.0.0-blue.svg?style=flat-square" alt="Release v2.0.0"></a>
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-informational.svg?style=flat-square" alt="Platforms">
  <img src="https://img.shields.io/badge/agents-Antigravity%20%7C%20Cursor%20%7C%20Windsurf%20%7C%20Copilot%20%7C%20Claude-success.svg?style=flat-square" alt="Supported Agents">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat-square" alt="License MIT"></a>
</p>

---

<div dir="rtl">

### 🇮🇷 معرفی به زبان فارسی
**Agent RTL Fix** یک استاندارد مدرن و سبک برای حل ریشه‌ای مشکلات راست‌چین‌سازی (RTL) و چندجهته (BiDi) در پاسخ‌های تمامی ایجنت‌های هوش مصنوعی کدنویسی مانند **Google Antigravity**، **Cursor**، **Windsurf**، **GitHub Copilot**، **Claude Code** و **Cline** است.

#### چرا نسخه جدید (v2.0.0) متفاوت است؟
* ⚡ **حداقل مصرف توکن (Zero Token Overhead):** برخلاف روش‌های قدیمی که صدها کاراکتر اینلاین‌استایل سنگین به هر پیام تحمیل می‌کردند، این ابزار با یک تگ بومی ساختار را مرتب می‌کند.
* 🛡️ **حفظ ساختار مارک‌داون:** جداول، لیست‌ها و علائم نگارشی خراب نمی‌شوند و به کدهای HTML طویل تبدیل نمی‌گردند.
* 💻 **ایزوله‌سازی دقیق LTR:** تمامی بلاک‌های کد، لاگ‌ها، مسیر فایل‌ها و دستورات ترمینال به صورت چپ‌چین دقیق حفظ می‌شوند تا پرانتزها و اسلش‌ها برعکس نشوند.
* 🔤 **فونت فوق‌العاده سبک وزیرمتن (Vazirmatn):** فقط وزن‌های پایه و ضروری برای ادیتور با کاهش ۹۶٪ حجم مخزن.
* 🌐 **پشتیبانی Cross-Platform:** نصب خودکار روی لینوکس، مک و ویندوز.

</div>

---

## ⚡ Key Highlights

- **Native BiDi Alignment**: Completely eliminates inverted parentheses `()`, messed brackets `[]`, and reversed paths (`/` and `\`) when mixing English code with RTL languages.
- **Zero Token Overhead**: Pure wrapper syntax that doesn't waste LLM output tokens on redundant inline CSS styling.
- **Non-Destructive**: Doesn't overwrite your custom workspace configurations or force unwanted color themes.
- **Multi-Agent Ready**: Drop-in rules formatted for every leading AI coding environment.

---

## 🚀 Quick Install (1-Liner)

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/dalroot/agent-rtl-fix/main/install.ps1 | iex
```

### Linux & macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/dalroot/agent-rtl-fix/main/install.sh | bash
```

### Manual / Offline
1. Download the latest `agent-rtl-fix-v2.0.0.zip` from [Releases](https://github.com/dalroot/agent-rtl-fix/releases).
2. Extract and run `install.bat` (Windows) or `bash install.sh` (Linux/macOS).

---

## 🤖 Supported AI Agents Matrix

| AI Coding Agent | Config Location | Rule File in this Repo | Setup Action |
| :--- | :--- | :--- | :--- |
| **Google Antigravity** | `~/.gemini/config/rules/` | [`rules/antigravity.md`](rules/antigravity.md) | Installed automatically system-wide (`trigger: always_on`) |
| **Cursor IDE** | `.cursor/rules/` or project root | [`rules/cursor.mdc`](rules/cursor.mdc) | Copy to `.cursor/rules/bidi.mdc` or `.cursorrules` |
| **Windsurf (Codeium)** | Project root | [`rules/windsurf.rules`](rules/windsurf.rules) | Copy to `.windsurfrules` |
| **GitHub Copilot** | `.github/` | [`rules/copilot-instructions.md`](rules/copilot-instructions.md) | Copy to `.github/copilot-instructions.md` |
| **Claude Code** | Project root | [`rules/claude.md`](rules/claude.md) | Append to `CLAUDE.md` |
| **Cline / Roo Code** | Project root | [`rules/cline.md`](rules/cline.md) | Copy to `.clinerules` |
| **Universal Standard** | Any project root | [`rules/AGENTS.md`](rules/AGENTS.md) | Place `AGENTS.md` in repository root |

---

## 📁 Repository Structure

```text
agent-rtl-fix/
├── .github/
│   └── workflows/
│       └── release.yml          # Automated release and zip packager
├── rules/                       # Modular rules for every agent
│   ├── antigravity.md           # Antigravity always_on global rule
│   ├── cursor.mdc               # Cursor IDE rule
│   ├── windsurf.rules           # Windsurf rules
│   ├── copilot-instructions.md  # GitHub Copilot instructions
│   ├── claude.md                # Claude Code instructions
│   ├── cline.md                 # Cline / Roo Code rules
│   └── AGENTS.md                # Universal AI Agent specification
├── fonts/                       # Core Vazirmatn typography (~500 KB)
│   └── Vazirmatn/
│       ├── Vazirmatn-Regular.ttf
│       ├── Vazirmatn-Medium.ttf
│       ├── Vazirmatn-SemiBold.ttf
│       └── Vazirmatn-Bold.ttf
├── scripts/
│   ├── install.ps1              # Modular Windows installer
│   ├── install.sh               # Modular Linux/macOS installer
│   ├── uninstall.ps1            # Windows cleanup script
│   └── uninstall.sh             # Linux/macOS cleanup script
├── install.bat                  # 1-Click Windows launcher
├── install.ps1                  # Root PowerShell installer
├── install.sh                   # Root Bash installer
├── LICENSE                      # MIT License
└── README.md
```

---

## ⚙️ The Core Formatting Rule

The standard universal instruction enforced across all agents:

```markdown
- Whenever responding in RTL languages (Persian, Arabic, Urdu, Hebrew):
  1. Wrap the complete response inside <div dir="rtl">...</div>.
  2. Keep standard Markdown syntax for headings, bullet points, and tables.
  3. Keep all code blocks, logs, terminal outputs, and file paths strictly LTR.
  4. Never produce uncontained or left-aligned RTL text.
```

---

## 📜 License

This project is licensed under the **MIT License**. Free for open-source and commercial use.
