"""Dagster assets for the Olist analytics pipeline."""

from pathlib import Path

from dagster import AssetExecutionContext, Definitions, ScheduleDefinition, asset

from dbt_runner import run_dbt
from ingestion.load_raw_data import load_csv_files
from quality.run_quality_checks import run_quality_checks


PROJECT_ROOT = Path(__file__).resolve().parents[2]
WAREHOUSE_PATH = PROJECT_ROOT / "data" / "warehouse" / "module2_project.duckdb"


@asset(description="Load raw Olist CSV files from data/raw into DuckDB raw tables.")
def raw_olist_tables(context: AssetExecutionContext) -> str:
    load_csv_files()
    context.log.info("Raw CSV files loaded into DuckDB.")
    return str(WAREHOUSE_PATH)


@asset(
    deps=[raw_olist_tables],
    description="Build dbt warehouse models, marts, and dbt tests.",
)
def dbt_warehouse_models(context: AssetExecutionContext) -> str:
    run_dbt(["build"])
    context.log.info("dbt build completed.")
    return str(WAREHOUSE_PATH)


@asset(
    deps=[dbt_warehouse_models],
    description="Run legacy SQL quality checks used by the original project.",
)
def warehouse_quality_checks(context: AssetExecutionContext) -> str:
    run_quality_checks()
    context.log.info("SQL quality checks completed.")
    return "passed"


@asset(
    deps=[warehouse_quality_checks],
    description="Confirm the Streamlit dashboard has updated DuckDB marts to read.",
)
def dashboard_ready(context: AssetExecutionContext) -> str:
    if not WAREHOUSE_PATH.exists():
        raise FileNotFoundError(f"Warehouse not found: {WAREHOUSE_PATH}")
    context.log.info("Dashboard can read the refreshed warehouse.")
    return str(WAREHOUSE_PATH)


daily_pipeline_schedule = ScheduleDefinition(
    name="daily_olist_pipeline",
    cron_schedule="0 8 * * *",
    target=[raw_olist_tables, dbt_warehouse_models, warehouse_quality_checks, dashboard_ready],
)


defs = Definitions(
    assets=[raw_olist_tables, dbt_warehouse_models, warehouse_quality_checks, dashboard_ready],
    schedules=[daily_pipeline_schedule],
)
