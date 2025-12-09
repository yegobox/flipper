-- Add foreign key constraints to transaction_items table
-- This runs after all referenced tables have been created

-- Add foreign key constraints
DO $$
BEGIN
    -- Add constraint if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_transaction_items_transaction' 
        AND table_name = 'transaction_items'
    ) THEN
        ALTER TABLE transaction_items ADD CONSTRAINT fk_transaction_items_transaction FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_transaction_items_inventory_request_id' 
        AND table_name = 'transaction_items'
    ) THEN
        ALTER TABLE transaction_items ADD CONSTRAINT fk_transaction_items_inventory_request_id FOREIGN KEY (inventory_request_id) REFERENCES stock_requests(id) ON DELETE CASCADE;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_transaction_items_stock' 
        AND table_name = 'transaction_items'
    ) THEN
        ALTER TABLE transaction_items ADD CONSTRAINT fk_transaction_items_stock FOREIGN KEY (stock_id) REFERENCES stocks(id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'transaction_items_branch_id_fkey' 
        AND table_name = 'transaction_items'
    ) THEN
        ALTER TABLE transaction_items ADD CONSTRAINT transaction_items_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL;
    END IF;
END $$;