#!/usr/bin/env bash
set -euo pipefail

# omg installer — checks prerequisites, installs, builds, validates
# Usage: ./install.sh [--link]

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
LINK=false

for arg in "$@"; do
  case "$arg" in
    --link) LINK=true ;;
    --help|-h) echo "Usage: ./install.sh [--link]"; echo "  --link  Also link CLI globally"; exit 0 ;;
  esac
done

echo ""
echo "=== omg Installer ==="
echo ""
echo "Checking prerequisites"

# Node.js
if command -v node &>/dev/null; then
  echo "[OK]  Node.js $(node --version)"
else
  echo "[FAIL] Node.js not found. Install from https://nodejs.org/"
  exit 1
fi

# npm
if command -v npm &>/dev/null; then
  echo "[OK]  npm v$(npm --version)"
else
  echo "[FAIL] npm not found"
  exit 1
fi

# git
if command -v git &>/dev/null; then
  echo "[OK]  git v$(git --version | awk '{print $3}')"
else
  echo "[FAIL] git not found"
  exit 1
fi

# Copilot CLI (optional for build, required for plugin install)
COPILOT_AVAILABLE=false
if command -v copilot &>/dev/null; then
  echo "[OK]  Copilot CLI $(copilot --version 2>&1 | head -1)"
  COPILOT_AVAILABLE=true
else
  echo "[WARN] Copilot CLI not found — build will work, plugin install will be skipped"
fi

echo ""
echo "Installing dependencies"
cd "$REPO_ROOT"

# Try npm ci first (faster, reproducible), fall back to npm install (tolerates lock-file drift)
echo "[INFO] Running npm ci ..."
if npm ci --silent 2>/dev/null; then
  echo "[OK]  Dependencies installed (npm ci)"
else
  echo "[INFO] npm ci failed (lock-file drift). Running npm install ..."
  npm install --silent 2>&1
  echo "[OK]  Dependencies installed (npm install)"
fi

echo ""
echo "Building"
npm run build --silent 2>&1
echo "[OK]  Build complete ($(stat -c%s dist/cli.js 2>/dev/null || stat -f%z dist/cli.js 2>/dev/null || echo '?') bytes)"

echo ""
echo "Validating"
npm run typecheck --silent 2>&1
echo "[OK]  Typecheck passed"

npm run lint --silent 2>&1
echo "[OK]  Lint passed"

TEST_RESULT=$(npm test 2>&1 | grep "Tests" | tail -1)
echo "[OK]  $TEST_RESULT"

# Quality gate
if bash scripts/quality-gate.sh 2>&1 | grep -q "PASS"; then
  echo "[OK]  Quality gate passed"
else
  echo "[WARN] Quality gate had issues (non-blocking)"
fi

# Install plugin
if [ "$COPILOT_AVAILABLE" = true ]; then
  echo ""
  echo "Installing omg plugin"
  copilot plugin uninstall omg 2>/dev/null || true
  copilot plugin install "$REPO_ROOT/plugin" 2>&1 | head -1
  echo "[OK]  Plugin installed"
fi

# Optional: link CLI globally
if [ "$LINK" = true ]; then
  echo ""
  echo "Linking CLI globally"
  npm link 2>&1 | tail -1
  echo "[OK]  'omg' command available globally"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Quick start:"
echo "  copilot -i \"plan how to add feature X\""
echo "  copilot -i \"debug why tests fail\""
echo "  copilot -i \"autopilot: build a REST API\""
echo "  copilot -i \"team 3: fix all lint errors\""
echo ""
echo "Docs: plugin/README.md | plugin/ARCHITECTURE.md"
