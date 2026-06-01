"""
Run SQL-based data quality checks.
"""

from pathlib import Path

import duckdb


PROJECT_ROOT = Path(__file__).resolve().parents[2]
WAREHOUSE_PATH = PROJECT_ROOT / "data" / "warehouse" / "module2_project.duckdb"
CHECKS_DIR = PROJECT_ROOT / "sql" / "quality_checks"


def run_quality_checks() -> None:
    failures = []

    with duckdb.connect(str(WAREHOUSE_PATH)) as con:
        for check_file in sorted(CHECKS_DIR.glob("*.sql")):
            result = con.execute(check_file.read_text(encoding="utf-8")).fetchone()
            failed_rows = result[0] if result else 0
            status = "PASS" if failed_rows == 0 else "FAIL"
            print(f"{status}: {check_file.name} ({failed_rows} failing rows)")
            if failed_rows:
                failures.append(check_file.name)

    if failures:
        raise SystemExit(f"Data quality checks failed: {', '.join(failures)}")


if __name__ == "__main__":
    run_quality_checks()

