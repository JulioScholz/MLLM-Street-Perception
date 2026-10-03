"""Central configuration: paths, model IDs, hyperparameters."""

from pathlib import Path

# ── Paths ─────────────────────────────────────────────────────────────────────
PROJECT_ROOT = Path(__file__).parent.parent
OUTPUTS = PROJECT_ROOT / "outputs"

print(PROJECT_ROOT)
