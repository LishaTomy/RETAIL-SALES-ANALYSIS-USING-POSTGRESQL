# SQL Retail Sales Analysis

## Project Overview  
This project focuses on analyzing **retail sales data** using SQL to extract key business insights.  
The dataset contains transactional sales information such as customer demographics, purchase details, product categories, and revenue figures.  

The goal is to:  
- Explore and clean the data.  
- Perform business-driven queries.  
- Derive insights into sales trends, customer behavior, and product performance.  

This project is designed to demonstrate **SQL skills in data cleaning, exploration, and analysis**.

---

## Dataset Description  
- **File:** `SQL - Retail Sales Analysis_utf.csv`  
- **Table Created:** `retail_sales`  

**Columns:**  
- `transactions_id` – Unique transaction identifier  
- `sale_date` – Date of sale  
- `sale_time` – Time of sale  
- `customer_id` – Unique customer identifier  
- `gender` – Gender of customer  
- `age` – Age of customer  
- `category` – Product category (Clothing, Electronics, Beauty, etc.)  
- `quantiy` – Units sold  
- `price_per_unit` – Price of each unit  
- `cogs` – Cost of goods sold  
- `total_sale` – Total sale value  

---

## Process & Methodology  

### 1. **Database & Table Creation**  
- Created a database: `sql_project_p1`  
- Created a table: `retail_sales` with proper schema.  

### 2. **Data Cleaning**  
- Checked for missing/null values.  
- Removed incomplete transactions.  

### 3. **Exploratory Data Analysis (EDA)**  
- Counted total records.  
- Identified unique customers and categories.  
- Checked data quality before analysis.  

### 4. **Business Analysis Queries**  
- Daily and monthly sales trends.  
- Best-performing product categories.  
- High-value customers.  
- Sales performance across genders and shifts (Morning, Afternoon, Evening).  

---

##  Key SQL Analysis & Insights  

### Sales by Category  
```sql
SELECT category, SUM(total_sale) AS net_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY total_orders DESC;
```

### Top 5 Customers by Sales
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### Best-Selling Month Each Year
```sql
SELECT 
    year, month, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY 1,2
) t
WHERE rank = 1
ORDER BY year, avg_sale DESC;

```

### Shift-Based Sales Analysis
```sql
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY total_orders DESC;

```

### Business Insights

- Clothing and Electronics were among the highest-selling categories.

- The average age of Beauty product buyers was lower compared to other categories.

- Evening sales recorded the highest number of transactions compared to Morning or Afternoon.

- A handful of top customers contributed significantly to total revenue (Pareto principle effect).

- Best-selling months aligned with holiday seasons, indicating seasonal demand spikes.

### Future Improvements

- Build visualizations using Tableau / Power BI / Python (Matplotlib, Seaborn).

- Add predictive analysis for customer purchase behavior(Multiple Regression or Time series analysis).

- Implement SQL stored procedures for automation.
  

> :woman_technologist:Created by **Lisha Tomy** | Data Enthusiast & Analyst
