with attendance as (

    select
        fa.studentid,
        ds.firstname,
        ds.lastname,
        fa.termid,
        dt.termname,
        fa.days_present,
        fa.total_days,
        fa.attendance_rate_pct
    from {{ ref('fact_attendance_core') }} fa
    join {{ ref('dim_student_core') }} ds using (studentid)
    join {{ ref('dim_term_core') }} dt using (termid)
    group by fa.studentid, ds.firstname, ds.lastname, fa.termid, dt.termname, fa.days_present,fa.total_days,fa.attendance_rate_pct

)

select
    studentid,
    firstname,
    lastname,
    termid,
    termname,
    days_present,
    total_days,
    attendance_rate_pct
from attendance
order by studentid, termid
