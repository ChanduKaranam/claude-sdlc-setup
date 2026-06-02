#!/usr/bin/env node
// PreToolUse hook: block edits to protected branches (cross-platform, no jq dependency).
// Customize PROTECTED_BRANCHES below after /setup generates this file.
const { execSync } = require('child_process');
const PROTECTED_BRANCHES = ['{{PROTECTED_BRANCHES_ARRAY}}'];
try {
  const branch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();
  if (PROTECTED_BRANCHES.includes(branch)) {
    process.stderr.write(JSON.stringify({
      block: true,
      message: `Direct edits to ${branch} are blocked. Branch off {{BASE_BRANCH}}: git switch -c feature/your-feature {{BASE_BRANCH}}`
    }) + '\n');
    process.exit(2);
  }
} catch (_) {}
process.exit(0);
