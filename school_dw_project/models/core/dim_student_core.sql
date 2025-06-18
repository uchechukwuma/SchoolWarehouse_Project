with base as (
    select * from {{ ref('stg_dimstudent') }}
)

select
    StudentID,
    FirstName,
    LastName,
    Gender,
    DateOfBirth,
    ClassID,
    EnrollmentDate,
    GraduationDate,

    -- Calculate age in years (rounded down)
    date_part('year', age(current_date, DateOfBirth)) as age_years

from base
