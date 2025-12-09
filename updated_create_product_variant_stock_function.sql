-- Drop existing function versions to resolve overload conflict
DROP FUNCTION IF EXISTS create_product_with_variant_stock(TEXT, UUID, UUID, UUID, JSONB);
DROP FUNCTION IF EXISTS create_product_with_variant_stock(TEXT, UUID, BIGINT, BIGINT, JSONB);

-- Create codes table to store generated item codes
CREATE TABLE IF NOT EXISTS codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    branch_id INTEGER NOT NULL
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_codes_branch_id ON codes(branch_id);
CREATE INDEX IF NOT EXISTS idx_codes_code ON codes(code);

-- Migration to add tt_cat_cd to variants table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'variants'
        AND column_name = 'tt_cat_cd'
    ) THEN
        ALTER TABLE public.variants
        ADD COLUMN tt_cat_cd TEXT;
    END IF;
END;
$$;

-- Migration to add property_ty_cd to variants table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'variants'
        AND column_name = 'property_ty_cd'
    ) THEN
        ALTER TABLE public.variants
        ADD COLUMN property_ty_cd TEXT;
    END IF;
END;
$$;

-- Migration to add room_type_cd to variants table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'variants'
        AND column_name = 'room_type_cd'
    ) THEN
        ALTER TABLE public.variants
        ADD COLUMN room_type_cd TEXT;
    END IF;
END;
$$;

-- Migration to add variant_id to stocks table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'stocks'
        AND column_name = 'variant_id'
    ) THEN
        ALTER TABLE public.stocks
        ADD COLUMN variant_id UUID;
    END IF;
END;
$$;

-- Migration to add current_stock to stocks table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'stocks'
        AND column_name = 'current_stock'
    ) THEN
        ALTER TABLE public.stocks
        ADD COLUMN current_stock NUMERIC;
    END IF;
END;
$$;

-- Migration to add tin to stocks table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'stocks'
        AND column_name = 'tin'
    ) THEN
        ALTER TABLE public.stocks
        ADD COLUMN tin BIGINT;
    END IF;
END;
$$;

-- Migration to add bhf_id to stocks table if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'stocks'
        AND column_name = 'bhf_id'
    ) THEN
        ALTER TABLE public.stocks
        ADD COLUMN bhf_id TEXT;
    END IF;
END;
$$;

