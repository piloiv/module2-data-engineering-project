# Project Startup Template

Use this checklist when starting a new data or analytics project.

## Recommended Folders

| Folder | What goes here |
| --- | --- |
| `docs/references/` | Assignment briefs, rubrics, source notes, stakeholder conversations, business context, and planning references |
| `docs/` | Final documentation, architecture notes, lineage notes, report outlines, and polished explanations |
| `data/raw/` | Original source files that should not be manually edited |
| `data/processed/` | Optional cleaned or intermediate data outputs |
| `data/warehouse/` | Local database or warehouse files, such as DuckDB files |
| `src/` | Python scripts and reusable project code |
| `sql/` | SQL schemas, transformations, quality checks, and analysis queries |
| `dbt/` | dbt project files, models, tests, macros, and profiles |
| `dashboard/` | Streamlit, Dash, or other dashboard app files |
| `notebooks/` | Exploratory analysis and notebook-based reporting |
| `slides/` | Presentation outlines, speaker notes, and final PowerPoint files |
| `tests/` | Automated tests for project structure, data logic, or code behavior |
| `config/` | Project configuration files |
| `outputs/` | Generated outputs that may be reviewed but are not source files |
| `logs/` | Runtime logs and troubleshooting output |

## Startup Steps

1. Create the folder structure.
2. Add `AGENTS.md` in the project root for project-specific agent instructions.
3. Put assignment and source-context files in `docs/references/`.
4. Add metric definitions and business assumptions to `README.md` or `docs/report_outline.md`.
5. Keep raw data unchanged in `data/raw/`.
6. Keep final presentation files in `slides/`.
7. Document any generated or local-only files in `.gitignore`.

## Placement Rules

- If it explains the assignment or context, put it in `docs/references/`.
- If it is a polished project explanation, put it in `docs/` or `README.md`.
- If it is a final deck or slide outline, put it in `slides/`.
- If it is executable logic, put it in `src/`, `sql/`, `dbt/`, or `dashboard/`.
- If it is raw source data, put it in `data/raw/` and do not edit it manually.
- If it is generated output, put it in `outputs/` unless it is a final deliverable.
