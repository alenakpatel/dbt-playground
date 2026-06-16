{{ config(materialized='view') }}

with engagement as (

    select * from {{ ref('mart_course_engagement') }}

),

workload as (

    select
        course_id,
        course_name,
        course_status,
        unique_active_students,
        total_activity_events,
        avg_events_per_student,
        first_activity,
        last_activity,
        date_diff('day',
            cast(first_activity as date),
            cast(last_activity as date))        as active_days,
        case
            when total_activity_events > 1000000  then 'Very High'
            when total_activity_events > 100000   then 'High'
            when total_activity_events > 10000    then 'Medium'
            else 'Low'
        end                                     as workload_tier
    from engagement
    where course_id is not null

)

select * from workload
order by total_activity_events desc