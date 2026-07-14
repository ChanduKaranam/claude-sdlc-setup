#!/bin/sh
# Installs the /setup Claude Code skill for AI-SDLC scaffolding.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ChanduKaranam/claude-sdlc-setup/main/install.sh | sh
set -e

REPO="ChanduKaranam/claude-sdlc-setup"
BRANCH="main"
TARBALL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
INSTALL_DIR="${SKILLS_DIR}/setup"
CLAUDE_MD="${CLAUDE_DIR}/CLAUDE.md"

TRIGGER_BLOCK='
# setup
- **setup** (`~/.claude/skills/setup/SKILL.md`) - Bootstraps a complete AI-assisted SDLC scaffold into any repo. Trigger: /setup
When the user types /setup, invoke the Skill tool with `skill: "setup"` before doing anything else.'

echo ""
echo "==> claude-sdlc-setup installer"
echo "    Repo : ${REPO}"
echo "    Into : ${INSTALL_DIR}"
echo ""

# 1. Ensure skills directory exists
mkdir -p "${SKILLS_DIR}"

# 2. Download and extract archive into a temp dir
echo "--> Downloading and extracting archive..."
TMP=$(mktemp -d)
curl -fsSL "${TARBALL}" | tar -xz -C "${TMP}"

EXTRACTED="${TMP}/$(basename ${REPO})-${BRANCH}/setup"
if [ ! -d "${EXTRACTED}" ]; then
  echo "ERROR: Unexpected archive layout — expected: ${EXTRACTED}" >&2
  rm -rf "${TMP}"
  exit 1
fi

# 3. Back up any existing install
if [ -d "${INSTALL_DIR}" ]; then
  TS=$(date +%Y%m%d-%H%M%S)
  BACKUP="${INSTALL_DIR}.bak-${TS}"
  echo "--> Backing up existing install to ${BACKUP}"
  mv "${INSTALL_DIR}" "${BACKUP}"
fi

# 4. Copy skill into place
echo "--> Installing skill..."
cp -R "${EXTRACTED}" "${INSTALL_DIR}"

# 5. Register /setup trigger in CLAUDE.md (idempotent)
echo "--> Registering trigger in CLAUDE.md..."
mkdir -p "${CLAUDE_DIR}"
touch "${CLAUDE_MD}"
if ! grep -q 'skills/setup/SKILL\.md' "${CLAUDE_MD}"; then
  printf '%s\n' "${TRIGGER_BLOCK}" >> "${CLAUDE_MD}"
  echo "    Trigger appended to CLAUDE.md"
else
  echo "    Trigger already present in CLAUDE.md — skipped"
fi

# 6. Clean up
rm -rf "${TMP}"

# 7. Done
echo ""
echo "==> Install complete!"
echo ""
echo "Installed to : ${INSTALL_DIR}"
echo "CLAUDE.md    : ${CLAUDE_MD}"
echo ""
echo "Next steps:"
echo "  1. Open any project in Claude Code."
echo "  2. Type /setup to bootstrap the full AI-SDLC scaffold."
echo ""
echo "The generated commands run on the superpowers + ponytail plugins."
echo "The settings.json that /setup writes declares both, so Claude Code will"
echo "offer to install them on your next session in that repo. To have them"
echo "globally instead, run these in Claude Code:"
echo ""
echo "  /plugin marketplace add anthropics/claude-plugins-official"
echo "  /plugin install superpowers@claude-plugins-official"
echo "  /plugin marketplace add DietrichGebert/ponytail"
echo "  /plugin install ponytail@ponytail"
echo ""
echo "To uninstall:"
echo "  rm -rf '${INSTALL_DIR}'"
echo "  (also remove the '# setup' block from ${CLAUDE_MD})"
echo ""
