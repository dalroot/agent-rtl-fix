<div dir="rtl">

# 🌐 ابزار Agent RTL Fix

<p align="center">
  <b>استاندارد جهانی اصلاح متون چندجهته (BiDi / RTL) و فونت وزیرمتن برای ایجنت‌های هوش مصنوعی کدنویسی</b>
  <br />
  <i>بدون مصرف توکن اضافه، حفظ کامل ساختار مارک‌داون و ایزوله‌سازی دقیق کدهای برنامه‌نویسی و لاگ‌های LTR</i>
</p>

<p align="center">
  <a href="https://github.com/dalroot/agent-rtl-fix/releases"><img src="https://img.shields.io/badge/release-v2.1.0-blue.svg?style=flat-square" alt="Release v2.1.0"></a>
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-informational.svg?style=flat-square" alt="Platforms">
  <img src="https://img.shields.io/badge/agents-Antigravity%20%7C%20Cursor%20%7C%20Windsurf%20%7C%20Zed%20%7C%20Aider%20%7C%20Copilot%20%7C%20Claude-success.svg?style=flat-square" alt="Supported Agents">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat-square" alt="License MIT"></a>
</p>

<p align="center">
  <a href="README.md"><b>English (انگلیسی)</b></a> • <b>🇮🇷 راهنمای فارسی</b>
</p>

---

## ⚡ ریشه مشکل چیست؟

هنگامی که ایجنت‌های هوش مصنوعی برنامه‌نویسی (مانند **Google Antigravity**، **Cursor**، **Windsurf**، **Zed**، **Aider**، **GitHub Copilot** یا **Claude Code**) به زبان‌های راست‌چین (فارسی، عربی، اردو، عبری) پاسخ می‌دهند، چالش‌های زیر رخ می‌دهد:

۱. **جابجایی پرانتزها و علائم نگارشی:** پرانتزها `()`، کروشه‌ها `[]` و علائم نگارشی بین خطوط معلق و جابجا می‌شوند.  
۲. **معکوس شدن مسیر فایل‌ها و لینک‌ها:** آدرس فایل‌ها (`/var/log/...` یا `C:\Users\...`) و URLها به صورت معکوس و درهم‌ریخته رندر می‌شوند.  
۳. **بهم‌ریختگی جداول:** ستون‌های جداول مارک‌داون یا برعکس می‌شوند یا ایجنت مجبور به نوشتن کدهای طولانی HTML می‌گردد.  
۴. **اتلاف توکن در راهکارهای قدیمی:** روش‌های قدیمی صدها کاراکتر اینلاین‌استایل سنگین به هر پاراگراف تحمیل می‌کردند که سرعت پاسخ را کم و مصرف توکن را به شدت بالا می‌برد.

**Agent RTL Fix** این مسئله را به صورت ریشه‌ای، سبک و بدون هیچ سربار توکنی برطرف می‌سازد.

---

## 💬 فعال‌سازی مستقیم با ۱ پرامپت در چت (بدون نیاز به ترمینال)

نیازی به باز کردن ترمینال نیست! کافیست پرامپت زیر را کپی کرده و مستقیماً در پنجره چت ایجنت هوش مصنوعی خود (در Antigravity، Cursor، Windsurf، Zed، Claude Code یا Copilot) ارسال کنید:

```text
لطفاً استاندارد راست‌چین‌سازی و فرمت‌بندی دوطرفه (BiDi/RTL) را از نشانی زیر بخوان و به عنوان قانون دائم (Always-on Rule) در این محیط/پروژه اعمال کن:
https://raw.githubusercontent.com/dalroot/agent-rtl-fix/main/rules/AGENTS.md
```

---

## 🚀 نصب سریع از طریق ترمینال (دستور تک‌خطی)

