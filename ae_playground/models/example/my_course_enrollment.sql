create table iceberg.pond_alenakp.my_course_enrollments AS
select distinct u.firstname, u.lastname, cm.course_name, cm.course_id, cu.role, cu.pk1
from iceberg.blackboard_xform.course_users cu
join iceberg.blackboard_xform.users u on cu.users_pk1 = u.pk1
join iceberg.blackboard_xform.course_main cm on cu.crsmain_pk1 = cm.pk1 
where cu.users_pk1 = 599031