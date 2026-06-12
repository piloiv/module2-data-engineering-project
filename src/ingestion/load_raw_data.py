"""Load raw Olist CSV files into DuckDB raw tables."""

from pathlib import Path

import duckdb


PROJECT_ROOT = Path(__file__).resolve().parents[2]
RAW_DIR = PROJECT_ROOT / "data" / "raw"
WAREHOUSE_PATH = PROJECT_ROOT / "data" / "warehouse" / "module2_project.duckdb"
EXPECTED_OLIST_FILES = {
    "olist_customers_dataset.csv",
    "olist_geolocation_dataset.csv",
    "olist_order_items_dataset.csv",
    "olist_order_payments_dataset.csv",
    "olist_order_reviews_dataset.csv",
    "olist_orders_dataset.csv",
    "olist_products_dataset.csv",
    "olist_sellers_dataset.csv",
    "product_category_name_translation.csv",
}


def table_name_from_file(path: Path) -> str:
    return "raw_" + path.stem.lower().replace("olist_", "").replace("_dataset", "")


def load_csv_files() -> None:
    WAREHOUSE_PATH.parent.mkdir(parents=True, exist_ok=True)
    csv_files = sorted(RAW_DIR.glob("*.csv"))

    if not csv_files:
        raise FileNotFoundError(f"No CSV files found in {RAW_DIR}")

    present = {csv_file.name for csv_file in csv_files}
    missing = sorted(EXPECTED_OLIST_FILES - present)
    if missing:
        print("Warning: expected Olist files not found: " + ", ".join(missing), flush=True)

    with duckdb.connect(str(WAREHOUSE_PATH)) as con:
        con.execute("CREATE SCHEMA IF NOT EXISTS raw")

        for csv_file in csv_files:
            table_name = table_name_from_file(csv_file)
            con.execute(
                f"""
                CREATE OR REPLACE TABLE raw.{table_name} AS
                SELECT *
                FROM read_csv_auto(?, header = true, ignore_errors = false)
                """,
                [str(csv_file)],
            )
            row_count = con.execute(f"SELECT COUNT(*) FROM raw.{table_name}").fetchone()[0]
            print(f"Loaded {csv_file.name} into raw.{table_name} ({row_count:,} rows)", flush=True)


if __name__ == "__main__":
    load_csv_files()
