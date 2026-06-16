with gradebook_grade as (

    select * from {{ source('blackboard', 'gradebook_grade') }}

),

gradebook_main as (

    select * from {{ source('blackboard', 'gradebook_main') }}

),

course_users as (

    select * from {{ source('blackboard', 'course_users') }}

),

joined as (

    select
        gg.pk1                  as grade_key,
        gm.pk1                  as gradebook_key,
        gm.title                as assignment_title,
        gm.possible             as max_score,
        gg.manual_score         as score,
        gm.crsmain_pk1          as course_key,
        cu.users_pk1            as user_key
    from gradebook_grade gg
    join gradebook_main gm
        on gg.gradebook_main_pk1 = gm.pk1
    join course_users cu
        on gg.course_users_pk1 = cu.pk1

)

select * from joined