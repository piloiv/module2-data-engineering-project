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
| Product revenue | 13,591,643.70 |
| Freight revenue | 2,251,909.54 |
| Gross item sales | 15,843,553.24 |
| Average review score | 4.03 |
| Average delivery days | 12.41 |
| Average days delivered before estimate | 12.03 |

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

## Top Product Categories by Gross Item Sales

| Category | Orders | Items | Gross Item Sales | Avg Review |
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

## Top Customer States by Gross Item Sales

| State | Orders | Gross Item Sales | Avg Delivery Days |
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

## Early Business Readout

- Sales are concentrated in Sao Paulo: SP contributes the largest order volume and gross item sales, and also has faster average delivery than most large states.
- The strongest revenue categories are health and beauty, watches and gifts, bed/bath/table, sports/leisure, and computer accessories.
- Customer satisfaction is generally strong, with an average review score of 4.03 and most reviewed orders scoring 4 or 5.
- Delivery performance is materially slower in northern and northeastern states such as AM, AL, PA, MA, SE, and CE.
- Credit card is the dominant payment method by both order count and value.

## Notes for Next Iteration

- `gross_item_sales` is calculated as item price plus freight at the order-item grain.
- Payment value should be analyzed from `raw.raw_order_payments` or an order-level payment fact to avoid double-counting payments across multi-item orders.
- The fact table currently contains all item records, including non-delivered statuses; some executive metrics may need a delivered-only filter.
