with source as (
    select * from {{ source('public', 'dimgradingscale') }}
)

select
    gradeid,
    minscore,
    maxscore,
    gradeletter,
    gradepoint
from source
