-- Cleans and standardizes patient data from the EHR system.

WITH source AS (
    SELECT
        patient_id,
        first_name,
        last_name,
        date_of_birth,
        gender,
        last_visit_date,
        insurance_provider,
        diagnosis_code,
        created_at,
        updated_at
    FROM {{ source('EHR', 'patients') }}
)
SELECT
    patient_id,
    UPPER(first_name) AS first_name,
    UPPER(last_name) AS last_name,
    CAST(date_of_birth AS DATE) AS dob,
    gender,
    diagnosis_code,
    insurance_provider,
    last_visit_date,
    created_at,
    updated_at
FROM
    source
WHERE
    patient_id IS NOT NULL;