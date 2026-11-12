# Supply Chain & Logistics Performance Analytics

### End-to-End Data Analytics Project | Excel, Python, PostgreSQL, Power BI

## Project Overview

Developed an end-to-end supply chain analytics solution using Advanced Excel, Python (Pandas), PostgreSQL, and Power BI to evaluate sales performance, shipping efficiency, profitability, customer segments, and regional operations.

The project analyzes **180,519 order-item records**, representing **65,752 unique orders** and **20,652 customers**, to identify operational risks and opportunities for data-driven business decisions.

## Business Problem

Supply chain operations generate large volumes of transactional data, but businesses often struggle to identify shipping inefficiencies, understand profitability differences, and monitor regional performance.

This project addresses five key business questions:

1. Which shipping modes have the highest delivery-risk rates?
2. How do sales and reported profitability vary across markets?
3. Which product categories contribute the most revenue?
4. How do customer segments and regions influence sales performance?
5. What operational improvements should be investigated?

## Dataset

**Source:** DataCo Smart Supply Chain Dataset (Kaggle)

- Original records: 180,519
- Original attributes: 53
- Granularity: Order-item level
- Domains: Sales, logistics, customers, products, and geography

The original dataset is not included in this repository. The Python notebook documents the cleaning and feature-engineering workflow.

## Tools & Technologies

| Tool                 | Application                                                    |
| -------------------- | -------------------------------------------------------------- |
| Microsoft Excel      | Data quality checks, formulas, Pivot Tables, shipping analysis |
| Python               | Data cleaning, feature engineering, exploratory data analysis  |
| Pandas & NumPy       | Data transformations, aggregation, KPI calculations            |
| Matplotlib & Seaborn | Statistical and business visualizations                        |
| PostgreSQL           | Business analysis using SQL                                    |
| Power BI             | Interactive dashboards, DAX measures, KPI reporting            |
| Git & GitHub         | Version control and project documentation                      |

## Project Workflow

**Dataset → Excel Validation → Python Cleaning & EDA → PostgreSQL Analysis → Power BI Dashboards → Business Insights**

### 1. Excel Analysis

Performed spreadsheet-based analysis using:

- Data quality and completeness checks
- COUNTIFS, SUMIFS, IFERROR, and conditional calculations
- Pivot Tables for shipping performance
- Summary analysis of delivery-risk indicators

Workbook: `excel/DataCoSupplyChainDataset.xlsx`

### 2. Python Data Cleaning & EDA

Developed a Jupyter Notebook to:

- Inspect data types, missing values, and duplicates
- Remove unnecessary personal-information fields
- Standardize column names
- Parse transaction dates
- Engineer shipping-duration variance and performance classifications
- Calculate revenue, customer, order, and reported-profitability KPIs
- Analyze shipping modes, markets, product categories, customer segments, and regions
- Generate business visualizations

Notebook: `python/supply_chain_eda.ipynb`

### 3. PostgreSQL & Advanced SQL Analysis

Developed six SQL scripts covering:

| Script                              | Analysis                                                       |
| ----------------------------------- | -------------------------------------------------------------- |
| `01_executive_kpis.sql`             | Overall sales, orders, customers, and shipping KPIs            |
| `02_shipping_analysis.sql`          | Shipping-mode comparisons, CTEs, and rankings                  |
| `03_sales_profitability.sql`        | Monthly revenue trends, LAG, and market analysis               |
| `04_product_analysis.sql`           | Category profitability and market-specific rankings            |
| `05_customer_regional_analysis.sql` | Customer segments, regional performance, and JOINs             |
| `06_data_validation.sql`            | Record counts, missing values, duplicates, and KPI consistency |

**SQL techniques:** GROUP BY, JOIN, CTEs, CASE WHEN, DATE_TRUNC, LAG, ROW_NUMBER, DENSE_RANK, window functions, and conditional aggregation.

### 4. Power BI Dashboards

Created five dashboard pages:

**Page 1 — Executive Overview**

Overall revenue, orders, reported profit, delivery-risk indicators, monthly sales trends, and business performance KPIs.

**Page 2 — Shipping & Delivery Performance**

