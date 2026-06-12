"""Run the local Olist warehouse pipeline end to end."""

from dbt_runner import run_dbt
from ingestion.load_raw_data import load_csv_files
from quality.run_quality_checks import run_quality_checks


def main() -> None:
    load_csv_files()
    run_dbt(["build"])
    run_quality_checks()


if __name__ == "__main__":
    main()
