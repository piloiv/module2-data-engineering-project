# Executive Deck Outline

Final deck: `slides/olist-seller-enablement-final-story-deck.pptx`

## Thesis

The project now lands as both a technical build and a business operating story. The warehouse, dbt marts, Streamlit dashboard, and Dagster-ready orchestration translate public Olist marketplace activity into seller-growth decisions.

## Slide Claim Spine

1. **Olist Seller Enablement**  
   A modern data stack turns marketplace activity into seller-growth decisions.

2. **Business Case**  
   The right decision basis is seller success, not direct retail sales.

3. **Business Model**  
   Olist monetizes seller enablement; the dataset captures early marketplace scale formation.

4. **Modernized Pipeline**  
   Raw files now flow through dbt, quality checks, orchestration, and dashboarding.

5. **Warehouse Model**  
   The model separates item-level sales from order-level payments and exposes decision marts.

6. **Growth Readout**  
   Growth reads correctly after excluding the partial final month.

7. **Seller Health**  
   Seller health turns transaction data into four account-management actions: protect, grow, fix experience, and activate.

8. **Concentration Risk**  
   A small seller group drives a large share of marketplace activity.

9. **Category Opportunity**  
   Large categories define where seller enablement can most directly move GMV.

10. **Fulfillment Friction**  
   Slow-delivery states turn logistics into seller-review and retention risk.

11. **Operating Model**  
    The dashboard turns the warehouse into a recurring seller review system.

12. **Roadmap**  
    The next phase should connect seller activity to economics and action ownership.

13. **Close**  
    Decision makers get seller actions. Data specialists can trace the build through raw load, dbt models, tests, Dagster assets, and dashboard marts.

## Core Messages

- Product GMV is marketplace activity, not confirmed Olist revenue.
- The dataset covers roughly September 2016 to September 2018, an early observed two-year window where the platform reached meaningful GMV volume.
- Payment value belongs at order grain, not item grain.
- Seller health is the business bridge between raw orders and management action.
- The final month is excluded from trend charts because it is incomplete.
- The next decision layer should add internal economics: take rate, SaaS revenue, logistics margin, CAC, LTV, and profitability.
