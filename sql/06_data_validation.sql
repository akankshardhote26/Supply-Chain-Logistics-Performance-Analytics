-- =====================================================
-- SUPPLY CHAIN & LOGISTICS PERFORMANCE ANALYTICS
-- 06 - FINAL DATA VALIDATION
-- =====================================================

-- Query 1: Dataset completeness

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_item_id) AS unique_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.supply_chain_orders;


-- Query 2: Check missing critical values

SELECT
    COUNT(*) FILTER (
        WHERE order_id IS NULL
    ) AS missing_order_ids,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,

    COUNT(*) FILTER (
        WHERE sales IS NULL
    ) AS missing_sales,

    COUNT(*) FILTER (
        WHERE shipping_mode IS NULL
    ) AS missing_shipping_modes
FROM public.supply_chain_orders;


-- Query 3: Check duplicate order-item IDs

SELECT
    order_item_id,
    COUNT(*) AS duplicate_count
FROM public.supply_chain_orders
GROUP BY order_item_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Query 4: Validate financial and shipping KPIs

SELECT
    ROUND(SUM(sales)::numeric, 2)
        AS total_sales,

    ROUND(SUM(order_profit_per_order)::numeric, 2)
        AS reported_profit,

    ROUND(
        (
            100.0 * SUM(order_profit_per_order)
            / NULLIF(SUM(sales), 0)
        )::numeric, 2
    ) AS reported_profit_margin_pct,

    ROUND(
        (100.0 * AVG(late_delivery_risk))::numeric, 2
    ) AS late_delivery_risk_pct,

    ROUND(
        (100.0 * AVG(is_late_shipment))::numeric, 2
    ) AS late_shipment_pct,

    ROUND(
        AVG(shipping_delay_days)::numeric, 2
    ) AS avg_shipping_variance_days
FROM public.supply_chain_orders;