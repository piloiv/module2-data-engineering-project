# First-Pass Olist Results

Generated after loading the Olist raw CSVs into DuckDB, building the warehouse star schema, and running SQL quality checks.

## Pipeline Status

- Raw source files loaded: 9
- Warehouse fact table grain: one row per order item
- Quality checks passed: 15 of 15
- DuckDB warehouse: `data/warehouse/module2_project.duckdb`

## Warehouse Row Counts

| Table | Rows |
|---|---:|
| `warehouse.fact_sales` | 112,650 |
| `warehouse.dim_customer` | 99,441 |
| `warehouse.dim_product` | 32,951 |
| `warehouse.dim_seller` | 3,095 |
| `warehouse.dim_date` | 711 |

## Headline Metrics

| Metric | Value |
|---|---:|
| Orders with order items | 98,666 |
| Order items | 112,650 |
| Active sellers | 3,095 |
| Product GMV | 13,591,643.70 |
| Freight value | 2,251,909.54 |
| Gross transaction value | 15,843,553.24 |
| Product GMV per seller | 4,391.48 |
| Orders per seller | 31.88 |
| Average review score | 4.03 |
| Average delivery days | 12.41 |
| Average days delivered before estimate | 12.03 |

These values describe marketplace activity visible in the public dataset. Product GMV and gross transaction value should not be presented as Olist revenue because Olist's take rate, SaaS fees, logistics margin, financial services revenue, and operating costs are not included.

## Order Status

| Status | Orders |
|---|---:|
| delivered | 96,478 |
| shipped | 1,106 |
| canceled | 461 |
| invoiced | 312 |
| processing | 301 |
| unavailable | 6 |
| approved | 2 |

## Top Product Categories by Gross Transaction Value

| Category | Orders | Items | Gross Transaction Value | Avg Review |
|---|---:|---:|---:|---:|
| health_beauty | 8,836 | 9,670 | 1,441,248.07 | 4.14 |
| watches_gifts | 5,624 | 5,991 | 1,305,541.61 | 4.02 |
| bed_bath_table | 9,417 | 11,115 | 1,241,681.72 | 3.90 |
| sports_leisure | 7,720 | 8,641 | 1,156,656.48 | 4.11 |
| computers_accessories | 6,689 | 7,827 | 1,059,272.40 | 3.93 |
| furniture_decor | 6,449 | 8,334 | 902,511.79 | 3.91 |
| housewares | 5,884 | 6,964 | 778,397.77 | 4.05 |
| cool_stuff | 3,632 | 3,796 | 719,329.95 | 4.15 |
| auto | 3,897 | 4,235 | 685,384.32 | 4.06 |
| garden_tools | 3,518 | 4,347 | 584,219.21 | 4.05 |

## Top Customer States by Gross Transaction Value

| State | Orders | Gross Transaction Value | Avg Delivery Days |
|---|---:|---:|---:|
| SP | 41,375 | 5,921,678.12 | 8.66 |
| RJ | 12,762 | 2,129,681.98 | 15.07 |
| MG | 11,544 | 1,856,161.49 | 11.92 |
| RS | 5,432 | 885,826.76 | 15.13 |
| PR | 4,998 | 800,935.44 | 11.89 |
| BA | 3,358 | 611,506.67 | 19.19 |
| SC | 3,612 | 610,213.60 | 14.95 |
| DF | 2,125 | 353,229.44 | 12.89 |
| GO | 2,007 | 347,706.93 | 15.34 |
| ES | 2,025 | 324,801.91 | 15.59 |

## Payment Mix

| Payment Type | Orders | Payment Value |
|---|---:|---:|
| credit_card | 76,505 | 12,542,084.19 |
| boleto | 19,784 | 2,869,361.27 |
| voucher | 3,866 | 379,436.87 |
| debit_card | 1,528 | 217,989.79 |
| not_defined | 3 | 0.00 |

## Seller-Centric Strategic View

Olist's primary clients are sellers, not end consumers. Buyer orders, reviews, payments, and delivery records are therefore best used as evidence of seller success and platform health.

### Seller Concentration

| Seller Group | Share of Product GMV |
|---|---:|
| Top 10 sellers | 13.15% |
| Top 100 sellers | 45.06% |
| Top 500 sellers | 78.20% |

### Top Sellers by Product GMV

| Seller ID | State | Orders | Items | Product GMV | Gross Transaction Value | Avg Review | Avg Delivery Days |
|---|---|---:|---:|---:|---:|---:|---:|
| 4869f7a5dfa277a7dca6462dcf3b52b2 | SP | 1,132 | 1,156 | 229,472.63 | 249,640.70 | 4.12 | 14.94 |
| 53243585a1d6dc2643021fd1853d8905 | BA | 358 | 410 | 222,776.05 | 235,856.68 | 4.08 | 13.29 |
| 4a3ca9315b744ce9f8e9374361493884 | SP | 1,806 | 1,987 | 200,472.92 | 235,539.96 | 3.80 | 14.37 |
| fa1c13f2614d7b5c4749cbc52fecda94 | SP | 585 | 586 | 194,042.03 | 204,084.73 | 4.34 | 13.30 |
| 7c67e1448b00f6e969d365cea6b010ab | SP | 982 | 1,364 | 187,923.89 | 239,536.44 | 3.34 | 22.33 |

### Top Seller States by Product GMV

| Seller State | Active Sellers | Orders | Product GMV | Product GMV per Seller | Avg Review | Avg Delivery Days |
|---|---:|---:|---:|---:|---:|---:|
| SP | 1,849 | 70,188 | 8,753,396.21 | 4,734.12 | 4.01 | 12.21 |
| PR | 349 | 7,673 | 1,261,887.21 | 3,615.72 | 4.07 | 13.32 |
| MG | 244 | 7,930 | 1,011,564.74 | 4,145.76 | 4.11 | 12.75 |
| RJ | 171 | 4,353 | 843,984.22 | 4,935.58 | 4.10 | 11.94 |
| SC | 190 | 3,667 | 632,426.07 | 3,328.56 | 4.10 | 13.52 |

### Seller Retention Proxy

| Metric | Value |
|---|---:|
| Sellers in dataset | 3,095 |
| Sellers active in only one month | 751 |
| Share active in only one month | 24.26% |
| Sellers inactive before the final three months | 1,273 |
| Share inactive before the final three months | 41.13% |

## Early Business Readout

- Marketplace activity is concentrated in Sao Paulo: SP contributes the largest order volume, product GMV, seller base, and customer demand.
- Seller concentration is meaningful: the top 100 sellers contribute 45.06% of product GMV, which creates both account-management opportunity and dependency risk.
- The strongest GMV categories are health and beauty, watches and gifts, bed/bath/table, sports/leisure, and computer accessories.
- Customer satisfaction is generally strong, with an average review score of 4.03 and most reviewed orders scoring 4 or 5.
- Delivery performance is materially slower in northern and northeastern states such as AM, AL, PA, MA, SE, and CE.
- Credit card is the dominant payment method by both order count and value.

## Notes for Next Iteration

- `gross_transaction_value` is calculated as item price plus freight at the order-item grain.
- Product GMV and gross transaction value are not the same as Olist revenue.
- Payment value should be analyzed from `raw.raw_order_payments` or an order-level payment fact to avoid double-counting payments across multi-item orders.
- The fact table currently contains all item records, including non-delivered statuses; some executive metrics may need a delivered-only filter.
- Seller retention and churn are proxies based on monthly transaction activity, not confirmed subscription retention.
