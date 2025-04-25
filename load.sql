-- Load category
COPY category(category_id, category_name)
FROM '/tmp/category.csv' DELIMITER ',' CSV HEADER;

-- Load products
COPY products(product_id, product_name, price, cost, category_id)
FROM '/tmp/products.csv' DELIMITER ',' CSV HEADER;

-- Load customers
COPY customers(customer_id, customer_name, state)
FROM '/tmp/customers.csv' DELIMITER ',' CSV HEADER;

-- Load sellers
COPY sellers(seller_id, seller_name, origin)
FROM '/tmp/sellers.csv' DELIMITER ',' CSV HEADER;

-- Load orders
COPY orders(order_id, order_date, customer_id, seller_id, order_status)
FROM '/tmp/orders.csv' DELIMITER ',' CSV HEADER;

-- Load order_items
COPY order_items(order_item_id, order_id, product_id, quantity, price_per_unit)
FROM '/tmp/order_items.csv' DELIMITER ',' CSV HEADER;

-- Load payments
COPY payments(payment_id, order_id, payment_date, payment_status)
FROM '/tmp/payments.csv' DELIMITER ',' CSV HEADER;

-- Load shipping
COPY shipping(shipping_id, order_id, shipping_date, return_date, shipping_provider, delivery_status)
FROM '/tmp/shipping.csv' DELIMITER ',' CSV HEADER;

-- Load inventory
COPY inventory(inventory_id, product_id, stock, warehouse_id, last_stock_date)
FROM '/tmp/inventory.csv' DELIMITER ',' CSV HEADER;
