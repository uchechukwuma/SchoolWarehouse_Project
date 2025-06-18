with source as (
    select * from {{ ref('stg_dimterm') }}
)

select
    termid,
    termname,
    academicyear
from source
