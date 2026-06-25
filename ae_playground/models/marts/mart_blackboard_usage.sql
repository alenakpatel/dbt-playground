{{ config(materialized='view') }}

with courses as (

    select * from {{ ref('stg_courses') }}

),

content as (

    select * from {{ ref('stg_course_content') }}

),

engagement as (

    select * from {{ ref('mart_course_engagement') }}

),

content_counts as (

    select
        course_key,
        count(content_key)    as content_item_count
    from content
    group by course_key

),

joined as (

    select
        c.course_id,
        c.course_name,
        coalesce(cc.content_item_count, 0)   as content_item_count,
        e.unique_active_students,
        e.total_activity_events,
        e.avg_events_per_student,
        case
            when coalesce(cc.content_item_count, 0) = 0
                then 'No Blackboard Content'
            when cc.content_item_count < 10
                then 'Minimal Use'
            when cc.content_item_count < 100
                then 'Moderate Use'
            else 'Active Use'
        end                                   as blackboard_usage_tier
    from courses c
    left join content_counts cc
        on c.course_key = cc.course_key
    left join engagement e
        on c.course_id = e.course_id

)

select * from joined