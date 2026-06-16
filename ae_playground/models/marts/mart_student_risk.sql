{{ config(materialized='view') }}

with activity as (

    select * from {{ ref('stg_activity') }}
    where activity_timestamp >= date_add('month', -{{ var('activity_lookback_months') }}, current_date)

),

grades as (

    select * from {{ ref('stg_grades') }}

),

users as (

    select * from {{ ref('stg_users') }}

),

courses as (

    select * from {{ ref('stg_courses') }}

),

activity_summary as (

    select
        user_key,
        course_key,
        count(activity_key)             as total_activity_events,
        max(activity_timestamp)         as last_active
    from activity
    where user_key is not null
    group by user_key, course_key

),

grade_summary as (

    select
        user_key,
        course_key,
        avg(score)                      as avg_score,
        avg(max_score)                  as avg_max_score,
        count(grade_key)                as total_graded_items
    from grades
    where score is not null
      and max_score is not null
      and max_score > 0
    group by user_key, course_key

),

joined as (

    select
        u.user_id,
        u.first_name,
        u.last_name,
        c.course_id,
        c.course_name,
        a.total_activity_events,
        a.last_active,
        g.avg_score,
        g.avg_max_score,
        g.total_graded_items,
        round(g.avg_score * 100.0 / nullif(g.avg_max_score, 0), 1)  as grade_pct
    from activity_summary a
    left join users u
        on a.user_key = u.user_key
    left join courses c
        on a.course_key = c.course_key
    left join grade_summary g
        on a.user_key = g.user_key
        and a.course_key = g.course_key
    where u.user_id is not null

),

risk_flagged as (

    select
        *,
        case
            when total_activity_events >= 50
             and grade_pct < 70
            then 'High Risk'
            when total_activity_events >= 20
             and grade_pct < 80
            then 'Medium Risk'
            else 'On Track'
        end                             as risk_level
    from joined

)

select * from risk_flagged
order by grade_pct asc
