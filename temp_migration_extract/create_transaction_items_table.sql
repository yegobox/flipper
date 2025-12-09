-- Create transaction_items table
CREATE TABLE IF NOT EXISTS transaction_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    quantity_requested BIGINT,
    quantity_approved BIGINT,
    quantity_shipped BIGINT,
    transaction_id UUID,
    variant_id UUID NOT NULL,
    qty NUMERIC(15,2),
    price NUMERIC(15,2),
    discount NUMERIC(15,2),
    remaining_stock NUMERIC(15,2),
    updated_at TIMESTAMPTZ,
    is_refunded BOOLEAN,
    done_with_transaction BOOLEAN,
    active BOOLEAN,
    dc_rt NUMERIC(10,2),
    dc_amt NUMERIC(10,2),
    taxbl_amt NUMERIC(20,2),
    tax_amt NUMERIC(10,2),
    tot_amt NUMERIC(20,2),
    inventory_request_id UUID,
    branch_id UUID,
    stock_id UUID,
    unit_cost NUMERIC(10,2),
    vat_amount NUMERIC(10,2),
    vat_rate NUMERIC(5,2),
    item_total NUMERIC(15,2),
    supply_price_at_sale NUMERIC(10,2),
    stock JSONB,
    tt_cat_cd TEXT DEFAULT 'TT'  -- Initially allow default value
);

-- Add foreign key constraints
ALTER TABLE transaction_items ADD CONSTRAINT fk_transaction_items_transaction FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE;
ALTER TABLE transaction_items ADD CONSTRAINT fk_transaction_items_inventory_request_id FOREIGN KEY (inventory_request_id) REFERENCES stock_requests(id) ON DELETE CASCADE;
ALTER TABLE transaction_items ADD CONSTRAINT fk_transaction_items_stock FOREIGN KEY (stock_id) REFERENCES stocks(id);
ALTER TABLE transaction_items ADD CONSTRAINT transaction_items_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL;

-- Create indexes
CREATE INDEX idx_transaction_items_transaction_id ON transaction_items(transaction_id);
CREATE INDEX idx_transaction_items_variant_id ON transaction_items(variant_id);

-- Enable RLS
ALTER TABLE transaction_items ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Enable read access for all users" ON transaction_items FOR SELECT USING (true);
CREATE POLICY "allow_insert" ON transaction_items FOR INSERT WITH CHECK (true);
CREATE POLICY "allow_update" ON transaction_items FOR UPDATE USING (true);
CREATE POLICY "allow_delete" ON transaction_items FOR DELETE USING (true);