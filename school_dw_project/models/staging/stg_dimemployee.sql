with source as (
    select * from {{ source('public', 'dimemployee') }}
)

select
    employeeid,
    firstname,
    lastname,
    role,
    department,
    phoneno,
    address,
    hiredate,
    supervisorid
from source
