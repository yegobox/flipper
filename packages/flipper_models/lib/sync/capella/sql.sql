
DECLARE
    total_value NUMERIC := 0;
    item_name_list TEXT := '';
    category_name_list TEXT := '';
    category_id_list TEXT := '';
    item_count INT := 0;
    total_profit NUMERIC := 0;
    total_price NUMERIC := 0;
    average_price NUMERIC := 0;
    total_quantity INT := 0;
    total_stock_remained NUMERIC := 0;
    total_supply_price NUMERIC := 0;
    total_retail_price NUMERIC := 0;
    total_current_stock NUMERIC := 0;
    total_stock_value NUMERIC := 0;
    branch_total_stock_value NUMERIC := 0;
    transaction_item RECORD;
    analytics_exists BOOLEAN := FALSE;
BEGIN
    -- Check if the status is updated to 'completed' and analytics doesn't exist yet
    IF NEW.status = 'completed' AND OLD.status IS DISTINCT FROM NEW.status THEN
        -- Check if business analytics already exists for this transaction
        SELECT EXISTS(SELECT 1 FROM business_analytics WHERE transaction_id = NEW.id) INTO analytics_exists;
        
        IF NOT analytics_exists THEN
            -- Calculate total branch stock value (all variants in branch)
            SELECT COALESCE(SUM(s.current_stock * COALESCE(v.retail_price, v.prc, 0)), 0)
            INTO branch_total_stock_value
            FROM stocks s
            JOIN variants v ON s.id = v.stock_id
            WHERE v.branch_id = NEW.branch_id;
            -- Calculate comprehensive analytics data
            FOR transaction_item IN
                SELECT 
                       COALESCE(NULLIF(ti.price, 0), ti.prc, 0) * ti.qty AS item_value, 
                       v.item_nm AS item_name, 
                       ti.qty, 
                       v.tax_ty_cd, 
                       COALESCE(NULLIF(ti.price, 0), ti.prc, 0) AS price, 
                       v.category_name,
                       v.category_id,
                       COALESCE(v.supply_price, 0) AS supply_price,
                       COALESCE(v.retail_price, ti.price) AS retail_price,
                       COALESCE(ti.remaining_stock, 0) AS remaining_stock,
                       COALESCE(s.current_stock, 0) AS current_stock
                FROM transaction_items ti
                JOIN variants v ON ti.variant_id = v.id
                LEFT JOIN stocks s ON v.stock_id = s.id
                WHERE ti.transaction_id = NEW.id
            LOOP
                total_value := total_value + transaction_item.item_value;
                item_name_list := item_name_list || ', ' || transaction_item.item_name;
                category_name_list := category_name_list || ', ' || transaction_item.category_name;
                category_id_list := category_id_list || ', ' || transaction_item.category_id;
                item_count := item_count + 1;
                total_price := total_price + transaction_item.price;
                total_quantity := total_quantity + transaction_item.qty;
                total_supply_price := total_supply_price + transaction_item.supply_price;
                total_retail_price := total_retail_price + transaction_item.retail_price;
                total_current_stock := total_current_stock + transaction_item.current_stock;
                -- Keep transaction-specific stock for reference
                total_stock_value := total_stock_value + (transaction_item.current_stock * transaction_item.retail_price);

                -- Calculate profit based on selling price and supply price
                -- Calculate profit based on item value (revenue) minus total supply cost for this item line
                total_profit := total_profit + (transaction_item.item_value - (transaction_item.supply_price * transaction_item.qty));
                
                -- Accumulate remaining stock from transaction items
                total_stock_remained := total_stock_remained + transaction_item.remaining_stock;
            END LOOP;

            -- Remove the leading comma and space if there are items
            IF item_count > 0 THEN
                item_name_list := substring(item_name_list FROM 3);
                category_name_list := substring(category_name_list FROM 3);
                category_id_list := substring(category_id_list FROM 3);
                -- Use weighted average price (Total Value / Total Quantity) instead of simple average
                IF total_quantity > 0 THEN
                    average_price := total_value / total_quantity;
                ELSE
                    average_price := 0;
                END IF;
            END IF;

            -- Insert comprehensive analytics data
            INSERT INTO business_analytics (
                date, value, item_name, category_name, category_id, units_sold, traffic_count, 
                tax_rate, price, profit, branch_id, stock_remained_at_the_time_of_sale, 
                transaction_id, supply_price, retail_price, current_stock, stock_value,
                payment_method, customer_type, discount_amount, tax_amount
            )
            VALUES (
                now(),
                total_value,
                item_name_list,
                category_name_list,
                category_id_list,
                total_quantity,
                total_quantity,
                0.18,
                average_price,
                total_profit,
                NEW.branch_id,
                total_stock_remained,
                NEW.id,
                CASE WHEN item_count > 0 THEN total_supply_price / item_count ELSE 0 END,
                CASE WHEN item_count > 0 THEN total_retail_price / item_count ELSE 0 END,
                total_current_stock,
                branch_total_stock_value,
                COALESCE(NEW.payment_type, 'cash'),
                COALESCE(NEW.customer_type, 'walk-in'),
                COALESCE(NEW.discount_amount, 0),
                COALESCE(NEW.tax_amount, 0)
            );
        END IF;
    END IF;

    RETURN NEW;
END;
