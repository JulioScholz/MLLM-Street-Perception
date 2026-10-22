#!/usr/bin/env bash
# Run notebooks/3_personas_baseline.ipynb headlessly from a terminal (e.g. inside tmux).
#
# Usage:
#   bash scripts/run_notebook3.sh
#
# Notebook 3 has no IPython magics, so it is converted to a script at run time and
# executed with the uv environment. This keeps live output (tqdm, prints, errors)
# in the terminal; running it via `jupyter nbconvert --execute` would capture the
# outputs inside the notebook instead.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
NOTEBOOK="$REPO_ROOT/notebooks/3_personas_baseline.ipynb"

RUN_DIR="$REPO_ROOT/outputs/inferences/notebook_runs"
TS="$(date +%Y-%m-%d_%H-%M)"
PYFILE="$RUN_DIR/3_personas_baseline_${TS}.py"
LOGFILE="$RUN_DIR/3_personas_baseline_${TS}.log"

mkdir -p "$RUN_DIR"
export PYTHONUNBUFFERED=1

echo "[$(date '+%F %T')] syncing uv environment"
cd "$REPO_ROOT"
uv sync --locked

echo "[$(date '+%F %T')] converting notebook -> script"
uv run --with nbconvert jupyter nbconvert \
    --to script "$NOTEBOOK" \
    --output-dir "$RUN_DIR" \
    --output "3_personas_baseline_${TS}"

echo "[$(date '+%F %T')] running $PYFILE"
echo "[$(date '+%F %T')] log: $LOGFILE"
# Run from notebooks/ so the notebook's `sys.path.insert(0, "..")` resolves to the repo root.
cd "$REPO_ROOT/notebooks"
uv run --project "$REPO_ROOT" python "$PYFILE" 2>&1 | tee "$LOGFILE"
