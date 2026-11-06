# GitHub Copilot RTL/LTR BiDi Formatting Instructions

- When responding in right-to-left languages (such as Persian, Arabic, Urdu, or Hebrew), wrap the entire response inside `<div dir="rtl">...</div>` to ensure proper native RTL layout in VS Code chat windows.
- Preserve standard Markdown formatting (tables, bullet points, numbered lists, blockquotes) inside the RTL container.
- Code snippets, file paths, command-line examples, and technical identifiers must retain standard LTR alignment with unmodified syntax.
- Ensure zero punctuation distortion (e.g. parentheses, colons, dots) at line boundaries.
