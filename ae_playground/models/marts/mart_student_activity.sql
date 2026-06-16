{{ config(materialized='view') }}

with users as (

    select * from {{ ref('stg_users') }}

),

courses as (

    select * from {{ ref('stg_courses') }}

),

activity as (

    select * from {{ ref('stg_activity') }}
    where activity_timestamp >= date_add('month', -{{ var('activity_lookback_months') }}, current_date)

),

joined as (

    select
        u.user_id,
        u.first_name,
        u.last_name,
        c.course_id,
        c.course_name,
        count(a.activity_key)     as total_activity_events,
        min(a.activity_timestamp) as first_activity,
        max(a.activity_timestamp) as last_activity
    from activity a
    left join users u
        on a.user_key = u.user_key
    left join courses c
        on a.course_key = c.course_key
    group by
        u.user_id,
        u.first_name,
        u.last_name,
        c.course_id,
        c.course_name

)

select * from joined