Shipping-mode comparisons, late-delivery risk, actual-versus-scheduled shipping duration, and operational performance.

**Page 3 — Sales & Profitability Analysis**

Market-level sales, reported profit margins, revenue contribution, and profitability comparisons.

**Page 4 — Product & Category Performance**

Category revenue, product contribution, reported profitability, and product performance rankings.

**Page 5 — Customer & Regional Performance**

Customer segment analysis, regional revenue, customer distribution, and reported profitability.

## Key Performance Indicators

| KPI                                   |          Result |
| ------------------------------------- | --------------: |
| Order-item records                    |         180,519 |
| Unique orders                         |          65,752 |
| Unique customers                      |          20,652 |
| Total sales                           |         $36.78M |
| Reported profit                       |          $3.97M |
| Reported profit margin                |          10.78% |
| Late-delivery risk flag rate          |          54.83% |
| Late-shipment duration rate           |          57.28% |
| Average shipping-duration variance    |      +0.57 days |
| Records with negative reported profit | 33,784 (18.71%) |

These are the project's previously recorded KPI values.

## Key Business Insights

### Shipping Performance

- First Class recorded the highest late-delivery risk flag rate at **95.32%**.
- Standard Class recorded the lowest rate at **38.07%**.
- The difference between these shipping modes was **57.25 percentage points**.
- Actual shipping duration exceeded scheduled duration in **57.28%** of order-item records.

**Recommendation:** Investigate shipping schedules, fulfillment processes, and differences between service levels.

### Profitability

- Approximately **18.71%** of records showed negative reported profit.
- Profitability varies across markets, product categories, and regions.

**Recommendation:** Investigate loss-making transactions, discounting patterns, and category-level margins before making pricing decisions.

### Sales and Customer Performance

- Market and product-category analysis identifies major revenue contributors.
- Customer segmentation highlights differences in order volume and revenue contribution.
- Regional comparisons help prioritize deeper commercial and operational analysis.

**Recommendation:** Use revenue contribution, reported profitability, and operational risk together when prioritizing business improvements.

## Data Interpretation & Limitations

- `Late_delivery_risk` is a risk indicator, not proof that an order arrived late.
- A late shipment means actual shipping duration exceeded scheduled duration; it does not necessarily establish a late customer delivery.
- The dataset's reported profit field showed a small discrepancy when compared with an independent item-level calculation. Profit figures should therefore be treated as provisional pending further validation.
- Because the dataset is at order-item level, unique orders and customers are counted using distinct identifiers.

## Repository Structure

```text
Supply-Chain-Logistics-Performance-Analytics/
├── excel/
│   └── DataCoSupplyChainDataset.xlsx
├── python/
│   └── supply_chain_eda.ipynb
├── sql/
│   ├── 01_executive_kpis.sql
│   ├── 02_shipping_analysis.sql
│   ├── 03_sales_profitability.sql
│   ├── 04_product_analysis.sql
│   ├── 05_customer_regional_analysis.sql
│   └── 06_data_validation.sql
├── powerbi/
│   └── screenshots/
│       ├── SupplyChain_Dashboard_1.png
│       ├── SupplyChain_Dashboard_2.png
│       ├── SupplyChain_Dashboard_3.png
│       ├── SupplyChain_Dashboard_4.png
│       └── SupplyChain_Dashboard_5.png
├── README.md
└── .gitignore
```

## How to Reproduce

1. Obtain the DataCo Smart Supply Chain Dataset from Kaggle.
2. Place the original CSV in the `data/` directory.
3. Install the Python dependencies: pandas, numpy, matplotlib, and seaborn.
4. Run `python/supply_chain_eda.ipynb` to clean the dataset and generate the analysis.
5. Export the cleaned CSV and import it into a PostgreSQL table named `public.supply_chain_orders`.
6. Execute the SQL scripts in numerical order.
7. Review the Power BI dashboard screenshots and compare the documented KPIs.

## Project Outcome

This project demonstrates an end-to-end Data Analyst workflow integrating spreadsheet analysis, Python data preparation, PostgreSQL querying, and Power BI reporting to translate supply chain data into measurable business insights and operational recommendations.
