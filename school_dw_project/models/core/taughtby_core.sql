with source as (
    select * from {{ ref('stg_taughtby') }}
)

select
    employeeid,
    classid,
    subjectid
from source
