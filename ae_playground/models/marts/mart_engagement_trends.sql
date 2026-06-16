{{ config(materialized='view') }}

with activity as (

    select * from {{ ref('stg_activity') }}
    where activity_timestamp >= timestamp '2026-01-01 00:00:00'
      and activity_timestamp < timestamp '2026-05-15 00:00:00'
      and user_key is not null
      and course_key is not null

),

courses as (

    select * from {{ ref('stg_courses') }}

),

weekly as (

    select
        c.course_id,
        c.course_name,
        date_trunc('week', a.activity_timestamp)    as week_start,
        count(distinct a.user_key)                  as unique_students,
        count(a.activity_key)                       as total_events
    from activity a
    left join courses c
        on a.course_key = c.course_key
    where c.course_id is not null
    group by
        c.course_id,
        c.course_name,
        date_trunc('week', a.activity_timestamp)

)

select * from weekly
order by course_id, week_start