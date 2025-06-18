with source as (
    select * from {{ source('public', 'factpayment') }}
)

select
    paymentid,
    studentid,
    termid,
    amountpaid,
    paymentstatus,
    paymentdate
from source
