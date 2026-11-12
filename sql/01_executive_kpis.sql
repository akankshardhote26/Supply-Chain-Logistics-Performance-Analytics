-- =====================================================
-- SUPPLY CHAIN & LOGISTICS PERFORMANCE ANALYTICS
-- 01 - EXECUTIVE KPI ANALYSIS
-- =====================================================

-- Query 1: Overall Business Performance

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(order_profit_per_order)::numeric, 2)
        AS reported_profit,
    ROUND(
        (100.0 * SUM(order_profit_per_order)
        / NULLIF(SUM(sales), 0))::numeric, 2
    ) AS reported_profit_margin_pct
FROM public.supply_chain_orders;


-- Query 2: Shipping Performance KPIs

SELECT
    COUNT(*) AS total_records,
    ROUND(100.0 * AVG(late_delivery_risk), 2)
        AS late_delivery_risk_pct,
    ROUND(100.0 * AVG(is_late_shipment), 2)
        AS late_shipment_pct,
    ROUND(AVG(shipping_delay_days)::numeric, 2)
        AS avg_shipping_variance_days
FROM public.supply_chain_orders;


-- Query 3: Loss-Making Records

SELECT
    COUNT(*) AS total_records,
    COUNT(*) FILTER (
        WHERE order_profit_per_order < 0
    ) AS loss_making_records,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_profit_per_order < 0
        ) / NULLIF(COUNT(*), 0), 2
    ) AS loss_making_pct
FROM public.supply_chain_orders;