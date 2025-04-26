CREATE OR REPLACE PROCEDURE add_sales(
    p_order_id INT,
    p_customer_id INT,
    p_seller_id INT,
    p_order_item_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_count INT;
    v_price FLOAT;
    v_product_name VARCHAR(100);
BEGIN
    -- Fetch product price and name based on product ID
    SELECT price, product_name
    INTO v_price, v_product_name
    FROM products
    WHERE product_id = p_product_id;
    
    -- Check if enough stock is available
    SELECT COUNT(*) 
    INTO v_count
    FROM inventory
    WHERE product_id = p_product_id
    AND stock >= p_quantity;
    
    IF v_count > 0 THEN
        -- Insert into orders table
        INSERT INTO orders(order_id, order_date, customer_id, seller_id)
        VALUES (p_order_id, CURRENT_DATE, p_customer_id, p_seller_id);
        
        -- Insert into order_items table
        INSERT INTO order_items(order_item_id, order_id, product_id, quantity, price_per_unit, total_sale)
        VALUES (p_order_item_id, p_order_id, p_product_id, p_quantity, v_price, v_price * p_quantity);
        
        -- Update inventory table
        UPDATE inventory
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;
        
        RAISE NOTICE 'Sale added successfully: %, Inventory updated.', v_product_name;
        
    ELSE
        -- Not enough stock
        RAISE NOTICE 'Sale failed: Product % is out of stock or insufficient stock available.', v_product_name;
    END IF;
END;
$$;