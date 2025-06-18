with source as (
    select * from {{ ref('stg_dimgradingscale') }}
)

select
    gradeid,
    minscore,
    maxscore,
    gradeletter,
    gradepoint
from source
