with source as (
    select * from {{ source('public', 'dimstudent') }}
)

select
    studentid,
    firstname,
    lastname,
    gender,
    dateofbirth,
    classid,
    enrollmentdate,
    graduationdate
from source
