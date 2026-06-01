"""Run the local Olist warehouse pipeline end to end."""

from ingestion.load_raw_data import load_csv_files
from quality.run_quality_checks import run_quality_checks
from transformations.run_transforms import run_transforms


def main() -> None:
    load_csv_files()
    run_transforms()
    run_quality_checks()


if __name__ == "__main__":
    main()
