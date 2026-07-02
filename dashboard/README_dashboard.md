# 📊 Dashboard Setup Guide

## Power BI

1. Open Power BI Desktop
2. **Get Data** → Text/CSV → select all CSVs from `/data`
3. In Power Query, merge:
   - `orders` + `order_items` on `order_id`
   - Result + `customers` on `customer_id`
   - Result + `products` on `product_id`
   - Result + `category_translation` on `product_category_name`
   - Result + `reviews` on `order_id`
   - Result + `payments` on `order_id`
4. Create these measures in DAX:

```dax
Total Revenue = SUM(order_items[price]) + SUM(order_items[freight_value])

Total Orders = DISTINCTCOUNT(orders[order_id])

Avg Order Value = [Total Revenue] / [Total Orders]

Avg Review Score = AVERAGE(reviews[review_score])

Late Delivery Rate =
DIVIDE(
    COUNTROWS(FILTER(orders, orders[order_delivered_customer_date] > orders[order_estimated_delivery_date])),
    COUNTROWS(orders)
) * 100
```

5. Build 4 report pages:
   - **Overview**: KPI cards + monthly revenue line chart
   - **Sales**: Top categories bar chart + payment donut
   - **Customers**: Map of Brazil + RFM segment pie
   - **Operations**: Delivery time histogram + review score bar

---

## Tableau

1. Open Tableau Desktop → Connect to **Text File**
2. Drag all CSVs into the data source canvas
3. Join on matching keys (same as above)
4. Create calculated fields:
   - `Delivery Days = DATEDIFF('day', [Order Purchase Timestamp], [Order Delivered Customer Date])`
   - `Is Late = IF [Order Delivered Customer Date] > [Order Estimated Delivery Date] THEN 'Late' ELSE 'On Time' END`
5. Build dashboards using drag-and-drop

---

## Quick Tip

Import `rfm_segments.csv` (output from Notebook 03) directly for pre-built customer segmentation — no joins needed!
