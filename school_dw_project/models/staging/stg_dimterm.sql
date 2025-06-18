with source as (
    select * from {{ source('public', 'dimterm') }}
)

select
    termid,
    termname,
    academicyear
from source
