from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def test_required_directories_exist():
    required = [
        "data/raw",
        "data/processed",
        "data/warehouse",
        "src/ingestion",
        "src/transformations",
        "src/quality",
        "sql/schema",
        "sql/transforms",
        "sql/quality_checks",
        "notebooks",
        "docs/diagrams",
        "slides",
    ]

    for directory in required:
        assert (ROOT / directory).is_dir()


def test_core_project_artifacts_exist():
    required_files = [
        "src/run_pipeline.py",
        "src/ingestion/load_raw_data.py",
        "src/transformations/run_transforms.py",
        "src/quality/run_quality_checks.py",
        "sql/schema/warehouse_schema.sql",
        "notebooks/olist_warehouse_analysis.ipynb",
        "docs/architecture.md",
        "docs/data_lineage.md",
        "docs/schema_design.md",
        "slides/executive_deck_outline.md",
    ]

    for file_path in required_files:
        assert (ROOT / file_path).is_file()


def test_quality_checks_cover_assignment_categories():
    check_text = "\n".join(
        path.read_text(encoding="utf-8").lower()
        for path in (ROOT / "sql" / "quality_checks").glob("*.sql")
    )

    assert "is null" in check_text
    assert "having count(*) > 1" in check_text
    assert "left join warehouse.dim_customer" in check_text
    assert "left join warehouse.dim_product" in check_text
    assert "total_sale_amount < 0" in check_text
    assert "review_score" in check_text
