-- Incremental ETL Script
DECLARE @LastUpdatedDate DATETIME = (SELECT MAX(last_updated) FROM staging.sales_data);

-- Load new data
INSERT INTO staging.sales_data (sale_id, customer_id, product_id, amount, sale_date, last_updated)
SELECT sale_id, customer_id, product_id, amount, sale_date, last_updated
FROM source.sales_data
WHERE last_updated > @LastUpdatedDate;

-- Merge data into final table
MERGE final.sales_data AS target
USING staging.sales_data AS source
ON target.sale_id = source.sale_id
WHEN MATCHED THEN
    UPDATE SET 
        target.amount = source.amount,
        target.sale_date = source.sale_date
WHEN NOT MATCHED THEN
    INSERT (sale_id, customer_id, product_id, amount, sale_date)
    VALUES (source.sale_id, source.customer_id, source.product_id, source.amount, source.sale_date);

