select
    de.employeeid,
    de.firstname,
    de.lastname,
    de.role,
    count(distinct tc.classid) as total_classes,
    count(distinct tc.subjectid) as total_subjects
from {{ ref('dim_employee_core') }} de
join {{ ref('taughtby_core') }} tc using (employeeid)
group by de.employeeid, de.firstname, de.lastname, de.role
order by de.employeeid
