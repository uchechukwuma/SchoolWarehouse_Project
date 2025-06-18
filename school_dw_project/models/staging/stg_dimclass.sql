with source as (
    select * from {{ source('public', 'dimclass') }}
)

select
    classid,
    classname,
    classteacherid
from source
