with source as (
    select * from {{ source('public', 'taughtby') }}
)

select
    employeeid,
    classid,
    subjectid
from source
