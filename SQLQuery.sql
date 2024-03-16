--View top 1000 rows
SELECT TOP (1000) *
FROM shopping_trends_updated


--View average age of customers
SELECT AVG(Age) AS average_age
FROM shopping_trends_updated;


--View gender split of customers
SELECT Gender, COUNT(*) AS count
FROM shopping_trends_updated
GROUP BY Gender;


--View items ranked by number purchased
SELECT Item_Purchased, COUNT(*) AS count
FROM shopping_trends_updated
GROUP BY Item_Purchased
ORDER BY count DESC;


--View locations ranked by number of purchases
SELECT Location, COUNT(*) AS count
FROM shopping_trends_updated
GROUP BY Location
ORDER BY count DESC;


--View customer sizes per item
CREATE VIEW CustomerSizesPerItem_Purchased AS
SELECT 
    Item_Purchased,
    COUNT(CASE WHEN Size = 'S' THEN 1 END) AS small,
    COUNT(CASE WHEN Size = 'M' THEN 1 END) AS medium,
    COUNT(CASE WHEN Size = 'L' THEN 1 END) AS large,
    COUNT(CASE WHEN Size = 'XL' THEN 1 END) AS extra_large
FROM 
    shopping_trends_updated
GROUP BY 
    Item_Purchased;


--View the number of customers with and without subscriptions and the total percentage with subscriptions
SELECT
    subscribed_count,
    not_subscribed_count,
    CAST(subscribed_count * 1.0 / NULLIF(subscribed_count + not_subscribed_count, 0) AS DECIMAL(18, 2)) AS subscribed_percentage
FROM (
    SELECT
        SUM(CASE WHEN Subscription_Status = 'Yes' THEN 1 ELSE 0 END) AS subscribed_count,
        SUM(CASE WHEN Subscription_Status = 'No' THEN 1 ELSE 0 END) AS not_subscribed_count
    FROM
        shopping_trends_updated
) AS counts;


--View payment methods ranked by number used
SELECT Payment_Method, COUNT(*) AS count
FROM shopping_trends_updated
GROUP BY Payment_Method
ORDER BY count DESC;


--View total revenue
SELECT SUM(Purchase_Amount_USD) AS TotalRevenue
FROM shopping_trends_updated


--View items ranked by revenue
SELECT Item_Purchased, SUM(Purchase_Amount_USD) AS ItemRevenue
FROM shopping_trends_updated
GROUP BY Item_Purchased
ORDER BY ItemRevenue DESC;


--View items ranked by ratings and the total reviews
SELECT Item_Purchased, AVG(Review_Rating) AS avg_review_rating, COUNT(Review_Rating) AS review_count
FROM shopping_trends_updated
GROUP BY Item_Purchased
ORDER BY avg_review_rating DESC;


--View shipping type ranked by popularity
SELECT Shipping_Type, COUNT(Shipping_Type) AS frequency
FROM shopping_trends_updated
GROUP BY Shipping_Type
ORDER BY frequency DESC;


--View revenue by season
SELECT
    Season,
    SUM(Purchase_Amount_USD) AS Revenue,
    ROW_NUMBER() OVER (ORDER BY 
        CASE 
            WHEN Season = 'Spring' THEN 1
            WHEN Season = 'Summer' THEN 2
            WHEN Season = 'Fall' THEN 3
            WHEN Season = 'Winter' THEN 4
            ELSE 5  -- To handle any other values if present
        END) AS RowNumber
FROM
    shopping_trends_updated
GROUP BY
    Season
ORDER BY
    RowNumber;

View revenue over time