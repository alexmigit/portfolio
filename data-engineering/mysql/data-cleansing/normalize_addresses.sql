-- Normalize Addresses in MySQL
UPDATE customers
SET address = TRIM(UPPER(address)),
    city = TRIM(UPPER(city)),
    state = TRIM(UPPER(state))
WHERE address IS NOT NULL;

