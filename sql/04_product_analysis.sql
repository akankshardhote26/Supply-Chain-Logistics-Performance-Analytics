-- Query 1: Category Sales and Profitability

SELECT
    category_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_item_quantity) AS units_sold,

    ROUND(SUM(sales)::numeric, 2) AS total_sales,

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

GROUP BY category_name

ORDER BY total_sales DESC;

-- Query 2: Top 10 Categories by Revenue

WITH category_sales AS (
    SELECT
        category_name,
        SUM(sales) AS total_sales

    FROM public.supply_chain_orders

    GROUP BY category_name
)

SELECT
    category_name,

    ROUND(total_sales::numeric, 2) AS total_sales,

    ROUND(
        (
            100.0 * total_sales
            / NULLIF(SUM(total_sales) OVER (), 0)
        )::numeric, 2
    ) AS revenue_contribution_pct,

    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS revenue_rank

FROM category_sales

ORDER BY revenue_rank

LIMIT 10;

-- Query 3: Loss-Making Categories

WITH category_profit AS (
    SELECT
        category_name,

        COUNT(*) AS total_records,

        ROUND(SUM(sales)::numeric, 2)
            AS total_sales,

        ROUND(SUM(order_profit_per_order)::numeric, 2)
            AS reported_profit,

        COUNT(*) FILTER (
            WHERE order_profit_per_order < 0
        ) AS loss_making_records

    FROM public.supply_chain_orders

    GROUP BY category_name
)

SELECT
    category_name,
    total_records,
    total_sales,
    reported_profit,
    loss_making_records

FROM category_profit

WHERE reported_profit < 0

ORDER BY reported_profit ASC;

-- Query 4: Top 3 Categories Within Each Market

WITH market_category_sales AS (
    SELECT
        market,
        category_name,
        SUM(sales) AS total_sales

    FROM public.supply_chain_orders

    GROUP BY market, category_name
),

ranked_categories AS (
    SELECT
        market,
        category_name,
        total_sales,

        ROW_NUMBER() OVER (
            PARTITION BY market
            ORDER BY total_sales DESC, category_name
        ) AS category_rank

    FROM market_category_sales
)

SELECT
    market,
    category_name,

    ROUND(total_sales::numeric, 2)
        AS total_sales,

    category_rank

FROM ranked_categories

WHERE category_rank <= 3

ORDER BY market, category_rank;