-- OBSERVED ERROR IN THE GRADE MAPPING FROM THE DATA GENERATED USING PYTHON SCRIPT - Remapping of grades was done here in dbt to provide corrected values

with performance as (
    select
        performanceid,
        studentid,
        subjectid,
        termid,
        scoreobtained
    from {{ ref('stg_factstudentperformance') }}
),

grading as (
    -- Join to grading scale to recalculate correct grade based on scoreobtained
    select
        p.performanceid,
        p.studentid,
        p.subjectid,
        p.termid,
        p.scoreobtained,
        g.gradeid as correct_gradeid,
        g.gradeletter as correct_gradeletter,
        g.gradepoint as correct_gradepoint
    from performance p
    join {{ ref('stg_dimgradingscale') }} g
        on p.scoreobtained between g.minscore and g.maxscore
),

subject_info as (
    -- Bring in subject credit units
    select
        subjectid,
        creditunit
    from {{ ref('stg_dimsubject') }}
),

student_performance as (
    select
        g.studentid,
        g.termid,
        g.subjectid,
        g.correct_gradeid as gradeid,
        g.scoreobtained,
        g.correct_gradeletter,
        g.correct_gradepoint,
        s.creditunit
    from grading g
    join subject_info s
        on g.subjectid = s.subjectid
),

cgpa_calculation as (
    select
        studentid,
        sum(correct_gradepoint * creditunit) as total_weighted_points,
        sum(creditunit) as total_credits,
        case
            when sum(creditunit) = 0 then null
            else round(sum(correct_gradepoint * creditunit) / sum(creditunit), 2)
        end as cgpa
    from student_performance
    group by studentid
)

select
    sp.*,
    cg.cgpa
from student_performance sp
left join cgpa_calculation cg
    on sp.studentid = cg.studentid
