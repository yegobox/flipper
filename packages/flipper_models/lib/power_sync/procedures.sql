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
CREATE OR REPLACE FUNCTION public.add_credits(branch_id_param INT, amount_param INT)
RETURNS VOID AS $$
DECLARE
  _row_exists BOOLEAN;
BEGIN
  -- Lock the credits row. Fail fast if it does not exist.
  SELECT TRUE INTO _row_exists
  FROM public.business_credits
  WHERE branch_id = branch_id_param
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No business_credits row for branch %', branch_id_param;
  END IF;

  -- Update the balance by adding amount_param
  IF amount_param <= 0 THEN
    RAISE EXCEPTION 'amount_param must be positive, got %', amount_param;
  END IF;
  UPDATE public.business_credits
  SET balance = balance + amount_param
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
    category_name_list TEXT := ''; -- Stores category names
    category_id_list TEXT := '';   -- Stores category IDs
    item_count INT := 0;
    total_profit NUMERIC := 0;
    total_price NUMERIC := 0;
    average_price NUMERIC := 0;
    total_quantity INT := 0;
    transaction_item RECORD;
BEGIN
    -- Check if the status is updated to 'completed'
    IF NEW.status = 'completed' AND OLD.status IS DISTINCT FROM NEW.status THEN
        -- Calculate the total value and concatenate item names
        FOR transaction_item IN
            SELECT ti.price * ti.qty AS item_value, 
                   v.item_nm AS item_name, 
                   ti.qty, 
                   v.tax_ty_cd, 
                   ti.price, 
                   v.category_name,  -- ✅ Fetch category_name from variants
                   v.category_id,     -- ✅ Fetch category_id from variants
                   v.supply_price    -- ✅ Fetch supply_price from variants
            FROM transaction_items ti
            JOIN variants v ON ti.variant_id = v.id  -- ✅ Ensure v is from variants
            WHERE ti.transaction_id = NEW.id
        LOOP
            total_value := total_value + transaction_item.item_value;
            item_name_list := item_name_list || ', ' || transaction_item.item_name;
            category_name_list := category_name_list || ', ' || transaction_item.category_name;
            category_id_list := category_id_list || ', ' || transaction_item.category_id;
            item_count := item_count + 1;
            total_price := total_price + transaction_item.price;
            total_quantity := total_quantity + transaction_item.qty;

            -- Calculate profit based on selling price and supply price
            total_profit := total_profit + (transaction_item.price - transaction_item.supply_price) * transaction_item.qty;
        END LOOP;

        -- Remove the leading comma and space if there are items
        IF item_count > 0 THEN
            item_name_list := substring(item_name_list FROM 3);
            category_name_list := substring(category_name_list FROM 3);
            category_id_list := substring(category_id_list FROM 3);
            average_price := total_price / item_count;
        END IF;

        -- Insert into business_analytics
        INSERT INTO business_analytics (date, value, item_name, category_name, category_id, units_sold, traffic_count, tax_rate, price, profit, branch_id)
        VALUES (
            now(),
            total_value,
            item_name_list,
            category_name_list,  -- ✅ Correct category_name
            category_id_list,    -- ✅ Correct category_id
            total_quantity,
            total_quantity,
            0.18,
            average_price,
            total_profit,
            NEW.branch_id
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER transaction_completed_trigger
AFTER UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION insert_business_analytics();


