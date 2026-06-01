"""
Run warehouse SQL transformations.
"""

from pathlib import Path

import duckdb


PROJECT_ROOT = Path(__file__).resolve().parents[2]
WAREHOUSE_PATH = PROJECT_ROOT / "data" / "warehouse" / "module2_project.duckdb"
SCHEMA_DIR = PROJECT_ROOT / "sql" / "schema"
SQL_DIR = PROJECT_ROOT / "sql" / "transforms"


def run_sql_file(con: duckdb.DuckDBPyConnection, path: Path) -> None:
    sql = path.read_text(encoding="utf-8")
    con.execute(sql)
    print(f"Ran {path.name}")


def run_transforms() -> None:
    with duckdb.connect(str(WAREHOUSE_PATH)) as con:
        con.execute("CREATE SCHEMA IF NOT EXISTS warehouse")
        for sql_file in sorted(SCHEMA_DIR.glob("*.sql")):
            run_sql_file(con, sql_file)
        for sql_file in sorted(SQL_DIR.glob("*.sql")):
            run_sql_file(con, sql_file)


if __name__ == "__main__":
    run_transforms()
