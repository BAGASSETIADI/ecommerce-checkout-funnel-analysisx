-- =====================================================
-- E-COMMERCE CHECKOUT FUNNEL ANALYSIS
-- Author: Bagas Setiadi
-- Tools: BigQuery SQL
-- =====================================================

-- =====================================================
-- 1. FUNNEL ANALYSIS
-- =====================================================

SELECT
  event,
  COUNT(DISTINCT user_id) AS total_users
FROM `eccomerce-analisis.ecommerce_portfolio.events`
GROUP BY event
ORDER BY total_users DESC;


-- =====================================================
-- 2. FUNNEL CONVERSION RATE
-- =====================================================

SELECT
  COUNT(DISTINCT CASE
    WHEN event = 'view_item'
    THEN user_id
  END) AS view_users,

  COUNT(DISTINCT CASE
    WHEN event = 'add_to_cart'
    THEN user_id
  END) AS cart_users,

  COUNT(DISTINCT CASE
    WHEN event = 'checkout'
    THEN user_id
  END) AS checkout_users,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN event = 'add_to_cart'
      THEN user_id
    END)
    * 100.0
    /
    COUNT(DISTINCT CASE
      WHEN event = 'view_item'
      THEN user_id
    END),
    2
  ) AS add_to_cart_rate,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN event = 'checkout'
      THEN user_id
    END)
    * 100.0
    /
    COUNT(DISTINCT CASE
      WHEN event = 'add_to_cart'
      THEN user_id
    END),
    2
  ) AS checkout_rate

FROM `eccomerce-analisis.ecommerce_portfolio.events`;


-- =====================================================
-- 3. SEGMENT ANALYSIS
-- =====================================================

SELECT
  u.platform,
  u.user_type,
  e.category,

  COUNT(DISTINCT e.user_id) AS total_users,

  COUNT(DISTINCT CASE
    WHEN e.event = 'checkout'
    THEN e.user_id
  END) AS total_checkout,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN e.event = 'checkout'
      THEN e.user_id
    END)
    * 100.0
    /
    COUNT(DISTINCT e.user_id),
    2
  ) AS checkout_rate

FROM `eccomerce-analisis.ecommerce_portfolio.events` e

JOIN `eccomerce-analisis.ecommerce_portfolio.users` u
ON e.user_id = u.user_id

GROUP BY
  u.platform,
  u.user_type,
  e.category

ORDER BY checkout_rate ASC;


-- =====================================================
-- 4. DAILY CHECKOUT TREND
-- =====================================================

SELECT
  event_date,
  COUNT(DISTINCT user_id) AS checkout_total
FROM `eccomerce-analisis.ecommerce_portfolio.events`
WHERE event = 'checkout'
GROUP BY event_date
ORDER BY event_date;


-- =====================================================
-- 5. REVENUE ANALYSIS
-- =====================================================

SELECT
  SUM(amount) AS total_revenue,
  COUNT(DISTINCT transaction_id) AS total_transactions
FROM `eccomerce-analisis.ecommerce_portfolio.transactions`
WHERE status = 'success';


-- =====================================================
-- 6. PLATFORM ANALYSIS
-- =====================================================

SELECT
  u.platform,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN e.event = 'checkout'
      THEN e.user_id
    END)
    * 100.0
    /
    COUNT(DISTINCT e.user_id),
    2
  ) AS checkout_rate

FROM `eccomerce-analisis.ecommerce_portfolio.events` e

JOIN `eccomerce-analisis.ecommerce_portfolio.users` u
ON e.user_id = u.user_id

GROUP BY u.platform
ORDER BY checkout_rate DESC;


-- =====================================================
-- 7. CATEGORY ANALYSIS
-- =====================================================

SELECT
  category,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN event = 'checkout'
      THEN user_id
    END)
    * 100.0
    /
    COUNT(DISTINCT user_id),
    2
  ) AS checkout_rate

FROM `eccomerce-analisis.ecommerce_portfolio.events`

GROUP BY category
ORDER BY checkout_rate ASC;


-- =====================================================
-- 8. LOWEST PERFORMING SEGMENTS
-- =====================================================

SELECT
  u.platform,
  u.user_type,
  e.category,

  COUNT(DISTINCT e.user_id) AS total_users,

  COUNT(DISTINCT CASE
    WHEN e.event = 'checkout'
    THEN e.user_id
  END) AS total_checkout,

  ROUND(
    COUNT(DISTINCT CASE
      WHEN e.event = 'checkout'
      THEN e.user_id
    END)
    * 100.0
    /
    COUNT(DISTINCT e.user_id),
    2
  ) AS checkout_rate

FROM `eccomerce-analisis.ecommerce_portfolio.events` e

JOIN `eccomerce-analisis.ecommerce_portfolio.users` u
ON e.user_id = u.user_id

GROUP BY
  u.platform,
  u.user_type,
  e.category

ORDER BY checkout_rate ASC
LIMIT 10;