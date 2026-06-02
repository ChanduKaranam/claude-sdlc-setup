#!/usr/bin/env node
// PostToolUse hook: nag to /compact at 50/80 tool calls (cross-platform, no jq dependency).
const fs = require('fs');
const os = require('os');
const path = require('path');
const sessionId = process.env.CLAUDE_SESSION_ID || `pid-${process.ppid}`;
const counterFile = path.join(os.tmpdir(), `claude-nag-${sessionId}.count`);
const nagged50 = path.join(os.tmpdir(), `claude-nag-${sessionId}.50`);
const nagged80 = path.join(os.tmpdir(), `claude-nag-${sessionId}.80`);
let count = 0;
try { count = parseInt(fs.readFileSync(counterFile, 'utf8')) || 0; } catch (_) {}
count++;
fs.writeFileSync(counterFile, String(count));
if (count >= 80 && !fs.existsSync(nagged80)) {
  fs.writeFileSync(nagged80, '');
  process.stdout.write(JSON.stringify({ feedback: `Tool call #${count} — context likely heavy. Run /compact NOW or expect quota wall.` }) + '\n');
} else if (count >= 50 && !fs.existsSync(nagged50)) {
  fs.writeFileSync(nagged50, '');
  process.stdout.write(JSON.stringify({ feedback: `Tool call #${count} — consider /compact before next subagent dispatch or large read.` }) + '\n');
}
process.exit(0);
