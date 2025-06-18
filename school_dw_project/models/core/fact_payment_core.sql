with payments as (
    select * from {{ ref('stg_factpayment') }}
)

select
    PaymentID,
    StudentID,
    TermID,
    AmountPaid,
    PaymentStatus,
    PaymentDate,

    case 
        when PaymentStatus != 'Paid' and PaymentDate < current_date then true
        else false
    end as is_overdue

from payments
