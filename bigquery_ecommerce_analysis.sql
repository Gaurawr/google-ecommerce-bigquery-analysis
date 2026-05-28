-- 1. Total Overview
SELECT
  COUNT(*) AS total_sessions,
  COUNT(DISTINCT fullVisitorId) AS unique_visitors,
  SUM(transactions) AS total_transactions,
  ROUND(SUM(totalTransactionRevenue)/1000000, 2) AS total_revenue_usd
FROM `data-to-insights.ecommerce.all_sessions`
WHERE totalTransactionRevenue IS NOT NULL;

-- 2. Top Cities by Revenue
SELECT
  city,
  country,
  COUNT(*) AS sessions,
  SUM(transactions) AS total_transactions,
  ROUND(SUM(totalTransactionRevenue)/1000000, 2) AS revenue_usd
FROM `data-to-insights.ecommerce.all_sessions`
WHERE totalTransactionRevenue IS NOT NULL
  AND city NOT IN ('not available in demo dataset', '(not set)')
GROUP BY city, country
ORDER BY revenue_usd DESC
LIMIT 10;

-- 3. Top 10 Products by Revenue
SELECT
  v2ProductName,
  SUM(productQuantity) AS total_quantity,
  ROUND(SUM(productRevenue)/1000000, 2) AS revenue_usd
FROM `data-to-insights.ecommerce.all_sessions`
WHERE productRevenue IS NOT NULL
  AND v2ProductName IS NOT NULL
GROUP BY v2ProductName
ORDER BY revenue_usd DESC
LIMIT 10;

-- 4. Traffic Channel Conversion Rate
SELECT
  channelGrouping,
  COUNT(DISTINCT fullVisitorId) AS unique_visitors,
  COUNT(DISTINCT CASE 
    WHEN transactions > 0 THEN fullVisitorId 
  END) AS converted_visitors,
  ROUND(COUNT(DISTINCT CASE 
    WHEN transactions > 0 THEN fullVisitorId 
  END) / COUNT(DISTINCT fullVisitorId) * 100, 2) AS conversion_rate
FROM `data-to-insights.ecommerce.all_sessions`
GROUP BY channelGrouping
ORDER BY conversion_rate DESC;

-- 5. Cart Abandonment Analysis
SELECT
  COUNT(DISTINCT CASE WHEN eCommerceAction_type = '2' 
    THEN fullVisitorId END) AS add_to_cart,
  COUNT(DISTINCT CASE WHEN eCommerceAction_type = '3' 
    THEN fullVisitorId END) AS checkout_started,
  COUNT(DISTINCT CASE WHEN eCommerceAction_type = '6' 
    THEN fullVisitorId END) AS purchase_completed,
  ROUND(COUNT(DISTINCT CASE WHEN eCommerceAction_type = '3' 
    THEN fullVisitorId END) /
  COUNT(DISTINCT CASE WHEN eCommerceAction_type = '2' 
    THEN fullVisitorId END) * 100, 2) AS cart_to_checkout_rate,
  ROUND(COUNT(DISTINCT CASE WHEN eCommerceAction_type = '6' 
    THEN fullVisitorId END) /
  COUNT(DISTINCT CASE WHEN eCommerceAction_type = '2' 
    THEN fullVisitorId END) * 100, 2) AS cart_to_purchase_rate
FROM `data-to-insights.ecommerce.all_sessions`;

