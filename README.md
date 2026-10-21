# 🛒 E-Commerce Sales & Profitability Analytics

End-to-end data analytics project using **MySQL, Python (pandas, SciPy, scikit-learn) ,Statics,and Power BI**. It answers where an online retailer makes and loses money across products, regions, discounts and returns.

## 📌 Project Overview
- **Dataset:** 1,000 customers, 82 products, 5,000 orders, 12,558 order line items (Jan 2024 – Jul 2026)
- **Goal:** find the drivers of revenue and profit, and recommend actions
- **Scope:** revenue and profit are calculated on *Delivered* orders only

## 📊 Key Metrics
| Metric | Value |
|---|---|
| Revenue | 153.3M |
| Profit | 52.5M (34.3% margin) |
| Orders | 4,386 |
| Average Order Value | 34,955 |
| Order outcomes | 87.7% delivered, 7.1% cancelled, 5.1% returned |

## 🔍 Key Findings
1. **Deep discounts destroy margin.** Margin falls from 41.5% (no discount) to 22.0% (25% discount). All 120 loss-making sales occur at 20–25% discounts.
2. **Revenue rank is not profit rank.** Home and Electronics lead revenue, but Books earn the best margin (38.2%) and Beauty the lowest (31.6%).
3. **East region under-performs.** It brings only about 11% of revenue vs 28–31% for each other region, at a similar margin.
4. **Growth has stalled.** Revenue in 2025 was about 4.4% lower than in 2024, with a dip every February.
5. **Returns are mostly operational.** Late Delivery and Not Satisfied account for 22% each.
6. **Hypothesis test:** discounted orders have a much higher order value (p < 0.001), but they also contain more items (about 2.5 vs 1.2 per order). The effect is basket size, not proven discount impact.

## 💡 Recommendations
- Cap discounts at 15% or require approval above it
- Push high-margin categories such as Books
- Run a targeted acquisition campaign in the East region
- Reduce late-delivery and wrong-product returns with carrier SLAs and warehouse QC
- A/B test discounts before changing policy

## 🧰 Tech Stack
MySQL · Python · pandas · NumPy · Matplotlib · Seaborn · SciPy · scikit-learn · Power BI · Jupyter

## 📁 Project Structure
```
├── data/            # raw CSVs + cleaned dataset
├── notebooks/       # 01 load & clean, 02 EDA, 03 hypothesis testing, 04 profit prediction
├── sql/             # schema + 12 business queries
├── powerbi/         # Power BI dashboard (.pbix)
└── requirements.txt
```

## 🔬 Methodology
1. **Data loading:** MySQL to pandas
2. **Validation:** nulls, duplicate keys, impossible values, join integrity
3. **EDA:** distributions, trends, category, region, payment, discount and returns analysis
4. **Inference:** Welch's t-test and Mann-Whitney U, plus a basket-size confounder check
5. **Modelling:** Random Forest vs linear baseline, with leakage discussion
6. **Dashboard:** Power BI with KPI cards, trends and slicers for month, region, category and payment method

## ▶️ How to Run

```bash
git clone https://github.com/sanjeevkushwaha78/E-Commerce-Sales-Profitability-Analytics.git
cd E-Commerce-Sales-Profitability-Analytics
pip install -r requirements.txt
jupyter lab
```
Notebooks 02–04 run directly from `data/processed/ecommerce_clean_data.csv`. Notebook 01 needs MySQL (schema in `sql/01_schema.sql`)

## 👤 Author
**Sanjeev** — GitHub:@sanjeevkushwaha78
