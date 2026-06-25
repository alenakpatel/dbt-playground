{{ config(materialized='view') }}

with grades as (

    select * from {{ ref('stg_grades') }}
    where score is not null
      and max_score is not null
      and max_score > 0
      and max_score <= 10000
      and score >= 0

),

courses as (

    select * from {{ ref('stg_courses') }}

),

users as (

    select * from {{ ref('stg_users') }}

),

graded as (

    select
        g.grade_key,
        g.course_key,
        g.user_key,
        g.assignment_title,
        g.score,
        g.max_score,
        round(g.score * 100.0 / nullif(g.max_score, 0), 1)  as grade_pct,
        case
            when g.score = 0
                then 'Zero'
            when g.score * 100.0 / nullif(g.max_score, 0) >= 90
                then 'A'
            when g.score * 100.0 / nullif(g.max_score, 0) >= 80
                then 'B'
            when g.score * 100.0 / nullif(g.max_score, 0) >= 70
                then 'C'
            when g.score * 100.0 / nullif(g.max_score, 0) >= 60
                then 'D'
            else 'F'
        end                                                   as grade_bucket
    from grades g

),

joined as (

    select
        u.user_id,
        u.first_name,
        u.last_name,
        c.course_id,
        c.course_name,
        g.assignment_title,
        g.score,
        g.max_score,
        g.grade_pct,
        g.grade_bucket
    from graded g
    left join courses c
        on g.course_key = c.course_key
    left join users u
        on g.user_key = u.user_key

)

select * from joined