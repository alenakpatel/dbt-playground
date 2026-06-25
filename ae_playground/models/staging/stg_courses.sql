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
    where course_name not like '%NSSE%'
      and course_name not like '%[INACTIVE]%'
      and course_name not like '%CLIPBOARD%'
      and course_name not like '%_DELETE%'
      and course_name not like '%Template%'
      and course_name not like '%Sandbox%'
      and course_name not like '%TEST%'
      and course_name not like 'bbtest%'
      and course_name not like '%Empty Site%'

)

select * from renamed