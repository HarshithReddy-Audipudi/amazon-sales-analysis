-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS shipping, payments, order_items, orders, sellers, customers, inventory, products, category CASCADE;

-- 1. Category
CREATE TABLE category (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL
);

-- 2. Products
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(150),
  price NUMERIC(10, 2),
  cost NUMERIC(10, 2),
  category_id INT REFERENCES category(category_id)
);

-- 3. Customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(150),
  state VARCHAR(100)
);

-- 4. Sellers
CREATE TABLE sellers (
  seller_id INT PRIMARY KEY,
  seller_name VARCHAR(100),
  origin VARCHAR(100)
);

-- 5. Orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  order_date DATE,
  customer_id INT REFERENCES customers(customer_id),
  seller_id INT REFERENCES sellers(seller_id),
  order_status VARCHAR(50)
);

-- 6. Order Items
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
  product_id INT REFERENCES products(product_id),
  quantity INT,
  price_per_unit NUMERIC(10, 2)
);

-- 7. Payments
CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  payment_date DATE,
  payment_status VARCHAR(50) DEFAULT 'Pending'
);

-- 8. Shipping
CREATE TABLE shipping (
  shipping_id INT PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  shipping_date DATE,
  return_date DATE,
  shipping_provider VARCHAR(100),
  delivery_status VARCHAR(50)
);

-- 9. Inventory
CREATE TABLE inventory (
  inventory_id INT PRIMARY KEY,
  product_id INT REFERENCES products(product_id),
  stock INT,
  warehouse_id INT,
  last_stock_date DATE
);
