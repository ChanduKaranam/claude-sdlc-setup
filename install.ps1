#Requires -Version 5.1
<#
.SYNOPSIS
    Installs the /setup Claude Code skill for AI-SDLC scaffolding.
.DESCRIPTION
    Downloads the claude-sdlc-setup skill from GitHub and installs it into
    ~/.claude/skills/setup/, then registers the /setup trigger in ~/.claude/CLAUDE.md.
.EXAMPLE
    irm https://raw.githubusercontent.com/ChanduKaranam/claude-sdlc-setup/main/install.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

$REPO    = 'ChanduKaranam/claude-sdlc-setup'
$BRANCH  = 'main'
$ZIP_URL = "https://github.com/$REPO/archive/refs/heads/$BRANCH.zip"

$CLAUDE_DIR  = Join-Path $HOME '.claude'
$SKILLS_DIR  = Join-Path $CLAUDE_DIR 'skills'
$INSTALL_DIR = Join-Path $SKILLS_DIR 'setup'
$CLAUDE_MD   = Join-Path $CLAUDE_DIR 'CLAUDE.md'

$TRIGGER_BLOCK = @"

# setup
- **setup** (``~/.claude/skills/setup/SKILL.md``) - Bootstraps a complete AI-assisted SDLC scaffold into any repo. Trigger: /setup
When the user types /setup, invoke the Skill tool with ``skill: "setup"`` before doing anything else.
"@

Write-Host ""
Write-Host "==> claude-sdlc-setup installer" -ForegroundColor Cyan
Write-Host "    Repo : $REPO"
Write-Host "    Into : $INSTALL_DIR"
Write-Host ""

# 1. Ensure skills directory exists
New-Item -ItemType Directory -Force -Path $SKILLS_DIR | Out-Null

# 2. Download archive to a temp file
Write-Host "--> Downloading archive..." -ForegroundColor Yellow
$tmpZip = [System.IO.Path]::GetTempFileName() + '.zip'
Invoke-WebRequest -Uri $ZIP_URL -OutFile $tmpZip -UseBasicParsing

# 3. Extract to a temp directory
Write-Host "--> Extracting..." -ForegroundColor Yellow
$tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
Expand-Archive -Path $tmpZip -DestinationPath $tmpDir -Force

$extracted = Join-Path $tmpDir "$($REPO.Split('/')[-1])-$BRANCH\setup"
if (-not (Test-Path $extracted)) {
    Write-Error "Unexpected archive layout — expected: $extracted"
    exit 1
}

# 4. Back up any existing install
if (Test-Path $INSTALL_DIR) {
    $ts      = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupDir = "$INSTALL_DIR.bak-$ts"
    Write-Host "--> Backing up existing install to $backupDir" -ForegroundColor Yellow
    Move-Item -Path $INSTALL_DIR -Destination $backupDir
}

# 5. Copy skill into place
Write-Host "--> Installing skill..." -ForegroundColor Yellow
Copy-Item -Recurse -Path $extracted -Destination $INSTALL_DIR

# 6. Register /setup trigger in CLAUDE.md (idempotent)
Write-Host "--> Registering trigger in CLAUDE.md..." -ForegroundColor Yellow
if (-not (Test-Path $CLAUDE_MD)) {
    New-Item -ItemType File -Force -Path $CLAUDE_MD | Out-Null
}
$claudeContent = Get-Content $CLAUDE_MD -Raw -ErrorAction SilentlyContinue
if ($claudeContent -notmatch 'skills/setup/SKILL\.md') {
    Add-Content -Path $CLAUDE_MD -Value $TRIGGER_BLOCK
    Write-Host "    Trigger appended to CLAUDE.md" -ForegroundColor Green
} else {
    Write-Host "    Trigger already present in CLAUDE.md — skipped" -ForegroundColor DarkGray
}

# 7. Clean up
Remove-Item -Recurse -Force -Path $tmpDir -ErrorAction SilentlyContinue
Remove-Item -Force -Path $tmpZip -ErrorAction SilentlyContinue

# 8. Done
Write-Host ""
Write-Host "==> Install complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Installed to : $INSTALL_DIR"
Write-Host "CLAUDE.md    : $CLAUDE_MD"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open any project in Claude Code."
Write-Host "  2. Type /setup to bootstrap the full AI-SDLC scaffold."
Write-Host ""
Write-Host "The generated commands run on the superpowers + ponytail plugins."
Write-Host "The settings.json that /setup writes declares both, so Claude Code will"
Write-Host "offer to install them on your next session in that repo. To have them"
Write-Host "globally instead, run these in Claude Code:"
Write-Host ""
Write-Host "  /plugin marketplace add anthropics/claude-plugins-official"
Write-Host "  /plugin install superpowers@claude-plugins-official"
Write-Host "  /plugin marketplace add DietrichGebert/ponytail"
Write-Host "  /plugin install ponytail@ponytail"
Write-Host ""
Write-Host "To uninstall:"
Write-Host "  Remove-Item -Recurse -Force '$INSTALL_DIR'"
Write-Host "  (also remove the '# setup' block from $CLAUDE_MD)"
Write-Host ""
