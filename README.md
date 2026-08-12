# 🚚 Supply Chain & Logistics Performance Analytics

An end-to-end **Data Analytics project** focused on analyzing shipping performance, delivery delays, replenishment risk, fulfillment markets, and customer value using the **DataCo Smart Supply Chain** dataset.

The project uses **SQL-first analytical workflows** with DuckDB, supported by Python for data processing and visualization, and a Streamlit dashboard for interactive business analysis.

---

## 📌 Business Problem

A supply chain operations team needs to understand:

- Which shipping modes consistently deliver on time?
- Where are delivery delays concentrated?
- Which products create the highest replenishment burden?
- Which fulfillment markets perform better operationally?
- Which customers generate the most valuable business relationships?
- Are delivery problems isolated to specific markets or indicative of a broader operational issue?

This project analyzes these questions and converts raw transactional data into actionable operational insights.

---

## 📊 Dataset

**Dataset:** https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis 
**Source:** Kaggle  
**Domain:** Supply Chain, Logistics & Operations Analytics

**Dataset size:**
- ~180,000 orders
- 53 original columns
- 44 analytical columns loaded into the project

### Data Privacy

The original dataset contains synthetic customer fields that resemble personally identifiable information, including names, email addresses, passwords, and street addresses.

These fields are **excluded during data loading** because they are unnecessary for the analysis and following data-minimization practices is important even when working with synthetic datasets.

### Data Limitation

The dataset does not contain an actual **on-hand inventory/stock quantity** field.

Therefore, a traditional reorder alert such as:

> Average Daily Demand × Lead Time > Current Stock

cannot be calculated reliably.

Instead, the project uses a **Replenishment Burden Score**, combining order quantity and lead-time characteristics to identify products with comparatively higher replenishment requirements.

---

## 🛠️ Technology Stack

| Area | Tools |
|---|---|
| Data Analysis | Python, Pandas |
| SQL Analytics | DuckDB |
| Data Visualization | Matplotlib, Seaborn |
| Interactive Dashboard | Streamlit, Plotly |
| Notebook | Jupyter |
| Data Source | Kaggle |

---

## 🏗️ Project Architecture

The project follows a **SQL-first analytical architecture**:

```text
Raw Dataset
     │
     ▼
Python Data Loading
     │
     ▼
DuckDB
     │
     ├── SQL Analytical Queries
     │
     ▼
 ┌───────────────┐
 │               │
 ▼               ▼
Jupyter        Streamlit
Analysis       Dashboard
 │               │
 ▼               ▼
Insights       Interactive KPIs
```

### Project Structure

```text
03-supply-chain-analysis/
│
├── data/
│   └── DataCoSupplyChainDataset.csv
│
├── queries.sql
├── db.py
├── analysis.ipynb
├── app.py
├── download_data.py
├── requirements.txt
└── README.md
```

---

## 🔍 Key Analytical Areas

### 1. Shipping Performance Analysis

Analyzed delivery performance across different shipping modes using:

- On-time delivery rate
- Late delivery rate
- Average delivery delay
- Regional shipping performance

A `CASE WHEN` classification is used to categorize orders as **On-Time** or **Late**.

### 2. Geographic Delay Analysis

Analyzed delivery performance across:

- Regions
- Shipping modes
- Markets

A multi-dimensional SQL aggregation is used to identify combinations where delivery delays are particularly high.

### 3. Replenishment Burden Analysis

Because actual inventory levels are unavailable, a proxy **Replenishment Burden Score** is calculated using:

- Average order quantity
- Average lead time

Products are then categorized into risk quartiles using `NTILE(4)`.

This provides a relative view of products that may require greater replenishment attention.

### 4. Fulfillment Market Performance

Markets are compared using operational and financial KPIs such as:

- On-time delivery rate
- Late delivery rate
- Average profit ratio
- Order volume

The analysis helps determine whether operational performance varies significantly across fulfillment markets.

### 5. Customer RFM Segmentation

Customers are segmented using **RFM analysis**:

- **Recency** — how recently a customer purchased
- **Frequency** — how often a customer purchased
- **Monetary Value** — how much revenue a customer generated

Customers are assigned quartile-based scores and categorized into segments such as:

- Champions
- Loyal Customers
- At Risk
- Other Customer Groups

This provides a framework for customer retention and prioritization.

---

## 📈 Key Findings

### 🚚 Shipping Mode Performance

The analysis shows that the shipping-mode label does not necessarily represent actual delivery reliability.

