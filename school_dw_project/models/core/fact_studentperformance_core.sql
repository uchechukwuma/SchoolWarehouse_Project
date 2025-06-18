with student_performance as (
    select
        fsp.StudentID,
        fsp.termid,
        fsp.SubjectID,
        fsp.GradeID,
        fsp.ScoreObtained,
        gs.GradePoint,
        ds.CreditUnit
    from {{ ref('stg_factstudentperformance') }} fsp
    join {{ ref('stg_dimgradingscale') }} gs on fsp.GradeID = gs.GradeID
    join {{ ref('stg_dimsubject') }} ds on fsp.SubjectID = ds.SubjectID
),

cgpa_calculation as (
    select
        StudentID,
        sum(GradePoint * CreditUnit) as total_weighted_points,
        sum(CreditUnit) as total_credits,
        -- Calculate CGPA: total weighted grade points divided by total credits
        case 
            when sum(CreditUnit) = 0 then null
            else round(sum(GradePoint * CreditUnit) / sum(CreditUnit), 2)
        end as CGPA
    from student_performance
    group by StudentID
)

select
    sp.*,
    c.CGPA
from student_performance sp
left join cgpa_calculation c on sp.StudentID = c.StudentID
