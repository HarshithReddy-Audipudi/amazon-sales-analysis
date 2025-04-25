EXPLAIN ANALYZE
SELECT p.product_name, SUM(oi.quantity * oi.price_per_unit) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

CREATE INDEX idx_order_items_product_id ON order_items(product_id);
