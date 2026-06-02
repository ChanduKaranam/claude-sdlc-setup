#!/usr/bin/env node
// PreToolUse hook: block image writes under docs/ (cross-platform, no jq dependency).
let input = '';
process.env.CLAUDE_TOOL_INPUT && (input = process.env.CLAUDE_TOOL_INPUT);
try {
  const parsed = JSON.parse(input || '{}');
  const file = parsed.path || parsed.file_path || '';
  if (/^docs\/.*\.(png|jpg|jpeg|gif|webp|svg|fig)$/.test(file)) {
    process.stderr.write(JSON.stringify({
      block: true,
      message: 'UI is spec-ed by tickets, not mockups. Image writes under docs/ are blocked. Add requirements to the ticket file instead.'
    }) + '\n');
    process.exit(2);
  }
} catch (_) {}
process.exit(0);
