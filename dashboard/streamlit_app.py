from pathlib import Path

import duckdb
import pandas as pd
import plotly.express as px
import streamlit as st


PROJECT_ROOT = Path(__file__).resolve().parents[1]
WAREHOUSE_PATH = PROJECT_ROOT / "data" / "warehouse" / "module2_project.duckdb"


st.set_page_config(
    page_title="Olist Seller Enablement Dashboard",
    layout="wide",
)


@st.cache_data(show_spinner=False)
def query(sql: str) -> pd.DataFrame:
    with duckdb.connect(str(WAREHOUSE_PATH), read_only=True) as con:
        return con.execute(sql).df()


def money(value: float) -> str:
    return f"${value:,.0f}"


def pct(value: float) -> str:
    return f"{value * 100:,.1f}%"


def require_warehouse() -> None:
    if not WAREHOUSE_PATH.exists():
        st.error("The warehouse has not been built yet. Run the pipeline before opening the dashboard.")
        st.stop()


require_warehouse()

try:
    overview = query("SELECT * FROM warehouse.mart_platform_overview")
    monthly = query("SELECT * FROM warehouse.mart_monthly_platform_health ORDER BY month_start")
    sellers = query("SELECT * FROM warehouse.mart_seller_health")
    concentration = query("SELECT * FROM warehouse.mart_seller_concentration ORDER BY seller_rank")
    categories = query("SELECT * FROM warehouse.mart_category_opportunity")
    regions = query("SELECT * FROM warehouse.mart_regional_fulfillment")
except Exception as exc:
    st.error("Dashboard marts are not available yet. Run `python src/run_pipeline.py` after installing dbt.")
    st.exception(exc)
    st.stop()


row = overview.iloc[0]
latest_month = monthly["month_start"].max()
completed_monthly = monthly[monthly["month_start"] < latest_month].copy()

st.title("Olist Seller Enablement Dashboard")
st.caption(
    "Olist is framed as a commerce enablement platform: transaction activity is interpreted as seller-success and Product GMV signals, not confirmed Olist revenue."
)

st.info(
    "Business case: after rapid early growth, monthly Product GMV appears to plateau through much of 2018. "
    "The dashboard focuses on the levers management can act on: seller productivity, category opportunity, regional demand, and fulfillment reliability.",
)

summary_cols = st.columns(6)
summary_cols[0].metric("Product GMV", money(row["product_gmv"]))
summary_cols[1].metric("Active sellers", f"{row['active_sellers']:,.0f}")
summary_cols[2].metric("Orders", f"{row['orders']:,.0f}")
summary_cols[3].metric("GMV / seller", money(row["product_gmv_per_seller"]))
summary_cols[4].metric("Avg review", f"{row['avg_review_score']:.2f}")
summary_cols[5].metric("Late delivery", pct(row["late_delivery_rate"]))

tab_growth, tab_sellers, tab_categories, tab_regions = st.tabs(
    ["Growth plateau", "Seller health", "Category levers", "Fulfillment friction"]
)

with tab_growth:
    st.caption(f"Growth charts exclude the latest partial month: {latest_month:%B %Y}. Product GMV is item price only; use the trend to diagnose where growth slowed, not as Olist revenue.")
    left, right = st.columns([2, 1])
    with left:
        st.plotly_chart(
            px.line(
                completed_monthly,
                x="month_start",
                y="product_gmv",
                markers=True,
                title="Monthly product GMV",
                labels={"month_start": "Month", "product_gmv": "Product GMV"},
            ),
            use_container_width=True,
        )
    with right:
        st.plotly_chart(
            px.line(
                completed_monthly,
                x="month_start",
                y="active_sellers",
                markers=True,
                title="Active sellers",
                labels={"month_start": "Month", "active_sellers": "Sellers"},
            ),
            use_container_width=True,
        )
    st.dataframe(
        completed_monthly[
            [
                "month_start",
                "orders",
                "active_sellers",
                "product_gmv",
                "product_gmv_per_seller",
                "avg_review_score",
                "late_delivery_rate",
            ]
        ],
        use_container_width=True,
        hide_index=True,
    )

with tab_sellers:
    segment_counts = (
        sellers.groupby("seller_action_segment", as_index=False)
        .agg(sellers=("seller_key", "count"), product_gmv=("product_gmv", "sum"))
        .sort_values("product_gmv", ascending=False)
    )
    left, right = st.columns([1, 2])
    with left:
        st.plotly_chart(
            px.bar(
                segment_counts,
                x="seller_action_segment",
                y="sellers",
                title="Seller action segments",
                labels={"seller_action_segment": "Segment", "sellers": "Sellers"},
            ),
            use_container_width=True,
        )
    with right:
        concentration_points = concentration[concentration["seller_rank"].isin([10, 100, 500])]
        st.plotly_chart(
            px.line(
                concentration.head(500),
                x="seller_rank",
                y="cumulative_product_gmv_share",
                title="Seller concentration curve",
                labels={"seller_rank": "Seller rank", "cumulative_product_gmv_share": "Cumulative GMV share"},
            ),
            use_container_width=True,
        )
        st.dataframe(
            concentration_points[
                ["seller_rank", "product_gmv", "cumulative_product_gmv_share"]
            ],
            use_container_width=True,
            hide_index=True,
        )
    st.subheader("Top sellers")
    st.dataframe(
        sellers.sort_values("product_gmv", ascending=False)[
            [
                "seller_id",
                "seller_state",
                "seller_action_segment",
                "orders",
                "product_gmv",
                "avg_review_score",
                "avg_delivery_days",
                "late_delivery_rate",
                "active_months",
            ]
        ].head(50),
        use_container_width=True,
        hide_index=True,
    )

with tab_categories:
    category_view = categories.sort_values("product_gmv", ascending=False).head(20)
    category_chart = category_view.sort_values("product_gmv", ascending=True)
    st.plotly_chart(
        px.bar(
            category_chart,
            x="product_gmv",
            y="product_category",
            orientation="h",
            title="Top product categories by GMV",
            labels={"product_gmv": "Product GMV", "product_category": "Category"},
        ),
        use_container_width=True,
    )
    st.dataframe(
        categories.sort_values("product_gmv_per_seller", ascending=False)[
            [
                "product_category",
                "orders",
                "active_sellers",
                "product_gmv",
                "product_gmv_per_seller",
                "avg_review_score",
                "late_delivery_rate",
            ]
        ],
        use_container_width=True,
        hide_index=True,
    )

with tab_regions:
    state_view = (
        regions.groupby("customer_state", as_index=False)
        .agg(
            orders=("orders", "sum"),
            product_gmv=("product_gmv", "sum"),
            avg_delivery_days=("avg_delivery_days", "mean"),
            late_delivery_rate=("late_delivery_rate", "mean"),
        )
        .sort_values("product_gmv", ascending=False)
    )
    left, right = st.columns(2)
    with left:
        st.plotly_chart(
            px.bar(
                state_view.head(15),
                x="customer_state",
                y="product_gmv",
                title="Customer demand by state",
                labels={"customer_state": "Customer state", "product_gmv": "Product GMV"},
            ),
            use_container_width=True,
        )
    with right:
        st.plotly_chart(
            px.scatter(
                state_view,
                x="avg_delivery_days",
                y="late_delivery_rate",
                size="orders",
                hover_name="customer_state",
                title="Fulfillment friction by customer state",
                labels={"avg_delivery_days": "Avg delivery days", "late_delivery_rate": "Late delivery rate"},
            ),
            use_container_width=True,
        )
    st.dataframe(state_view, use_container_width=True, hide_index=True)
