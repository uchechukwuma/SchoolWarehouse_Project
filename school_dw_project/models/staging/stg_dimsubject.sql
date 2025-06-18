with source as (
    select * from {{ source('public', 'dimsubject') }}
)

select
    subjectid,
    subjectname,
    creditunit
from source