اجرای اسکریپت نصب به صورت خودکار فونت‌های بهینه وزیرمتن را نصب کرده (همراه با فراخوانی سیستمی جهت فعال‌سازی آنی بدون نیاز به ریستارت سیستم)، قابلیت BiDi را در ادیتور فعال می‌سازد و قوانین سراسری و پروژه را ثبت می‌کند:

### در ویندوز (PowerShell)
```powershell
irm https://raw.githubusercontent.com/dalroot/agent-rtl-fix/main/install.ps1 | iex
```

### در لینوکس و مک (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/dalroot/agent-rtl-fix/main/install.sh | bash
```

### سوییچ‌های پیشرفته خط فرمان (CLI Flags)

نصب‌کننده‌ها از سوییچ‌های اختیاری زیر پشتیبانی می‌کنند:

| سوییچ در PowerShell | فلگ در Bash | توضیحات |
| :--- | :--- | :--- |
| `-GlobalOnly` | `--global-only` | فقط اعمال تنظیمات، فونت‌ها و قوانین سراسری سیستم (نادیده گرفتن پوشه پروژه فعلی) |
| `-ProjectOnly` | `--project-only` | فقط ایجاد فایل‌های قانون `AGENTS.md` در پروژه فعلی (بدون دستکاری تنظیمات سراسری سیستم) |
| `-NoFonts` | `--no-fonts` | عدم نصب فونت (مناسب برای سرورها، خطوط CI/CD و کانتینرهای داکر) |
| `-Silent` | `--silent` | اجرای بی‌صدا و بدون نمایش بنر و لاگ‌های اضافی |

*نمونه استفاده:*
```powershell
.\install.ps1 -ProjectOnly
```

### نصب آفلاین / با یک کلیک
1. فایل زیپ پکیج را از [صفحه آخرین نسخه](https://github.com/dalroot/agent-rtl-fix/releases/latest) دانلود کنید.
2. فایل را از حالت فشرده خارج کرده و روی `install.bat` (ویندوز) یا `bash install.sh` (لینوکس/مک) کلیک کنید.

---

## 🤖 ماتریس پشتیبانی ایجنت‌های هوش مصنوعی

| ایجنت برنامه‌نویسی | محل قرارگیری فایل کانفیگ | فایل قانون در این ریپازیتوری | نحوه فعال‌سازی |
| :--- | :--- | :--- | :--- |
| **Google Antigravity** | `~/.gemini/config/rules/` و `skills/` | [`rules/antigravity.md`](rules/antigravity.md) | نصب خودکار سراسری روی کل سیستم (`trigger: always_on`) |
| **Cursor IDE** | `.cursor/rules/` یا ریشه پروژه | [`rules/cursor.mdc`](rules/cursor.mdc) | کپی در `.cursor/rules/bidi.mdc` یا `.cursorrules` |
| **Windsurf (Codeium)** | ریشه پروژه | [`rules/windsurf.rules`](rules/windsurf.rules) | کپی در `.windsurfrules` |
| **Zed Editor** | `.zed/settings.json` یا ریشه پروژه | [`rules/zed.md`](rules/zed.md) | تنظیم فونت وزیرمتن در Zed و قرار دادن `AGENTS.md` |
| **Aider CLI** | `.aider.conf.yml` یا ریشه پروژه | [`rules/aider.md`](rules/aider.md) | افزودن متن پرامپت به `.aider.conf.yml` یا قرار دادن `AGENTS.md` |
| **GitHub Copilot** | پوشه `.github/` | [`rules/copilot-instructions.md`](rules/copilot-instructions.md) | کپی در `.github/copilot-instructions.md` |
| **Claude Code** | ریشه پروژه | [`rules/claude.md`](rules/claude.md) | اضافه کردن به فایل `CLAUDE.md` |
| **Cline / Roo Code** | ریشه پروژه | [`rules/cline.md`](rules/cline.md) | کپی در `.clinerules` |
| **استاندارد عمومی ایجنت‌ها** | ریشه هر پروژه | [`rules/AGENTS.md`](rules/AGENTS.md) | قرار دادن فایل `AGENTS.md` در روت پروژه |

---

## ⚙️ متن اصلی قانون هوش مصنوعی

دستورالعمل استانداردی که روی تمام ایجنت‌ها اعمال می‌شود:

```markdown
- Whenever responding in RTL languages (Persian, Arabic, Urdu, Hebrew):
  1. Wrap the complete response inside <div dir="rtl">...</div>.
  2. Keep standard Markdown syntax for headings, bullet points, and tables.
  3. Keep all code blocks, logs, terminal outputs, file paths, and LaTeX math strictly LTR.
  4. Ensure surrounding punctuation around inline code does not flip.
  5. Never produce uncontained or left-aligned RTL text.
