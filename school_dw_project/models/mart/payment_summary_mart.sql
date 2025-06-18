select
    fp.studentid,
    ds.firstname,
    ds.lastname,
    fp.termid,
    dt.termname,
    sum(fp.amountpaid) as total_amount_paid,
    bool_or(fp.paymentstatus = 'Unpaid') as has_unpaid,
    bool_or(fp.paymentstatus = 'Partial') as has_partial,
    bool_or(fp.paymentstatus = 'Paid') as has_paid
from {{ ref('fact_payment_core') }} fp
join {{ ref('dim_student_core') }} ds using (studentid)
join {{ ref('dim_term_core') }} dt using (termid)
group by fp.studentid, ds.firstname, ds.lastname, fp.termid, dt.termname
order by fp.studentid, fp.termid
