#!/usr/bin/env bash
# Scaffold a throwaway nx-style uv monorepo for testing Python LSP behaviour.
#
# Mirrors the work project layout: apps/* and libs/* are each their own
# standalone uv project. Apps depend on libs through [tool.uv.sources] path
# entries installed as editable, which means `uv sync` must be re-run in the
# app whenever a lib's metadata changes.
#
# This exercises cross-package go-to-definition: `gd` on a symbol imported
# from a lib must land in the lib's real source tree, not in site-packages.
#
# Usage: ./scripts/make-python-monorepo-fixture.sh [target-dir]
#        (default target: /tmp/nx-uv-fixture)

set -euo pipefail

ROOT="${1:-/tmp/nx-uv-fixture}"

if ! command -v uv >/dev/null 2>&1; then
  echo "error: uv is not installed or not on PATH" >&2
  exit 1
fi

# Idempotent: always rebuild from scratch so a stale .venv can't mask a fix.
rm -rf "$ROOT"
mkdir -p "$ROOT/libs/shared-models/src/shared_models" \
         "$ROOT/libs/shared-utils/src/shared_utils" \
         "$ROOT/apps/api/src/api" \
         "$ROOT/apps/api/tests"

# --- second lib, depended on by the first ------------------------------------
# Exercises lib -> lib navigation. Libs are standalone projects that often have
# no .venv of their own, which is a different code path from app -> lib.
cat >"$ROOT/libs/shared-utils/pyproject.toml" <<'EOF'
[project]
name = "shared-utils"
version = "0.1.0"
requires-python = ">=3.9"
dependencies = []

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/shared_utils"]
EOF

cat >"$ROOT/libs/shared-utils/src/shared_utils/__init__.py" <<'EOF'
EOF

cat >"$ROOT/libs/shared-utils/src/shared_utils/helpers.py" <<'EOF'
"""Helpers shared across libs."""


class Helper:
    """Defined in shared-utils, imported by shared-models."""

    def assist(self) -> str:
        return "shared_utils.Helper"
EOF


# --- shared lib: a standalone uv project -------------------------------------
# src-layout, which is the branch `before_init` guesses at when it appends
# "/src" to the direct_url.json path. A flat-layout lib is the other case
# worth testing; add one here if the src-layout case passes but work doesn't.
cat >"$ROOT/libs/shared-models/pyproject.toml" <<'EOF'
[project]
name = "shared-models"
version = "0.1.0"
requires-python = ">=3.9"
dependencies = ["shared-utils"]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/shared_models"]

[tool.uv.sources]
shared-utils = { path = "../shared-utils", editable = true }
EOF

cat >"$ROOT/libs/shared-models/src/shared_models/models.py" <<'EOF'
"""Models shared across apps."""

# lib -> lib navigation: gd on `Helper` here. This file's nearest root marker
# is libs/shared-models, which has no .venv of its own.
from shared_utils.helpers import Helper


class Widget:
    """A widget defined in the shared library.

    `gd` from an app should land on this class, in this file.
    """

    def __init__(self, name: str) -> None:
        self.name = name

    def whoami(self) -> str:
        """Marker method — this name exists nowhere else in the fixture."""
        return f"shared_models.Widget({self.name}) {Helper().assist()}"


class Gadget:
    """A second class, used to test resolution after a lib edit."""

    def identify(self) -> str:
        return "shared_models.Gadget"
EOF

cat >"$ROOT/libs/shared-models/src/shared_models/__init__.py" <<'EOF'
from shared_models.models import Gadget, Widget

__all__ = ["Gadget", "Widget"]
EOF

# --- app: its own uv project, depends on the lib via a path source -----------
cat >"$ROOT/apps/api/pyproject.toml" <<'EOF'
[project]
name = "api"
version = "0.1.0"
requires-python = ">=3.9"
dependencies = ["shared-models"]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/api"]

[tool.uv.sources]
shared-models = { path = "../../libs/shared-models", editable = true }
EOF

cat >"$ROOT/apps/api/src/api/__init__.py" <<'EOF'
EOF

# Direct submodule import — the primary `gd` target.
cat >"$ROOT/apps/api/src/api/main.py" <<'EOF'
from shared_models.models import Widget


def run() -> str:
    # Put the cursor on `Widget` (either line) and press gd.
    # Expected: libs/shared-models/src/shared_models/models.py, `class Widget`.
    widget = Widget("demo")
    return widget.whoami()
EOF

# Re-export import — resolves through the lib's __init__.py instead.
cat >"$ROOT/apps/api/src/api/flat_import.py" <<'EOF'
from shared_models import Widget


def build() -> Widget:
    # gd here must follow the re-export in shared_models/__init__.py
    # through to models.py.
    return Widget("via-reexport")
EOF

# A test file outside src/ — same root, but a directory pyright doesn't
# implicitly treat as a source root.
cat >"$ROOT/apps/api/tests/test_main.py" <<'EOF'
from api.main import run
from shared_models.models import Widget


def test_run() -> None:
    # gd on Widget and on run() should both resolve from a tests/ file.
    assert Widget("t").whoami() in run()
EOF

# `.git` is the last-resort root marker; having one above the apps confirms
# basedpyright still anchors at apps/api (nearest pyproject.toml/uv.lock)
# rather than climbing to the monorepo root.
git init -q "$ROOT"

echo "==> uv sync in apps/api"
(cd "$ROOT/apps/api" && uv sync)

# Libs are deliberately left un-synced (no .venv of their own). That is the
# common state in a monorepo where only apps get synced, and it is the case
# where lib -> lib navigation has nothing to anchor on. Set SYNC_LIBS=1 to
# give each lib its own venv and compare.
if [ "${SYNC_LIBS:-0}" = "1" ]; then
  echo "==> uv sync in libs/* (SYNC_LIBS=1)"
  (cd "$ROOT/libs/shared-models" && uv sync)
  (cd "$ROOT/libs/shared-utils" && uv sync)
fi

echo
echo "==> editable install metadata basedpyright has to parse:"
found_any=0
for du in "$ROOT"/apps/api/.venv/lib/python*/site-packages/*.dist-info/direct_url.json; do
  [ -e "$du" ] || continue
  if grep -q '"editable"[[:space:]]*:[[:space:]]*true' "$du"; then
    found_any=1
    echo "--- $du"
    cat "$du"
    echo
  fi
done
if [ "$found_any" -eq 0 ]; then
  echo "WARNING: no editable direct_url.json found — the extraPaths scan in" >&2
  echo "         lspconfig.lua will find nothing. Investigate before testing." >&2
fi

cat <<EOF

==> Fixture ready at $ROOT

Test with:

  nvim $ROOT/apps/api/src/api/main.py

Then, inside nvim:

  " Ground truth — what the server actually received:
  :lua =vim.lsp.get_clients({ name = "basedpyright" })[1].config.root_dir
  :lua =vim.lsp.get_clients({ name = "basedpyright" })[1].settings

  " Expect settings.python.pythonPath  = $ROOT/apps/api/.venv/bin/python
  " Expect analysis.extraPaths to include $ROOT/libs/shared-models/src

  " The actual test: cursor on Widget, then
  gd   " -> libs/shared-models/src/shared_models/models.py, class Widget
  K    " -> hover shows the docstring
  gr   " -> references across both packages

  :lua vim.diagnostic.setqflist()   " no reportMissingImports for shared_models

Also try $ROOT/apps/api/src/api/flat_import.py for the re-export path.
EOF
