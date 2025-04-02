WITH visits AS (
    SELECT
        v.patient_id,
        p.first_name,
        p.last_name,
        p.dob,
        v.visit_date,
        v.reason_for_visit,
        v.total_charges,
        v.total_paid,
        v.doctor_id
    FROM {{ ref('stg_patients') }} p
    JOIN {{ source('EHR', 'visits') }} v
        ON p.patient_id = v.patient_id
)
SELECT
    patient_id,
    first_name,
    last_name,
    dob,
    visit_date,
    reason_for_visit,
    total_charges,
    total_paid
    doctor_id
    total_charges - total_paid AS outstanding_balance
FROM
    visits;