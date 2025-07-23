use blinkitdb 

SELECT * FROM blinkit_data;

-- get total count of rows
SELECT COUNT(*) as Total_rows FROM blinkit_data;


--basic data cleaning
UPDATE blinkit_data 
SET Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'LOW FAT'
WHEN Item_Fat_Content = 'reg ' THEN 'REGULAR'
ELSE Item_Fat_Content
END


--total sales
SELECT CONCAT(CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)),' ','MILLIONS') 
AS TOTAL_SALES_MILLIONS FROM blinkit_data;

--getting average sales
SELECT ROUND(AVG(Sales),0) as Average_Sales FROM blinkit_data;

-- total number of different items sold
SELECT COUNT(*) as total_item_sold FROM blinkit_data;

--average rating

SELECT ROUND(AVG(rating),2) AS AVERAGE_RATING FROM blinkit_data

-- total sales by fat content
SELECT Item_Fat_Content,
	   ROUND(SUM(Sales),0) as Total_Sales,
	   ROUND(AVG(Sales),0) as Average_Sales,
	   COUNT(*) as total_item_sold,
	   ROUND(AVG(rating),2) AS AVERAGE_RATING
FROM blinkit_data
GROUP BY Item_Fat_Content;

--total sales by item type
SELECT Item_Type,
	   ROUND(SUM(Sales),0) as Total_Sales,
	   ROUND(AVG(Sales),0) as Average_Sales,
	   COUNT(*) as total_item_sold,
	   ROUND(AVG(rating),2) AS AVERAGE_RATING
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC; 

--Fat Content by Outlet for Total Sales 
SELECT Outlet_Location_Type,
	   ISNULL([LOW FAT],0) AS LOW_FAT,
	   ISNULL([REGULAR],0) AS REGULAR
FROM
(
	SELECT Outlet_Location_Type,Item_Fat_Content,
		   ROUND(SUM(Sales),2) AS Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type,Item_Fat_Content
) AS Source_Table
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content in ([LOW FAT],[REGULAR])
) AS PivotTable
ORDER BY Outlet_Location_Type


--Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year,
	   ROUND(SUM(Sales),0) as Total_Sales,
	   ROUND(AVG(Sales),0) as Average_Sales,
	   COUNT(*) as total_item_sold,
	   ROUND(AVG(rating),2) AS AVERAGE_RATING
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year; 

--percentage of sales by outlet size
SELECT Outlet_Size,
	   ROUND(SUM(Sales),2) as Total_Sales,
	   CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS SALES_PERCENTAGE
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

--sales by outlet location
SELECT Outlet_Location_Type,
	   ROUND(SUM(Sales),2) as Total_Sales,
	   CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS SALES_PERCENTAGE
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

--all metrices by outlet type
SELECT Outlet_Type,
	   ROUND(SUM(Sales),0) as Total_Sales,
	   ROUND(AVG(Sales),0) as Average_Sales,
	   COUNT(*) as Total_Item_Sold,
	   ROUND(AVG(rating),2) AS AVERAGE_RATING,
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC; 