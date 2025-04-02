-- Calculates doctor productivity metrics.

WITH doctor_visits AS (
    SELECT
        doctor_id,
        COUNT(*) AS total_visits,
        AVG(total_charges) AS avg_charge_per_visit,
        SUM(total_charges) AS total_revenue
    FROM {{ ref('int_patient_visits') }}
    GROUP BY doctor_id
)
SELECT
    d.doctor_id,
    d.full_name AS doctor_name,
    v.total_visits,
    v. avg_charge_per_visit,
    v.total_revenue
FROM doctor_visits v
JOIN {{ source('EHR', 'doctors') }} d
    ON v.doctor_id = d.doctor_id;