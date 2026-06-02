#!/usr/bin/env node
// Stop hook: saves git state to docs/sessions/ (cross-platform, no jq dependency).
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
function run(cmd) { try { return execSync(cmd, { encoding: 'utf8' }).trim(); } catch (_) { return ''; } }
const branch = run('git branch --show-current') || 'unknown';
const ts = new Date().toISOString().replace(/[:.]/g, '').slice(0, 15);
const safeBranch = branch.replace(/\//g, '-');
const dir = path.join(process.cwd(), 'docs', 'sessions');
fs.mkdirSync(dir, { recursive: true });
const file = path.join(dir, `${ts}_${safeBranch}.md`);
const content = `# Session Snapshot
**Timestamp:** ${new Date().toISOString()}
**Branch:** ${branch}

## Last 10 Commits
\`\`\`
${run('git log --oneline -10') || 'No commits yet'}
\`\`\`

## Modified Files
\`\`\`
${run('git status --short') || 'Clean'}
\`\`\`
`;
fs.writeFileSync(file, content);
console.log(`Session snapshot saved: ${file}`);
process.exit(0);
