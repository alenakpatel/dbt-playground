with source as (

    select * from {{ source('blackboard', 'users') }}

),

renamed as (

    select
        pk1          as user_key,
        user_id,
        firstname    as first_name,
        lastname     as last_name,
        email,
        batch_uid,
        {{ decode_status('row_status') }} as status
    from source

)

select * from renamed