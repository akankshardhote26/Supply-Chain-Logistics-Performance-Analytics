-- Query 1: Monthly Sales and Profitability

SELECT
    DATE_TRUNC('month', order_date_dateorders)::date
        AS order_month,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(sales)::numeric, 2)
        AS total_sales,

    ROUND(SUM(order_profit_per_order)::numeric, 2)
        AS reported_profit,

    ROUND(
        (100.0 * SUM(order_profit_per_order)
        / NULLIF(SUM(sales), 0))::numeric, 2
    ) AS reported_profit_margin_pct

FROM public.supply_chain_orders

GROUP BY 1

ORDER BY order_month;

-- Query 2: Month-over-Month Revenue Growth

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date_dateorders)::date
            AS order_month,
        SUM(sales) AS total_sales

    FROM public.supply_chain_orders
    GROUP BY 1
),

revenue_comparison AS (
    SELECT
        order_month,
        total_sales,

        LAG(total_sales) OVER (
            ORDER BY order_month
        ) AS previous_month_sales

    FROM monthly_revenue
)

SELECT
    order_month,

    ROUND(total_sales::numeric, 2)
        AS total_sales,

    ROUND(previous_month_sales::numeric, 2)
        AS previous_month_sales,

    ROUND(
        (
            100.0 * (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0)
        )::numeric, 2
    ) AS mom_growth_pct

FROM revenue_comparison

ORDER BY order_month;

-- Query 3: Market Performance

SELECT
    market,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(sales)::numeric, 2)
        AS total_sales,

    ROUND(SUM(order_profit_per_order)::numeric, 2)
        AS reported_profit,

    ROUND(
        (100.0 * SUM(order_profit_per_order)
        / NULLIF(SUM(sales), 0))::numeric, 2
    ) AS reported_profit_margin_pct,

    ROUND(
        (100.0 * SUM(sales)
        / NULLIF(SUM(SUM(sales)) OVER (), 0))::numeric,
        2
    ) AS revenue_contribution_pct

FROM public.supply_chain_orders

GROUP BY market

ORDER BY total_sales DESC;

-- Query 4: Market Revenue Ranking

WITH market_summary AS (
    SELECT
        market,
        SUM(sales) AS total_sales,
        SUM(order_profit_per_order) AS reported_profit

    FROM public.supply_chain_orders
    GROUP BY market
)

SELECT
    market,

    ROUND(total_sales::numeric, 2)
        AS total_sales,

    ROUND(reported_profit::numeric, 2)
        AS reported_profit,

    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS revenue_rank,

    ROUND(
        (100.0 * total_sales
        / NULLIF(SUM(total_sales) OVER (), 0))::numeric,
        2
    ) AS revenue_share_pct

FROM market_summary

ORDER BY revenue_rank;