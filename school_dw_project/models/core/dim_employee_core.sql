with base as (
    select * from {{ ref('stg_dimemployee') }}
)

select
    EmployeeID,
    FirstName,
    LastName,
    Role,
    Department,
    PhoneNo,
    Address,
    HireDate,
    SupervisorID,

    -- Calculate tenure in years (rounded down)
    date_part('year', age(current_date, HireDate)) as tenure_years

from base
