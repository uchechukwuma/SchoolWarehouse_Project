with source as (
    select * from {{ source('public', 'factstudentperformance') }}
)

select
    performanceid,
    studentid,
    subjectid,
    termid,
    gradeid,
    scoreobtained
from source
