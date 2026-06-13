# Executive Deck Outline

Final deck: `slides/olist-seller-enablement-final-story-deck.pptx`

## Thesis

The project now lands as both a technical build and a business operating story. The warehouse, dbt marts, Streamlit dashboard, and Dagster-ready orchestration translate public Olist transaction activity into seller-growth decisions.

The revised storyline opens with a management problem: Olist's first observed years show rapid early growth followed by a second-year plateau in monthly Product GMV. Because Olist is a commerce enablement platform rather than an owned consumer marketplace, the right response is to identify seller, category, regional, and fulfillment levers that can restart growth.

## Slide Claim Spine

1. **Olist Seller Enablement**  
   A modern data stack turns marketplace-channel activity into seller-growth decisions.

2. **Business Case**  
   Rapid early growth has leveled off; management needs to know which levers can reignite growth.

3. **Business Model**  
   Olist enables sellers across marketplaces; the dataset captures transaction signals from that ecosystem, not an owned consumer marketplace.

4. **Modernized Pipeline**  
   Raw files now flow through dbt, quality checks, orchestration, and dashboarding.

5. **Warehouse Model**  
   The model separates item-level sales from order-level payments and exposes decision marts.

6. **Growth Readout**  
   Monthly Product GMV rises fast, then stays near a plateau band through much of 2018.

7. **Seller Health**  
   Seller health turns transaction data into four account-management actions: protect, grow, fix experience, and activate.

8. **Concentration Risk**  
   A small seller group drives a large share of marketplace activity.

9. **Category Opportunity**  
   Large categories define where seller enablement can most directly lift seller productivity.

10. **Fulfillment Friction**  
   Slow-delivery states turn logistics into seller-review and retention risk.

11. **Operating Model**  
    The dashboard turns the warehouse into a recurring seller review system.

12. **Roadmap**  
    The next phase should connect seller activity to economics and action ownership.

13. **Close**  
    The action plan targets seller productivity, seller retention, fulfillment reliability, and expansion economics.

    The closing KPI rail summarizes 13 growth levers: protect high-Product GMV sellers; grow healthy mid-tail sellers; fix experience-risk sellers; activate one-month or underdeveloped sellers; reduce concentration dependency by expanding the healthy mid-tail; prioritize proven-demand categories; deepen assortment in large categories; improve stock readiness; monitor category fulfillment risk; follow up reviews in priority categories; fix weak carrier corridors; improve seller location mix or regional coverage; and improve estimated delivery-date accuracy.

## Core Messages

- Olist is a commerce enablement platform, not primarily an owned consumer marketplace.
- Product GMV is item price only: marketplace-channel product activity, not confirmed Olist revenue.
- GTV is item price plus freight, and payment value stays at order grain.
- The dataset covers September 4, 2016 to September 3, 2018; the management storyline focuses on October 2016 through September 2018 and treats boundary months as partial-period artifacts.
- Year 2 has much higher total volume than Year 1, but monthly Product GMV shows a plateau pattern through much of 2018.
- Payment value belongs at order grain, not item grain.
- Seller health is the business bridge between raw orders and management action.
- The technical confidence metric is 38 dbt build outcomes plus 15 SQL checks. The 38 dbt outcomes are 12 model builds and 26 dbt tests; the SQL suite contains 15 checks in `sql/quality_checks`.
- The final month is excluded from trend charts because it is incomplete.
- The next decision layer should add internal economics: take rate, SaaS revenue, logistics margin, seller CAC, seller LTV, and profitability.