- **First Class:** ~95.3% late deliveries
- **Same Day:** ~45.7% late deliveries
- **Standard Class:** ~38.1% late deliveries

This indicates that a premium service label does not automatically translate into better operational performance.

### 🌎 Regional Performance

The region × shipping-mode analysis shows that:

- First Class experiences extremely high late-delivery rates across most regions.
- Standard Class performs considerably better across regions.
- The delivery issue appears to be associated more strongly with shipping-mode/process characteristics than with a single geographic region.

### 📦 Replenishment Risk

Products were ranked using a replenishment-burden proxy based on order quantity and lead time.

This allows operations teams to identify products that may require greater planning attention despite the absence of actual inventory-level data.

### 🏭 Fulfillment Markets

Operational performance is relatively similar across fulfillment markets, with approximately:

- ~45% on-time delivery
- ~0.12 average profit ratio

This suggests that delivery delays are likely **systemic rather than isolated to one fulfillment market**.

### 👥 Customer Value

RFM segmentation indicates that high-value segments such as **Champions and Loyal Customers represent a smaller portion of the customer base while contributing a significant share of revenue**.

This provides a strong basis for targeted customer-retention strategies.

---

## 🧠 SQL Concepts Demonstrated

The project demonstrates practical SQL techniques including:

- `CASE WHEN`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `NTILE()`
- Multi-column aggregations
- Date parsing with `STRPTIME`
- Date calculations using `DATE_DIFF`
- Window functions
- `CROSS JOIN`
- Aggregate calculations
- Quartile-based segmentation
- Parameterized analytical queries

---

## 📊 Dashboard

The Streamlit dashboard provides an interactive view of:

- Shipping performance
- Delivery delays
- Regional performance
- Product replenishment risk
- Market-level KPIs
- Customer RFM segments

Users can filter the analysis to explore different operational dimensions and identify performance patterns.

---

## 💡 Business Recommendations

Based on the analysis, organizations could:

1. **Review First Class shipping operations** instead of assuming premium service levels guarantee better performance.
2. **Investigate the root causes of systemic delivery delays** across shipping processes.
3. **Prioritize high replenishment-burden products** for improved demand and supply planning.
4. **Monitor fulfillment performance using standardized KPIs** across markets.
5. **Prioritize Champions and Loyal Customers** for retention and personalized engagement strategies.
6. **Improve inventory analytics** by incorporating actual stock-on-hand data in future versions.

---

## ⚠️ Data & Methodology Limitations

This project intentionally documents limitations rather than making unsupported assumptions.

The most important limitation is the absence of an actual inventory/stock column. Consequently, the replenishment analysis uses a **proxy score rather than a true stockout/reorder prediction model**.

Additionally, the dataset does not provide a dedicated supplier entity/table, so supplier-level reliability analysis is not directly possible.

---

## 🚀 Future Improvements

Potential extensions include:

- Add real inventory/on-hand stock data
- Build stockout prediction models
- Develop demand forecasting
- Add supplier-level performance analysis
- Create automated KPI reporting
- Implement anomaly detection for delivery delays
- Add cost-to-serve analysis
- Deploy the dashboard to a cloud platform

---

## 🎯 Skills Demonstrated

**Data Analytics:**  
Exploratory Data Analysis, KPI Development, Business Analysis, RFM Segmentation

**SQL:**  
Advanced Aggregations, Window Functions, Date Analysis, Conditional Logic, Analytical Query Design

**Python:**  
Pandas, DuckDB, Data Processing

**Visualization:**  
Matplotlib, Seaborn, Plotly, Streamlit

**Business Intelligence:**  
Supply Chain Analytics, Logistics Performance, Customer Analytics, Operational KPI Analysis

---

## ▶️ How to Run

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd <repository-folder>
```

### 2. Create a virtual environment

```bash
python -m venv .venv
```

Activate it:

**Windows**
```bash
.venv\Scripts\activate
```

**macOS / Linux**
```bash
source .venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Download the dataset

```bash
cd 03-supply-chain-analysis
python download_data.py
```

### 5. Run the notebook

```bash
jupyter notebook analysis.ipynb
```

### 6. Launch the dashboard

```bash
streamlit run app.py
```

---

## 📌 Project Outcome

This project demonstrates how raw supply-chain transaction data can be transformed into **actionable operational insights using SQL, Python, and interactive visualization**.

Rather than focusing only on descriptive charts, the analysis connects operational metrics with business questions around **delivery reliability, replenishment planning, fulfillment performance, and customer value**.
