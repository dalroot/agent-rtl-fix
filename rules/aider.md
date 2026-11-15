# Aider AI Coding Assistant BiDi RTL/LTR Instruction

To configure Aider for clean bidirectional output in terminal sessions:

### 1. Configuration File (`.aider.conf.yml`)
Add or append to `.aider.conf.yml` in your project or home directory:
```yaml
system-prompt: |
  Whenever responding in right-to-left (RTL) languages (Persian, Arabic, Urdu, Hebrew):
  1. Wrap all conversational, explanatory, and documentation text inside `<div dir="rtl">...</div>`.
  2. Keep all unified diffs, code edits, file paths, and terminal snippets strictly LTR.
  3. Never invert brackets, slashes, or syntax markers.
```

### 2. Universal Project Rule (`AGENTS.md`)
Alternatively, place `AGENTS.md` in your repository root, which Aider automatically reads when indexing project context.
