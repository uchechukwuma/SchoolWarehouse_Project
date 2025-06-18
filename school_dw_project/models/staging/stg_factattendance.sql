with source as (
    select * from {{ source('public', 'factattendance') }}
)

select
    attendanceid,
    studentid,
    classid,
    termid,
    date,
    attendancestatus
from source