```

---

## 📁 ساختار فایل‌های پروژه

```text
agent-rtl-fix/
├── .github/
│   └── workflows/
│       ├── ci.yml               # ماتریس تست خودکار در Windows، Ubuntu و macOS
│       └── release.yml          # انتشار خودکار پکیج زیپ و صفحه ریلیز
├── rules/                       # قوانین تفکیک‌شده برای تمام ایجنت‌ها
│   ├── antigravity.md           # قانون سراسری Antigravity
│   ├── cursor.mdc               # قانون اختصاصی Cursor
│   ├── windsurf.rules           # قانون Windsurf
│   ├── zed.md                   # راهنمای تنظیمات ادیتور Zed
│   ├── aider.md                 # دستور پرامپت دستیار کدنویسی Aider
│   ├── copilot-instructions.md  # دستورالعمل GitHub Copilot
│   ├── claude.md                # دستورالعمل Claude Code
│   ├── cline.md                 # قانون Cline و Roo Code
│   └── AGENTS.md                # استاندارد جهانی AGENTS.md
├── skills/                      # مهارت‌های سفارشی Antigravity AI
│   └── agent-rtl-fix/
│       └── SKILL.md             # تعریف سراسری مهارت
├── fonts/                       # فونت سبک وزیرمتن (~۵۰۰ کیلوبایت)
│   └── Vazirmatn/
│       ├── Vazirmatn-Regular.ttf
│       ├── Vazirmatn-Medium.ttf
│       ├── Vazirmatn-SemiBold.ttf
│       └── Vazirmatn-Bold.ttf
├── scripts/
│   ├── install.ps1              # اسکریپت نصب ویندوز (همراه با حل باگ PS5.1)
│   ├── install.sh               # اسکریپت نصب لینوکس و مک
│   ├── uninstall.ps1            # اسکریپت حذف ویندوز (با پشتیبانی از سوییچ Full)
│   └── uninstall.sh             # اسکریپت حذف لینوکس و مک (با پشتیبانی از سوییچ full)
├── install.bat                  # لانچر اجرای تک‌کلیکی ویندوز
├── install.ps1                  # اسکریپت اصلی پاورشل
├── install.sh                   # اسکریپت اصلی بش
├── LICENSE                      # مجوز رسمی MIT
├── README.md                    # مستندات رسمی انگلیسی
└── README.fa.md                 # مستندات رسمی فارسی
```

---

## 🔍 کلمات کلیدی و جستجوهای مرتبط
`راست‌چین‌سازی هوش مصنوعی` • `حل مشکل پرانتز در چت و ادیتور` • `فونت وزیرمتن در VS Code` • `قوانین RTL برای Cursor و Windsurf` • `اصلاح متون دوطرفه BiDi` • `آنتی‌گراویتی فارسی` • `پشتیبانی ادیتور Zed و Aider` • `اصلاح فونت و چینش Copilot و Claude Code`

---

## 📜 مجوز (License)

این پروژه تحت مجوز **MIT** منتشر شده است و برای تمام پروژه‌های متن‌باز و تجاری رایگان است.

</div>
