-- Query 1: Customer Segment Performance

SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(sales)::numeric, 2) AS total_sales,

    ROUND(
        (SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0))::numeric,
        2
    ) AS avg_order_value,

    ROUND(
        SUM(order_profit_per_order)::numeric, 2
    ) AS reported_profit,

    ROUND(
        (
            100.0 * SUM(order_profit_per_order)
            / NULLIF(SUM(sales), 0)
        )::numeric, 2
    ) AS reported_profit_margin_pct

FROM public.supply_chain_orders

GROUP BY customer_segment

ORDER BY total_sales DESC;

-- Query 2: Regional Sales and Delivery Risk

SELECT
    order_region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,

    ROUND(SUM(sales)::numeric, 2) AS total_sales,

    ROUND(
        SUM(order_profit_per_order)::numeric, 2
    ) AS reported_profit,

    ROUND(
        (
            100.0 * SUM(order_profit_per_order)
            / NULLIF(SUM(sales), 0)
        )::numeric, 2
    ) AS reported_profit_margin_pct,

    ROUND(
        (100.0 * AVG(late_delivery_risk))::numeric,
        2
    ) AS late_delivery_risk_pct

FROM public.supply_chain_orders

GROUP BY order_region

ORDER BY total_sales DESC;

-- Query 3: Regional Revenue Ranking

WITH regional_sales AS (
    SELECT
        order_region,
        SUM(sales) AS total_sales
    FROM public.supply_chain_orders
    GROUP BY order_region
)

SELECT
    order_region,
    ROUND(total_sales::numeric, 2) AS total_sales,

    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS revenue_rank,

    ROUND(
        (
            100.0 * total_sales
            / NULLIF(SUM(total_sales) OVER (), 0)
        )::numeric, 2
    ) AS revenue_share_pct

FROM regional_sales

ORDER BY revenue_rank;

-- Query 4: Customer Segment Contribution by Market

WITH market_totals AS (
    SELECT
        market,
        SUM(sales) AS market_sales
    FROM public.supply_chain_orders
    GROUP BY market
),

segment_sales AS (
    SELECT
        market,
        customer_segment,
        SUM(sales) AS segment_revenue,
        COUNT(DISTINCT order_id) AS total_orders
    FROM public.supply_chain_orders
    GROUP BY market, customer_segment
)

SELECT
    s.market,
    s.customer_segment,
    s.total_orders,

    ROUND(s.segment_revenue::numeric, 2)
        AS segment_revenue,

    ROUND(
        (
            100.0 * s.segment_revenue
            / NULLIF(m.market_sales, 0)
        )::numeric, 2
    ) AS market_revenue_share_pct,

    ROW_NUMBER() OVER (
        PARTITION BY s.market
        ORDER BY s.segment_revenue DESC, s.customer_segment
    ) AS segment_rank

FROM segment_sales s

JOIN market_totals m
    ON s.market = m.market

ORDER BY s.market, segment_rank;