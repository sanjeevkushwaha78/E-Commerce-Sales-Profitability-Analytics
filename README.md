# 🛒 E-Commerce Sales & Profitability Analytics

An end-to-end data analytics project using **MySQL, Python, and Power BI** to analyze e-commerce revenue, profitability, discounts, product performance, regional trends, and customer returns.

## 📌 Project Overview

- **Dataset:** 1,000 customers, 82 products, 5,000 orders, and 12,558 order line items
- **Time Period:** January 2024 – July 2026
- **Objective:** Identify revenue and profitability drivers and recommend data-driven business strategies.
- **Scope:** Revenue and profit calculations are based on delivered orders only.

## 📊 Key Business Metrics

| Metric | Value |
|---|---:|
| Revenue | 153.3M |
| Profit | 52.5M |
| Profit Margin | 34.3% |
| Delivered Orders | 4,386 |
| Average Order Value (AOV) | 34,955 |
| Delivered Rate | 87.7% |
| Cancelled Rate | 7.1% |
| Returned Rate | 5.1% |

*Note: Monetary values are reported in the dataset's currency.*

## 🔍 Key Business Findings

**1. Deep Discounts Reduce Profit Margins**

- Profit margin decreases from 41.5% with no discount to 22.0% with a 25% discount.
- All 120 loss-making sales occurred at discount levels of 20–25%.
- **Recommendation:** Cap routine discounts at 15% and require approval for higher discounts.

**2. Revenue Leaders Are Not Always Profitability Leaders**

- Home and Electronics generate the highest revenue.
- Books deliver the highest profit margin at 38.2%.
- Beauty has the lowest margin at 31.6%.
- **Recommendation:** Prioritize high-margin products while monitoring category-level profitability.

**3. The East Region Has a Revenue Opportunity**

- The East region contributes approximately 11% of total revenue.
- Other regions each contribute approximately 28–31%.
- Profit margins are broadly similar across regions.
- **Recommendation:** Investigate regional order volume, customer acquisition, and product availability before launching targeted campaigns.

**4. Revenue Growth Has Stalled**

- Revenue in 2025 was approximately 4.4% lower than in 2024.
- February shows a recurring revenue dip.
- **Recommendation:** Investigate seasonality, marketing performance, and monthly order trends.

**5. Returns Highlight Operational Issues**

- Late Delivery and Not Satisfied each account for approximately 22% of recorded return reasons.
- **Recommendation:** Improve carrier service-level agreements, delivery tracking, and warehouse quality control.

**6. Hypothesis Testing Reveals a Basket-Size Difference**

- Discounted orders have a higher average order value, with a reported p-value below 0.001.
- Discounted orders contain approximately 2.5 items per order, compared with 1.2 for non-discounted orders.
- The difference in order value does not establish that discounts themselves caused higher spending; basket size may explain part of the relationship.

- **Recommendation:** Run controlled A/B tests to measure the incremental impact of discounts.

## 💡 Business Recommendations

- Limit routine discounts to 15%, with approval required for deeper discounts.
- Promote high-margin categories such as Books.
- Investigate customer acquisition and conversion opportunities in the East region.
- Reduce delivery-related returns through carrier monitoring and warehouse QC.
- Use A/B testing to evaluate discount effectiveness.
- Monitor monthly revenue, profit margins, cancellations, and returns through a Power BI dashboard.

## 🧰 Tech Stack

- **Database:** MySQL
- **Data Analysis:** Python, pandas, NumPy
- **Visualization:** Matplotlib, Seaborn, Power BI
- **Statistical Analysis:** SciPy
- **Machine Learning:** scikit-learn
- **Environment:** Jupyter Notebook

## 📁 Project Structure

```text
E-Commerce-Sales-Profitability-Analytics/
│
├── data/
│   ├── raw/
│   └── cleaned/
│
├── notebooks/
│   ├── 01_data_loading_cleaning.ipynb
│   ├── 02_exploratory_data_analysis.ipynb
│   ├── 03_hypothesis_testing.ipynb
│   └── 04_profit_prediction.ipynb
│
├── sql/
│   ├── schema.sql
│   └── business_queries.sql
│
├── powerbi/
│   └── ecommerce_dashboard.pbix
│
├── requirements.txt
└── README.md
```

*Update the filenames above to match your actual repository.*

## 🔬 Methodology

1. **Data Loading:** Load e-commerce data from MySQL into pandas.
2. **Data Validation:** Check missing values, duplicate keys, invalid values, and join integrity.
3. **Exploratory Data Analysis:** Analyze revenue, profit, categories, regions, payment methods, discounts, and returns.
4. **Statistical Testing:** Apply Welch's t-test and Mann–Whitney U test; examine basket size as a potential confounder.
5. **Predictive Modelling:** Compare a Random Forest model with a linear baseline and investigate potential data leakage.
6. **Dashboard Development:** Build a Power BI dashboard with KPI cards, monthly trends, and filters for region, category, month, and payment method.

## ▶️ How to Run

### 1. Clone the Repository

```bash
git clone https://github.com/sanjeevkushwaha78/E-Commerce-Sales-Profitability-Analytics.git
```

### 2. Navigate to the Project Folder

```bash
cd E-Commerce-Sales-Profitability-Analytics
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Launch Jupyter Lab

```bash
jupyter lab
```

**Note:** Configure your MySQL connection and update any required dataset paths before running the notebooks. The Power BI dashboard requires Power BI Desktop to open.

## 👤 Author

**Sanjeev**

- GitHub: [@sanjeevkushwaha78](https://github.com/sanjeevkushwaha78)

---

⭐ If you find this project useful, consider giving the repository a star.
