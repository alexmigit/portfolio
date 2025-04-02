
WITH financials AS (
    SELECT
        patient_id,
        SUM(total_charges) AS total_billed,
        SUM(total_paid) AS total_paid,
        SUM(total_charges - total_paid) AS outstanding_balance,
        COUNT(*) AS total_visits
    FROM {{ ref('int_patient_visits') }}
    GROUP BY patient_id
)
SELECT
    f.patient_id,
    p.first_name,
    p.last_name,
    p.dob,
    f.total_billed,
    f.total_paid,
    f.outstanding_balance,
    f.total_visits,
    CASE
        WHEN f.outstanding_balance > 0 THEN 'Delinquent'
        ELSE 'Paid'
    END AS payment_status
FROM financials f
JOIN {{ ref('stg_patients') }} p
    ON f.patient_id = p.patient_id;