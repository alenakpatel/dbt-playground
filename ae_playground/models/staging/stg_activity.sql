with source as (

    select * from {{ source('blackboard', 'activity_accumulator') }}

),

renamed as (

    select
        pk1                as activity_key,
        user_pk1           as user_key,
        course_pk1         as course_key,
        event_type,
        timestamp          as activity_timestamp
    from source

)

select * from renamed