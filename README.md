# MLLM-Street-Perception

Research code for a master's thesis on urban safety perception with Multimodal LLMs. The model (Qwen3-VL) compares pairs of street-level images and judges which place looks safer, conditioned on demographic and Big Five personality personas from the SPECS dataset.

## Experiments so far

- **Data**: prepared `data/specs_data_safe.csv` from SPECS (5000 safety comparisons, 400 images), merging human pairwise choices with image metadata/paths; remapped education and race/ethnicity.
- **Prompt variants**: `answer_first`, `answer_last`, `answer_no_reasoning`, `answer_first_last`; persona vs. no-persona baseline.
- **Order control**: normal and inverted image order, with model choices mapped back to dataset identity.
- **Image size**: native size vs. downscaled input; size recorded in output filenames.
- **Models**: Qwen3-VL-2B (local testing), 8B, and 30B-A3B-AWQ (4-bit) via vLLM on the RTX 3090.
- **Backends**: vLLM 0.32 on Linux; Hugging Face fallback on Windows/local.
- **Runs**: 8B persona/normal for all four prompt variants; 30B-A3B-AWQ `answer_last` over the 5000 comparisons (in progress, with batching/resume).
- **Inference robustness**: per-row error handling, raw-response saving, JSON repair (including unescaped quotes), resumable append-only CSV output, batched vLLM inference with KV-cache monitoring.
- **Evaluation** (`notebooks/4_infereces_evaluation.ipynb`): human/model choice distributions, human-vs-model accuracy and F1, error breakdown, left/right accuracy excluding human `equal`, and initial-vs-final answer change rate for `answer_first_last`.
- **Human analysis** (`notebooks/5_analysis.ipynb`): TrueSkill-style (`openskill`) human safety ranking; safest/least-safe images with strong human agreement.
- **Infrastructure**: uv-pinned dependencies (`uv.lock`), headless runner (`scripts/run_notebook3.sh`), CUDA 13 driver on the server.

## Setup (uv)

1. Install uv:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
2. Install dependencies (creates `.venv` with Python 3.13 from `uv.lock`):
   ```bash
   uv sync --locked
   ```
3. Add your Hugging Face token to `.env`:
   ```bash
   echo "HF_TOKEN=hf_..." > .env
   ```
4. Download the dataset (`labels/` and `svi/` only) into `data/SPECS/`:
   ```bash
   uv run hf download matiasqr/specs --repo-type dataset \
     --include "labels/*" --include "svi/*" \
     --local-dir data/SPECS
   ```

## Run

```bash
uv run python scripts/1_data_preparation.py
```

Then open the notebooks in `notebooks/` in order, using the `.venv` interpreter/kernel (VS Code: **Python: Select Interpreter**), or start Jupyter with `uv run jupyter lab`.

Results are written to `outputs/inferences/` (gitignored).

## Dependencies

Declared in `pyproject.toml` and pinned in `uv.lock`. To add or remove a package:

```bash
uv add <package>
uv remove <package>
```