-- Helper function to generate item codes following the same format as the Dart implementation
CREATE OR REPLACE FUNCTION generate_item_code(
    p_country_code TEXT,
    p_product_type TEXT,
    p_packaging_unit TEXT,
    p_quantity_unit TEXT,
    p_branch_id INTEGER
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_last_sequence INTEGER := 0;
    v_new_sequence TEXT;
    v_new_item_code TEXT;
    v_last_code TEXT;
BEGIN
    -- Get the most recent item code for this branch
    SELECT code INTO v_last_code
    FROM codes
    WHERE branch_id = p_branch_id
    ORDER BY created_at DESC
    LIMIT 1;

    -- Extract the last sequence number and increment it
    IF v_last_code IS NOT NULL AND LENGTH(v_last_code) >= 7 THEN
        BEGIN
            v_last_sequence := CAST(SUBSTRING(v_last_code FROM LENGTH(v_last_code) - 6) AS INTEGER);
        EXCEPTION
            WHEN INVALID_TEXT_REPRESENTATION THEN
                v_last_sequence := 0;
        END;
    END IF;

    v_new_sequence := LPAD((v_last_sequence + 1)::TEXT, 7, '0');

    -- Construct the new item code
    v_new_item_code := p_country_code || p_product_type || p_packaging_unit || p_quantity_unit || v_new_sequence;

    -- Save the new item code in the codes table
    INSERT INTO codes (code, branch_id, created_at)
    VALUES (v_new_item_code, p_branch_id, NOW());

    RETURN v_new_item_code;
END;
$$;

-- Enhanced Supabase migration function to create product -> variant -> stock with EBM fields and validation
CREATE OR REPLACE FUNCTION create_product_with_variant_stock(
    p_product_name TEXT,
    p_category_id UUID,
    p_business_id BIGINT,
    p_branch_id BIGINT,
    p_variants JSONB  -- Array of variant objects with name, sku, barcode, price, etc.
)
RETURNS TABLE(
    product_id UUID,
    variant_ids UUID[],
    stock_ids UUID[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_id UUID;
    v_variant_id UUID;
    v_stock_id UUID;
    var_record RECORD;
    variant_ids_arr UUID[] := '{}';
    stock_ids_arr UUID[] := '{}';
    required_field_count INTEGER := 0;
    provided_field_count INTEGER := 0;
    generated_item_cd TEXT;
BEGIN
    -- Validation: Check if required parameters are provided
    IF p_product_name IS NULL OR trim(p_product_name) = '' THEN
        RAISE EXCEPTION 'Product name is required';
    END IF;

    IF p_category_id IS NULL THEN
        RAISE EXCEPTION 'Category ID is required';
    END IF;

    IF p_business_id IS NULL THEN
        RAISE EXCEPTION 'Business ID is required';
    END IF;

    IF p_branch_id IS NULL THEN
        RAISE EXCEPTION 'Branch ID is required';
    END IF;

    -- Handle the case where the parameter might be a string containing JSON
    -- If p_variants is a string type in JSONB (meaning it contains a string representation of JSON)
    IF jsonb_typeof(p_variants) = 'string' THEN
        -- Extract the string content and parse it as JSON
        BEGIN
            p_variants := (p_variants #>> '{}')::JSONB;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE EXCEPTION 'Could not parse the string parameter as JSON: %', SQLERRM;
        END;
    END IF;

    -- Now validate that we have a proper JSON array
    IF jsonb_typeof(p_variants) != 'array' OR jsonb_array_length(p_variants) = 0 THEN
        RAISE EXCEPTION 'At least one variant must be provided as a JSON array. Received: % (type: %)', p_variants, jsonb_typeof(p_variants);
    END IF;

    -- Create the product
    INSERT INTO public.products (
        name,
        category_id,
        business_id,
        branch_id
    ) VALUES (
        p_product_name,
        p_category_id,
        p_business_id,
        p_branch_id
    )
    RETURNING id INTO v_product_id;

    -- Loop through variants JSON and create each variant with corresponding stock
    FOR var_record IN SELECT
        COALESCE(x.name, '') AS name,
        COALESCE(x.sku, '') AS sku,
        COALESCE(x.retail_price, 0) AS retail_price,
        COALESCE(x.supply_price, 0) AS supply_price,
        COALESCE(x.quantity, 0) AS variant_quantity,
        x.color,
        COALESCE(x.packaging_unit, 'NT') AS packaging_unit,
        -- Add all EBM fields that can be passed in
        x.item_cd,
        COALESCE(x.isrc_aplcb_yn, 'N') AS isrc_aplcb_yn,
        COALESCE(x.use_yn, 'N') AS use_yn,
        x.tax_ty_cd,
        COALESCE(x.bhf_id, '00') AS bhf_id,
        x.bcd,
        x.tax_name,
        COALESCE(x.tax_percentage, 18.0) AS tax_percentage,
        COALESCE(x.item_cls_cd, '5020230602') AS item_cls_cd,
        COALESCE(x.isrcc_nm, '') AS isrcc_nm,
        COALESCE(x.isrc_rt, 0) AS isrc_rt,
        COALESCE(x.qty_unit_cd, 'U') AS qty_unit_cd,
        COALESCE(x.pkg_unit_cd, 'NT') AS pkg_unit_cd,
        COALESCE(x.pkg, 1) AS pkg,
        COALESCE(x.item_ty_cd, '2') AS item_ty_cd,
        x.modr_nm,
        x.modr_id,
        COALESCE(x.prc, 0) AS prc,
        COALESCE(x.dft_prc, 0) AS dft_prc,
        COALESCE(x.item_seq, 0) AS item_seq,
        x.item_std_nm,
        COALESCE(x.spplr_item_cd, '') AS spplr_item_cd,
        COALESCE(x.spplr_item_cls_cd, '') AS spplr_item_cls_cd,
        COALESCE(x.spplr_item_nm, '') AS spplr_item_nm,
        COALESCE(x.ebm_synced, FALSE) AS ebm_synced,
        x.tt_cat_cd,
        x.property_ty_cd,
        x.room_type_cd,
        COALESCE(x.orgn_nat_cd, 'RW') AS orgn_nat_cd,
        x.item_nm,
        x.regr_nm,
        COALESCE(x.sply_amt, 0) AS sply_amt,
        x.tin,
        COALESCE(x.dc_rt, 0) AS dc_rt,
        x.regr_id,
        x.spplr_nm,
        x.agnt_nm,
        -- Add additional fields from the variant model
        x.add_info,
        x.last_touched,
        COALESCE(x.invc_fcur_amt, 0) AS invc_fcur_amt,
        x.invc_fcur_cd,
        COALESCE(x.invc_fcur_excrt, 0) AS invc_fcur_excrt,
        x.expt_nat_cd,
        x.dcl_no,
        x.task_cd,
        x.dcl_de,
        x.hs_cd,
        x.impt_item_stts_cd,
        x.pchs_stts_cd,
        COALESCE(x.assigned, FALSE) AS assigned,
        COALESCE(x.stock_synchronized, TRUE) AS stock_synchronized,
        COALESCE(x.is_shared, FALSE) AS is_shared,
        COALESCE(x.tot_wt, 0) AS tot_wt,
        COALESCE(x.net_wt, 0) AS net_wt,
        x.isrcc_cd,
        COALESCE(x.isrc_amt, 0) AS isrc_amt,
        COALESCE(x.dc_amt, 0) AS dc_amt,
        COALESCE(x.taxbl_amt, 0) AS taxbl_amt,
        COALESCE(x.tax_amt, 0) AS tax_amt,
        COALESCE(x.tot_amt, 0) AS tot_amt,
        x.expiration_date,
        x.unit,
        x.product_name,
        x.category_id,
        x.category_name
    FROM jsonb_to_recordset(p_variants) AS x(
        name TEXT,
        sku TEXT,
        retail_price DECIMAL,
        supply_price DECIMAL,
        quantity DECIMAL,
        color TEXT,
        packaging_unit TEXT,
        -- Add all EBM fields that can be passed in
        item_cd TEXT,
        isrc_aplcb_yn TEXT,
        use_yn TEXT,
        tax_ty_cd TEXT,
        bhf_id TEXT,
        bcd TEXT,
        tax_name TEXT,
        tax_percentage DECIMAL,
        item_cls_cd TEXT,
        isrcc_nm TEXT,
        isrc_rt DECIMAL,
        qty_unit_cd TEXT,
        pkg_unit_cd TEXT,
        pkg INTEGER,
        item_ty_cd TEXT,
        modr_nm TEXT,
        modr_id TEXT,
        prc DECIMAL,
        dft_prc DECIMAL,
        item_seq INTEGER,
        item_std_nm TEXT,
        spplr_item_cd TEXT,
        spplr_item_cls_cd TEXT,
        spplr_item_nm TEXT,
        ebm_synced BOOLEAN,
        tt_cat_cd TEXT,
        property_ty_cd TEXT,
        room_type_cd TEXT,
        orgn_nat_cd TEXT,
        item_nm TEXT,
        regr_nm TEXT,
        sply_amt DECIMAL,
        tin TEXT,
        dc_rt DECIMAL,
        regr_id TEXT,
        spplr_nm TEXT,
        agnt_nm TEXT,
        -- Add additional fields from the variant model
        add_info TEXT,
        last_touched TIMESTAMP WITH TIME ZONE,
        invc_fcur_amt NUMERIC,
        invc_fcur_cd TEXT,
        invc_fcur_excrt DECIMAL,
        expt_nat_cd TEXT,
        dcl_no TEXT,
        task_cd TEXT,
        dcl_de TEXT,
        hs_cd TEXT,
        impt_item_stts_cd TEXT,
        pchs_stts_cd TEXT,
        assigned BOOLEAN,
        stock_synchronized BOOLEAN,
        is_shared BOOLEAN,
        tot_wt INTEGER,
        net_wt INTEGER,
        isrcc_cd TEXT,
        isrc_amt INTEGER,
        dc_amt DECIMAL,
        taxbl_amt DECIMAL,
        tax_amt DECIMAL,
        tot_amt DECIMAL,
        expiration_date TIMESTAMP WITH TIME ZONE,
        unit TEXT,
        product_name TEXT,
        category_id TEXT,
        category_name TEXT,
        bcd_u TEXT,
        category TEXT
    )
    LOOP
        -- Basic validation for each variant
        IF var_record.name IS NULL OR trim(var_record.name) = '' THEN
            RAISE EXCEPTION 'Variant name is required for each variant';
        END IF;

        -- Additional validation: Ensure tax_ty_cd is provided (required for EBM compliance)
        IF var_record.tax_ty_cd IS NULL OR trim(var_record.tax_ty_cd) = '' THEN
            RAISE EXCEPTION 'tax_ty_cd is required for EBM compliance';
        END IF;

        -- Additional validation: Check that retail_price is valid
        IF var_record.retail_price IS NULL OR var_record.retail_price < 0 THEN
            RAISE EXCEPTION 'retail_price must be a non-negative value';
        END IF;

        -- Additional validation: Check that supply_price is valid
        IF var_record.supply_price IS NULL OR var_record.supply_price < 0 THEN
            RAISE EXCEPTION 'supply_price must be a non-negative value';
        END IF;

        -- Generate item_cd if not provided
        IF var_record.item_cd IS NULL OR var_record.item_cd = '' OR var_record.item_cd = 'null' THEN
            generated_item_cd := generate_item_code(
                p_country_code => COALESCE(var_record.orgn_nat_cd, 'RW'),
                p_product_type => COALESCE(var_record.item_ty_cd, '2'),
                p_packaging_unit => COALESCE(var_record.pkg_unit_cd, 'CT'),
                p_quantity_unit => COALESCE(var_record.qty_unit_cd, 'U'),
                p_branch_id => p_branch_id::integer
            );
        ELSE
            generated_item_cd := var_record.item_cd;
        END IF;

        -- Create variant associated with product with all EBM fields
        INSERT INTO public.variants (
            name,
            sku,
            product_id,
            retail_price,
            supply_price,
            branch_id,
            color,
            pkg_unit_cd,
            -- EBM fields
            item_cd,
            isrc_aplcb_yn,
            use_yn,
            tax_ty_cd,
            bhf_id,
            bcd,
            tax_name,
            tax_percentage,
            item_cls_cd,
            isrcc_nm,
            isrc_rt,
            qty_unit_cd,
            pkg,
            item_ty_cd,
            modr_nm,
            modr_id,
            prc,
            dft_prc,
            item_seq,
            item_std_nm,
            spplr_item_cd,
            spplr_item_cls_cd,
            spplr_item_nm,
            ebm_synced,
            tt_cat_cd,
            property_ty_cd,
            room_type_cd,
            orgn_nat_cd,
            item_nm,
            regr_nm,
            sply_amt,
            tin,
            dc_rt,
            regr_id,
            spplr_nm,
            agnt_nm,
            -- Additional fields
            add_info,
            last_touched,
            invc_fcur_amt,
            invc_fcur_cd,
            invc_fcur_excrt,
            expt_nat_cd,
            dcl_no,
            task_cd,
            dcl_de,
            hs_cd,
            impt_item_stts_cd,
            pchs_stts_cd,
            assigned,
            stock_synchronized,
            is_shared,
            tot_wt,
            net_wt,
            isrcc_cd,
            isrc_amt,
            taxbl_amt,
            tax_amt,
            tot_amt,
            expiration_date,
            unit,
            product_name,
            category_id,
            category_name
        ) VALUES (
            var_record.name,
            var_record.sku,
            v_product_id,
            var_record.retail_price,
            var_record.supply_price,
            p_branch_id,
            var_record.color,
            var_record.packaging_unit,
            -- EBM field values
            generated_item_cd,
            var_record.isrc_aplcb_yn,
            var_record.use_yn,
            var_record.tax_ty_cd,
            var_record.bhf_id,
            var_record.bcd,
            var_record.tax_name,
            var_record.tax_percentage,
            var_record.item_cls_cd,
            var_record.isrcc_nm,
            var_record.isrc_rt,
            var_record.qty_unit_cd,
            var_record.pkg,
            var_record.item_ty_cd,
            var_record.modr_nm,
            var_record.modr_id,
            var_record.prc,
            var_record.dft_prc,
            var_record.item_seq,
            var_record.item_std_nm,
            var_record.spplr_item_cd,
            var_record.spplr_item_cls_cd,
            var_record.spplr_item_nm,
            var_record.ebm_synced,
            var_record.tt_cat_cd,
            var_record.property_ty_cd,
            var_record.room_type_cd,
            var_record.orgn_nat_cd,
            var_record.item_nm,
            var_record.regr_nm,
            var_record.sply_amt,
            NULLIF(var_record.tin, '')::bigint,
            var_record.dc_rt,
            var_record.regr_id,
            var_record.spplr_nm,
            var_record.agnt_nm,
            -- Additional field values
            var_record.add_info,
            COALESCE(var_record.last_touched, NOW()),
            var_record.invc_fcur_amt,
            var_record.invc_fcur_cd,
            var_record.invc_fcur_excrt,
            var_record.expt_nat_cd,
            var_record.dcl_no,
            var_record.task_cd,
            var_record.dcl_de,
            var_record.hs_cd,
            var_record.impt_item_stts_cd,
            var_record.pchs_stts_cd,
            var_record.assigned,
            var_record.stock_synchronized,
            var_record.is_shared,
            var_record.tot_wt,
            var_record.net_wt,
            var_record.isrcc_cd,
            var_record.isrc_amt,
            var_record.taxbl_amt,
            var_record.tax_amt,
            var_record.tot_amt,
            var_record.expiration_date,
            var_record.unit,
            var_record.product_name,
            var_record.category_id,
            var_record.category_name
        )
        RETURNING id INTO v_variant_id;

        -- Add variant id to array
        variant_ids_arr := array_append(variant_ids_arr, v_variant_id);

        -- Create initial stock record for the variant
        IF var_record.variant_quantity > 0 THEN
            INSERT INTO public.stocks (
                variant_id,
                current_stock,
                branch_id,
                tin,
                bhf_id
            ) VALUES (
                v_variant_id,
                var_record.variant_quantity,
                p_branch_id,
                NULLIF(var_record.tin, '')::bigint,
                var_record.bhf_id
            )
            RETURNING id INTO v_stock_id;

            -- Add stock id to array
            stock_ids_arr := array_append(stock_ids_arr, v_stock_id);
        END IF;
    END LOOP;

    -- Return the created IDs
    RETURN QUERY
    SELECT v_product_id, variant_ids_arr, stock_ids_arr;
END;
$$;