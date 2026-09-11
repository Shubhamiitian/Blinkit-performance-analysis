# Blinkit Sales Analysis

An end-to-end sales analysis of Blinkit (grocery delivery) transaction data — from raw data cleaning in SQL to KPI calculation and an interactive Power BI dashboard.

## 📊 Project Overview

This project analyzes 8,500+ grocery sales records to uncover insights on:
- Overall sales performance and customer ratings
- Sales trends by product fat content and item type
- Outlet-level performance by location, size, type, and establishment year

## 🛠️ Tools Used

- **SQL Server** — data cleaning and KPI/metric queries
- **Power BI** — interactive dashboard and visualizations

## 📁 Repository Structure

```
blinkit-sales-analysis/
├── README.md
├── data/
│   └── blinkit_grocery_data.csv        # Raw dataset (8,523 rows)
├── docs/
│   └── query-doc.docx                  # Data cleaning + KPI queries
└── dashboard/
    └── blinkit-sales-analysis.pbix     # Power BI dashboard
```

## 🧹 Data Cleaning

The `Item_Fat_Content` field contained inconsistent category labels (`LF`, `low fat`, `Low Fat`, `reg`, `Regular`). These were standardized into two clean categories — **Low Fat** and **Regular** — to ensure accurate grouping and aggregation.

## 📈 Key KPIs

| KPI | Description |
|---|---|
| **Total Sales** | Sum of all sales, shown in millions |
| **Average Sales** | Average sale value per transaction |
| **No. of Orders** | Total transaction/item count |
| **Average Rating** | Mean customer rating across all items |

## 🔍 Analysis Breakdown

The SQL queries in [`docs/query-doc.docx`](docs/query-doc.docx) cover:

1. Total sales by **fat content**
2. Total sales by **item type**
3. Fat content sales split by **outlet location** (pivoted)
4. Total sales by **outlet establishment year**
5. Percentage of sales contributed by **outlet size**
6. Sales by **outlet location type**
7. Full metric breakdown (sales, avg sales, order count, rating, visibility) by **outlet type**

## 📐 Dataset Columns

| Column | Description |
|---|---|
| Item Identifier | Unique product ID |
| Item Fat Content | Low Fat / Regular |
| Item Type | Product category (e.g. Fruits and Vegetables, Dairy) |
| Item Visibility | Display visibility ratio |
| Item Weight | Product weight |
| Outlet Identifier | Unique outlet ID |
| Outlet Establishment Year | Year the outlet opened |
| Outlet Size | Small / Medium / High |
| Outlet Location Type | Tier 1 / Tier 2 / Tier 3 |
| Outlet Type | Supermarket Type1/2/3, Grocery Store |
| Total Sales | Sales value for the item |
| Rating | Customer rating |

