# 🛒 E-Commerce Sales Analytics — Olist Brazil Dataset

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-SQLite-orange?logo=sqlite)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange?logo=jupyter)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

## 📌 Project Overview

An end-to-end data analytics project using the **Olist Brazilian E-Commerce Dataset** (100k+ real orders from 2016–2018). This project covers the full analytics pipeline — from raw data exploration to business insights and interactive dashboards.

---

## 🎯 Business Questions Answered

- What are the monthly and yearly sales trends?
- Which product categories generate the most revenue?
- Who are our most valuable customers? (RFM Segmentation)
- What factors affect customer satisfaction scores?
- Which states have the highest order volumes?
- What is the average delivery time, and how does it affect reviews?
- Which sellers are top performers?

---

## 📁 Project Structure

```
ecommerce-analytics/
│
├── data/                        # Raw datasets (download from Kaggle)
│   └── README_data.md
│
├── notebooks/
│   ├── 01_EDA.ipynb             # Exploratory Data Analysis
│   ├── 02_Sales_Analysis.ipynb  # Sales Trends & KPIs
│   ├── 03_RFM_Segmentation.ipynb# Customer Segmentation
│   └── 04_Product_Analysis.ipynb# Product & Category Deep Dive
│
├── sql/
│   └── queries.sql              # 15+ business SQL queries
│
├── dashboard/
│   └── README_dashboard.md      # Dashboard setup instructions
│
├── requirements.txt
└── README.md
```

---

## 📊 Dataset

**Source:** [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

| File | Description |
|------|-------------|
| `olist_orders_dataset.csv` | Order status, timestamps |
| `olist_order_items_dataset.csv` | Items, price, freight |
| `olist_customers_dataset.csv` | Customer location |
| `olist_products_dataset.csv` | Product info & category |
| `olist_sellers_dataset.csv` | Seller location |
| `olist_order_reviews_dataset.csv` | Review scores & comments |
| `olist_order_payments_dataset.csv` | Payment type & value |
| `product_category_name_translation.csv` | Portuguese → English |

> Download all CSVs and place them in the `/data` folder.

---

## 🔧 Tech Stack

| Tool | Usage |
|------|-------|
| Python 3.9+ | Core analysis |
| pandas | Data manipulation |
| matplotlib / seaborn | Visualizations |
| SQLite / SQL | Business queries |
| scikit-learn | RFM clustering |
| Jupyter Notebook | Interactive analysis |
| Power BI / Tableau | Dashboard |

---

## 🚀 Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/ecommerce-analytics.git
cd ecommerce-analytics
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Download the dataset
Go to [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), download all CSVs, and place them in the `/data` folder.

### 4. Run notebooks in order
```bash
jupyter notebook
```
Open notebooks in sequence: `01` → `02` → `03` → `04`

---

## 📈 Key Insights (Summary)

- 📦 **96,478** total orders analyzed across **2016–2018**
- 💰 Peak sales in **November 2017** (Black Friday effect)
- 🏆 Top categories: **Bed/Bath/Table**, **Health & Beauty**, **Sports & Leisure**
- 📍 **São Paulo** accounts for ~40% of all orders
- ⭐ Average review score: **4.09 / 5.0**
- 🚚 Late deliveries correlate strongly with low review scores

---

## 👤 Author

**Your Name**
- GitHub:   https://github.com/jalebi-007
- LinkedIn: https://www.linkedin.com/in/md-affan-a62211230

---

## 📄 License

This project is open source under the [MIT License](LICENSE).
