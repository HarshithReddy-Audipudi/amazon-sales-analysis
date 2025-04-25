EXPLAIN ANALYZE
SELECT c.category_name, SUM(oi.quantity * oi.price_per_unit) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC;

CREATE INDEX idx_products_category_id ON products(category_id);


