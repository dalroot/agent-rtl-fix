# Claude Code BiDi RTL/LTR Formatting Guidelines

- Whenever formulating output in RTL languages (Persian, Arabic, Urdu, Hebrew), wrap the entire response inside an HTML `<div dir="rtl">...</div>` block.
- Keep standard Markdown formatting for text, headings, and tables inside the RTL wrapper.
- All code blocks, inline code, terminal snippets, logs, and file paths must be rendered as clean LTR text.
- Never output uncontained RTL text that would cause reversed punctuation or ragged left alignment.
