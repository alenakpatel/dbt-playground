with source as (

    select * from {{ source('blackboard', 'telem_activity_summary') }}

),

renamed as (

    select
        pk1                          as timing_key,
        course_user_pk1              as course_user_key,
        gradebook_main_pk1           as gradebook_key,
        first_opened_time,
        last_opened_time,
        started_time,
        first_draft_saved_time,
        last_draft_saved_time,
        date_diff('second', first_opened_time, started_time)        as seconds_open_before_start,
        date_diff('second', started_time, last_draft_saved_time)    as seconds_actively_working
    from source
    where first_opened_time is not null
      and started_time is not null

)

select * from renamed