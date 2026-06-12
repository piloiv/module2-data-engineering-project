"""Run dbt commands for the local DuckDB warehouse."""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DBT_PROFILES_DIR = PROJECT_ROOT / "dbt"


def dbt_executable() -> str:
    script_dir = Path(sys.executable).resolve().parent
    candidates = [
        script_dir / "dbt.exe",
        script_dir / "dbt",
        shutil.which("dbt"),
    ]
    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return str(candidate)
    raise RuntimeError(
        "dbt is not installed in this environment. Install dependencies with "
        "`pip install -r requirements.txt` and rerun the pipeline."
    )


def run_dbt(args: list[str] | None = None) -> None:
    command = [dbt_executable(), *(args or ["build"])]
    env = os.environ.copy()
    env["DBT_PROFILES_DIR"] = str(DBT_PROFILES_DIR)
    env.setdefault("DBT_TARGET_PATH", str(PROJECT_ROOT / "dbt" / "target"))
    subprocess.run(command, cwd=PROJECT_ROOT, env=env, check=True)


if __name__ == "__main__":
    run_dbt(sys.argv[1:] or ["build"])
