/* ============================================================
   BLINKIT SALES ANALYSIS - SQL QUERIES
   ============================================================ */

-- Preview the imported data
SELECT * FROM blinkit_data;


/* ------------------------------------------------------------
   DATA CLEANING
   Standardize Item_Fat_Content values.
   Multiple variations of the same category (e.g. 'LF', 'low fat',
   'Low Fat') cause issues in reporting and aggregation, so they
   are normalized here into two consistent labels.
   ------------------------------------------------------------ */
UPDATE blinkit_data
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

-- Verify the cleaning worked
SELECT DISTINCT Item_Fat_Content FROM blinkit_data;


/* ============================================================
   A. KPIs
   ============================================================ */

-- 1. Total Sales (in millions)
SELECT CAST(SUM(Total_Sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit_data;

-- 2. Average Sales
SELECT CAST(AVG(Total_Sales) AS INT) AS Avg_Sales
FROM blinkit_data;

-- 3. Number of Items
SELECT COUNT(*) AS No_of_Orders
FROM blinkit_data;

-- 4. Average Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit_data;


/* ============================================================
   B. Total Sales by Fat Content
   ============================================================ */
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content;


/* ============================================================
   C. Total Sales by Item Type
   ============================================================ */
SELECT Item_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;


/* ============================================================
   D. Fat Content by Outlet for Total Sales (Pivot)
   ------------------------------------------------------------
   Transforms Item_Fat_Content values into columns so each
   Outlet_Location_Type shows Low Fat vs. Regular sales side by
   side. ISNULL guards against missing combinations returning
   NULL instead of 0.
   ============================================================ */
SELECT Outlet_Location_Type,
       ISNULL([Low Fat], 0) AS Low_Fat,
       ISNULL([Regular], 0) AS Regular
FROM
(
    SELECT Outlet_Location_Type, Item_Fat_Content,
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


/* ============================================================
   E. Total Sales by Outlet Establishment Year
   ============================================================ */
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;


/* ============================================================
   F. Percentage of Sales by Outlet Size
   ------------------------------------------------------------
   Uses a window function (SUM ... OVER()) to compute each
   Outlet_Size's share of total sales without collapsing rows.
   ============================================================ */
SELECT
    Outlet_Size,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


/* ============================================================
   G. Sales by Outlet Location
   ============================================================ */
SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;


/* ============================================================
   H. All Metrics by Outlet Type
   ============================================================ */
SELECT Outlet_Type,
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
       CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
