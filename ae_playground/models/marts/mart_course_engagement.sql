{{ config(materialized='view') }}

with activity as (

    select * from {{ ref('stg_activity') }}
    where activity_timestamp >= date_add('month', -{{ var('activity_lookback_months') }}, current_date)

),

courses as (

    select * from {{ ref('stg_courses') }}

),

engagement as (

    select
        c.course_id,
        c.course_name,
        c.status                                        as course_status,
        count(distinct a.user_key)                      as unique_active_students,
        count(a.activity_key)                           as total_activity_events,
        min(a.activity_timestamp)                       as first_activity,
        max(a.activity_timestamp)                       as last_activity,
        count(a.activity_key) * 1.0
            / nullif(count(distinct a.user_key), 0)     as avg_events_per_student
    from activity a
    left join courses c
        on a.course_key = c.course_key
    group by
        c.course_id,
        c.course_name,
        c.status

)

select * from engagement
order by total_activity_events desc