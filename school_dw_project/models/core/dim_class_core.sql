with source as (
    select * from {{ ref('stg_dimclass') }}
)

select
    classid,
    classname,
    classteacherid
from source
