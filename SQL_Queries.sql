# All these queries below are MySQL dialect

# 1. What are the top 5 brands by receipts scanned for most recent month
SELECT Brand.Name AS Brands, COUNT(DISTINCT(Receipts.Receipt_id)) AS Receipts_count
FROM Receipts JOIN Reward_Receipt_Item_List Items ON Receipts.Receipt_id = Items.Receipt_id
			  JOIN Brand ON Items.Barcode = Brand.Barcode
WHERE YEAR(Receipts.Scanned_date) = YEAR(CURRENT_DATE()) AND MONTH(Receipts.Scanned_date) = MONTH(CURRENT_DATE())
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



# 2. How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
SELECT Brands_ranking.Brands AS Brands, Brands_ranking.Rank_recent AS Recent_month_ranking, Brands_ranking.Rank_previous AS Previous_month_ranking
FROM
(SELECT Brands,
	   RANK() OVER (ORDER BY Recent_month.Receipts_count DESC) AS Rank_recent,
	   RANK() OVER (ORDER BY Previous_month.Receipts_count DESC) AS Rank_previous
FROM
(SELECT Brand.Name AS Brands, COUNT(DISTINCT(Receipts.Receipt_id)) AS Receipts_count
FROM Receipts JOIN Reward_Receipt_Item_List Items ON Receipts.Receipt_id = Items.Receipt_id
			  JOIN Brand ON Items.Barcode = Brand.Barcode
WHERE YEAR(Receipts.Scanned_date) = YEAR(CURRENT_DATE()) AND MONTH(Receipts.Scanned_date) = MONTH(CURRENT_DATE())
GROUP BY 1) Recent_month
LEFT JOIN
(SELECT Brand.Name AS Brands, COUNT(DISTINCT(Receipts.Receipt_id)) AS Receipts_count
FROM Receipts JOIN Reward_Receipt_Item_List Items ON Receipts.Receipt_id = Items.Receipt_id
			  JOIN Brand ON Items.Barcode = Brand.Barcode
WHERE YEAR(Receipts.Scanned_date) = YEAR(CURRENT_DATE()) AND MONTH(Receipts.Scanned_date) = MONTH(CURRENT_DATE() - INTERVAL 1 MONTH)
GROUP BY 1) Previous_month
ON Recent_month.Brands = Previous_month.Brands) Brands_ranking
ORDER BY Rank_previous
LIMIT 5



# 3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT Rewards_receipt_Status, AVG(Total_spent) AS Avg_spent
FROM Receipts
WHERE Rewards_receipt_Status IN ('Accepted', 'Rejected')
GROUP BY 1



# 4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT Rewards_receipt_Status, SUM(Purchased_item_count) AS Total_itmes_purchased
FROM Receipts
WHERE Rewards_receipt_Status IN ('Accepted', 'Rejected')
GROUP BY 1


# 5. Which brand has the most spend among users who were created within the past 6 months?
SELECT Brand.Name AS Brand, SUM(Receipts.Total_spent) AS Total_spent
FROM Users JOIN Receipts ON Users.User_id = Receipts.User_id
		   JOIN Reward_Receipt_Item_List Items ON Receipts.Receipt_id = Items.Receipt_id
		   JOIN Brand ON Items.Barcode = Brand.Barcode
WHERE Users.Created_date >= CURRENT_DATE() - INTERVAL 6 MONTH
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1



# 6. Which brand has the most transactions among users who were created within the past 6 months?
SELECT Brand.Name AS Brand, COUNT(DISTINCT(Receipts.Receipt_id)) AS Transactions
FROM Users JOIN Receipts ON Users.User_id = Receipts.User_id
		   JOIN Reward_Receipt_Item_List Items ON Receipts.Receipt_id = Items.Receipt_id
		   JOIN Brand ON Items.Barcode = Brand.Barcode
WHERE Users.Created_date >= CURRENT_DATE() - INTERVAL 6 MONTH
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1













