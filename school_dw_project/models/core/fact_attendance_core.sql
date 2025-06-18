WITH attendance AS (
    SELECT * 
    FROM {{ ref('stg_factattendance') }}
),
attendance_summary AS (
    SELECT
        studentid,
        classid,
        termid,
        COUNT(DISTINCT date) AS total_days,
        COUNT(DISTINCT CASE WHEN attendancestatus = 'Present' THEN date END) AS days_present
    FROM attendance
    GROUP BY studentid, termid,classid
)
SELECT
    a.studentid,
    a.classid,
    a.termid,
    a.total_days,
    a.days_present,
    ROUND(
        CASE 
            WHEN a.total_days = 0 THEN 0
            ELSE (a.days_present::NUMERIC / a.total_days) * 100
        END,
    2) AS attendance_rate_pct
FROM attendance_summary a
