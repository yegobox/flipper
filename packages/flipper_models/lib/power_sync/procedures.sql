CREATE OR REPLACE FUNCTION public.deduct_credits(branch_id INTEGER, amount INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  current_credits INTEGER;  -- Declare a variable to hold the current credits
BEGIN
  -- Lock the row in the credits table AND store the result
  SELECT c.credits INTO current_credits FROM public.credits AS c WHERE c.branch_server_id = deduct_credits.branch_id FOR UPDATE;
  -- Check if the branch has enough credits
  IF current_credits < amount THEN
    RAISE EXCEPTION 'Insufficient credits for branch %', deduct_credits.branch_id;
  END IF;
  -- Deduct the credits
  UPDATE public.credits
  SET credits = credits - amount
  WHERE branch_server_id = deduct_credits.branch_id;
END;
$$;


-- 
CREATE OR REPLACE FUNCTION public.add_credits(branch_id_param UUID, amount_param INT)
RETURNS VOID AS $$
DECLARE
  _row_exists BOOLEAN;
BEGIN
  -- Lock the credits row. Fail fast if it does not exist.
  SELECT TRUE INTO _row_exists
  FROM public.credits
  WHERE branch_id = branch_id_param
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No credits row for branch %', branch_id_param;
  END IF;

  -- Update the credits by adding amount_param
  IF amount_param <= 0 THEN
    RAISE EXCEPTION 'amount_param must be positive, got %', amount_param;
  END IF;
      UPDATE public.credits
      SET credits = credits + amount_param
      WHERE branch_id = branch_id_param;
END;
$$ LANGUAGE plpgsql;
-- Scripts useful

SELECT *
FROM business_analytics
WHERE date::date = CURRENT_DATE and branch_id = 1;

-- end of useful scripts

-- For transation

-- Drop the existing trigger and function if they exist
DROP TRIGGER IF EXISTS transaction_completed_trigger ON transactions;
DROP FUNCTION IF EXISTS insert_business_analytics();

-- Create the function to handle the trigger
CREATE OR REPLACE FUNCTION insert_business_analytics()
RETURNS TRIGGER AS $$
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
                SELECT ti.price * ti.qty AS item_value, 
                       v.item_nm AS item_name, 
                       ti.qty, 
                       v.tax_ty_cd, 
                       ti.price, 
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
                total_profit := total_profit + (transaction_item.price - transaction_item.supply_price) * transaction_item.qty;
                
                -- Accumulate remaining stock from transaction items
                total_stock_remained := total_stock_remained + transaction_item.remaining_stock;
            END LOOP;

            -- Remove the leading comma and space if there are items
            IF item_count > 0 THEN
                item_name_list := substring(item_name_list FROM 3);
                category_name_list := substring(category_name_list FROM 3);
                category_id_list := substring(category_id_list FROM 3);
                average_price := total_price / item_count;
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
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER transaction_completed_trigger
AFTER UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION insert_business_analytics();


