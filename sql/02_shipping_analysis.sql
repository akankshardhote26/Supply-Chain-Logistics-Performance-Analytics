-- Query 1: Shipping Performance by Mode

SELECT
    shipping_mode,
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(late_delivery_risk) AS risk_flagged_records,

    ROUND(
        100.0 * AVG(late_delivery_risk), 2
    ) AS late_delivery_risk_pct,

    ROUND(
        100.0 * AVG(is_late_shipment), 2
    ) AS late_shipment_pct,

    ROUND(
        AVG(shipping_delay_days)::numeric, 2
    ) AS avg_shipping_variance_days

FROM public.supply_chain_orders

GROUP BY shipping_mode

ORDER BY late_delivery_risk_pct DESC;

-- Query 2: Above-Average Shipping Risk Using CTE

WITH overall_risk AS (
    SELECT
        AVG(late_delivery_risk) * 100.0
            AS overall_risk_pct
    FROM public.supply_chain_orders
),

shipping_risk AS (
    SELECT
        shipping_mode,
        COUNT(*) AS total_records,
        AVG(late_delivery_risk) * 100.0
            AS risk_pct
    FROM public.supply_chain_orders
    GROUP BY shipping_mode
)

SELECT
    s.shipping_mode,
    s.total_records,
    ROUND(s.risk_pct::numeric, 2) AS risk_pct,
    ROUND(o.overall_risk_pct::numeric, 2)
        AS overall_risk_pct

FROM shipping_risk s

CROSS JOIN overall_risk o

WHERE s.risk_pct > o.overall_risk_pct

ORDER BY s.risk_pct DESC;

-- Query 3: Shipping Mode Ranking

WITH shipping_summary AS (
    SELECT
        shipping_mode,
        COUNT(*) AS total_records,
        AVG(late_delivery_risk) * 100.0
            AS risk_pct
    FROM public.supply_chain_orders
    GROUP BY shipping_mode
)

SELECT
    shipping_mode,
    total_records,
    ROUND(risk_pct::numeric, 2) AS risk_pct,

    DENSE_RANK() OVER (
        ORDER BY risk_pct DESC
    ) AS risk_rank,

    ROUND(
        100.0 * total_records
        / SUM(total_records) OVER (), 2
    ) AS record_share_pct

FROM shipping_summary

ORDER BY risk_rank;

-- Query 4: Shipping Duration Classification

WITH shipping_status AS (
    SELECT
        CASE
            WHEN shipping_delay_days < 0 THEN 'Early'
            WHEN shipping_delay_days = 0 THEN 'On Time'
            WHEN shipping_delay_days > 0 THEN 'Delayed'
            ELSE 'Unknown'
        END AS shipping_performance
    FROM public.supply_chain_orders
)

SELECT
    shipping_performance,
    COUNT(*) AS total_records,

    ROUND(
        100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER (), 2
    ) AS percentage_of_records

FROM shipping_status

GROUP BY shipping_performance

ORDER BY total_records DESC;