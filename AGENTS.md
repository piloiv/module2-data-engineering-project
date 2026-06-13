# Project Instructions

## PowerPoint Workflow Preference

For PowerPoint deck creation or substantial slide editing in this workspace, prefer `python-pptx` when it can produce stable, editable slides and avoid PowerPoint file-opening errors.

Use this approach especially when:
- creating a new deck from project data,
- rebuilding multiple slides,
- preserving consistent formatting,
- adding or updating speaker notes alongside slide content.

Use direct PPTX/XML edits only for narrow targeted changes, such as:
- updating speaker notes,
- editing metadata,
- making a small text-only correction when the deck structure should not change.

Before delivering a deck, verify that:
- the `.pptx` opens successfully in PowerPoint,
- formatting is preserved,
- speaker notes are present where expected,
- slide count and key metrics match the source materials.

## New Project Startup Convention

When starting a new data or analytics project, use a tidy default structure unless the user asks for something different:

- Put project-specific agent instructions in `AGENTS.md` at the project root.
- Put assignment briefs, rubrics, stakeholder notes, ChatGPT exports, and business/source context in `docs/references/`.
- Put final documentation in `docs/`.
- Put raw data in `data/raw/` and do not edit it manually.
- Put processed or intermediate data in `data/processed/`.
- Put local warehouse files in `data/warehouse/`.
- Put Python scripts and reusable project code in `src/`.
- Put SQL schemas, transformations, quality checks, and analysis queries in `sql/`.
- Put dbt project files, models, tests, macros, and profiles in `dbt/`.
- Put dashboards in `dashboard/`.
- Put exploratory notebooks in `notebooks/`.
- Put presentation outlines, speaker notes, and final decks in `slides/`.
- Put automated tests in `tests/`.
- Put generated review outputs in `outputs/`.
- Put runtime logs in `logs/`.

When creating a new project, also add `docs/project_startup_template.md` and `docs/references/references_folder_guide.md` unless the user asks for a different structure.
