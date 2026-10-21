# MLLM-Street-Perception

Research code for a master's thesis on urban safety perception with Multimodal LLMs. The model (Qwen3-VL) compares pairs of street-level images and judges which place looks safer, conditioned on demographic and Big Five personality personas from the SPECS dataset.

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
4. Place the dataset under `data/SPECS/` (gitignored).

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
