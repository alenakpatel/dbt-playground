with source as (

    select * from {{ source('blackboard', 'course_main') }}

),

renamed as (

    select
        pk1          as course_key,
        course_id,
        course_name,
        start_date,
        end_date,
        {{ decode_status('row_status') }} as status
    from source

)

select * from renamed