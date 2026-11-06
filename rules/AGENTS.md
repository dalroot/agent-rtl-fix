# Universal AI Agent RTL/LTR BiDi Formatting Standard

This specification defines the universal bidirectional text formatting protocol for autonomous AI agents, coding assistants, and LLM runtimes (including Antigravity, Cursor, Windsurf, Copilot, Claude Code, Cline, and Aider).

## 1. Rule Definition

Whenever responding or generating documentation in right-to-left (RTL) languages (Persian, Arabic, Urdu, Hebrew):

1. **Outer RTL Boundary**: Wrap the complete response or markdown file inside `<div dir="rtl">...</div>`.
2. **Markdown Preservation**: Retain standard GitHub Flavored Markdown (GFM) inside the container. Do NOT convert Markdown tables to verbose raw HTML.
3. **BiDi Code & Log Isolation**: All code blocks (````lang ... ````), inline code (`code`), terminal logs, shell commands, URLs, and file paths must remain strictly LTR. Do not flip brackets, slashes, or indentation.
4. **Zero Left-Aligned RTL**: Never emit uncontained right-to-left text.
