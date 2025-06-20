with performance as (

    select
        fsp.studentid,
        ds.firstname,
        ds.lastname,
        dc.classid,
        fsp.termid,
        dt.termname,
        dt.academicyear,
        fsp.scoreobtained,
        dgs.gradeletter,
        dgs.gradepoint
    from {{ ref('fact_studentperformance_core') }} fsp
    join {{ ref('dim_student_core') }} ds using (studentid)
    join {{ ref('dim_class_core') }} dc using (classid)
    join {{ ref('dim_term_core') }} dt using (termid)
    join {{ ref('dim_gradingscale_core') }} dgs using (gradeid)

),

term_gpa as (

    select
        studentid,
        termid,
        termname,
        academicyear,
        avg(gradepoint) as term_gpa
    from performance
    group by studentid, termid, termname, academicyear

),

cgpa as (

    select
        studentid,
        avg(term_gpa) as cgpa
    from term_gpa
    group by studentid

)

select
    p.studentid,
    p.firstname,
    p.lastname,
    p.classid,
    p.termid,
    p.termname,
    p.academicyear,
    p.scoreobtained,
    p.gradeletter,
    p.gradepoint,
    tg.term_gpa,
    c.cgpa
from performance p
join term_gpa tg
  on p.studentid = tg.studentid and p.termid = tg.termid
join cgpa c
  on p.studentid = c.studentid
order by p.studentid, p.termid
