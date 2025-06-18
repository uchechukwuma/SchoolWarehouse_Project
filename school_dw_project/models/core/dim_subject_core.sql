with source as (
    select * from {{ ref('stg_dimsubject') }}
)

select
    subjectid,
    subjectname,
    creditunit
from source
