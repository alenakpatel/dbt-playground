with source as (

    select * from {{ source('blackboard', 'course_contents') }}

),

renamed as (

    select
        pk1              as content_key,
        crsmain_pk1       as course_key,
        content_type,
        title,
        dtcreated         as date_created,
        dtmodified        as date_modified
    from source

)

select * from renamed