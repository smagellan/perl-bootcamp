package tasks::TaskQueryProvider;
use strict;
use warnings FATAL => 'all';

use base 'Exporter';
our @EXPORT = qw(
        get_task_descriptor
        get_task_descriptors_ids
        get_task_descriptors_count
    );


our @TASK_LIST = (
    {
        description => "1. Выбрать имя, фамилию, оценку для каждого студента.",
        query => "select name, surname, mark
                                        from student st",
        query_columns => ["name", "surname", "mark"]
    },
    {
        description => "2. Выбрать имя, фамилию, оценку, номер группы для каждого студента. Сортировка по фамилии.",
        query => "select st.name, st.surname, st.mark, gr.nomer as group_nomer
                       from student st
                       inner join group_st gr on (st.group_id=gr.id)
                       order by surname",
        query_columns => ["name", "surname", "mark", "group_nomer"]
    },
    {
        description => "3. Выбрать имя, фамилию, дату рождения, оценку, номер группы,
                        номер и название кафедры для каждого студента. Сортировка по фамилии и дате рождения (2мя способами",
        query => "select st.name, st.surname, st.birthday, mark, gr.nomer as group_nomer, fa.name as faculty_name
                       from student st
                       inner join group_st gr on (st.group_id = gr.id)
                       inner join sub_faculty fa on (gr.sub_fac_id = fa.id)
                       order by surname, birthday",
        query_columns => ["name", "surname", "birthday", "mark", "group_nomer", "faculty_name"]
    },
    {
        description => "4. Выбрать имя, фамилию и номер группы иностранных студентов.",
        query => "select st.name, st.surname, gr.nomer as group_nomer
                       from student st
                       inner join group_st gr on (st.group_id = gr.id)
                       where st.nationality not like 'Русск%'",
        query_columns => ["name", "surname","group_nomer"]
    },
    {
        description => "5. Посчитать количество студентов.",
        query => "select count(1) as student_count
                                        from student",
        query_columns =>  ["total student count"]
    },
    {
        description => "6. Посчитать количество всех студентов, у которых оценка 4.",
        query => "select count(1) as student_count
                                        from student
                                        where mark = 4",
        query_columns => ["total student count (with mark = 4)"]
    },
    {
        description => "7. Посчитать количество студенток, у которых оценка 4.",
        query => "select count(1) as student_count
                                        from student
                                        where mark = 4 and sex='F'",
        query_columns => ["total female student count (with mark = 4)"]
    },
    {
        description => "8. Выбрать оценки и количество студентов, получивших данные оценки.",
        query => "select mark, sum(1) as student_count
                                        from student
                                        group by mark",
        query_columns => ["mark", "student count"]
    },
    {
        description => "9. Вывести название кафедр и количество специальностей для каждой кафедры.",
        query => "select fa.name, count(1) as profession_count
                                        from sub_faculty fa
                                        inner join profession prof on (fa.id = prof.sub_fac_id)
                                        group by fa.id",
        query_columns => ["faculty name", "profession count"]
    },
    {
        description => "10. Вывести среднюю оценку в каждой группе.",
        query => "select gr.nomer, avg(st.mark)
                                        from group_st gr
                                        inner join student st on (st.group_id = gr.id) group by gr.id",
        query_columns => ["group nomer", "avg mark"]
    },
    {
        description => "11. Посчитать родственников для каждого студента.",
        query => "select st.name, st.surname, count(1) as relattives_count
                                        from student st
                                        inner join relative rel on (st.id=rel.stud_id) group by st.id",
        query_columns => ["name", "surname", "relatives count"]
    },
    {
        description => "12. Вычислить возраст для каждого студента. Вывести фамилию и имя студента в формате «Иванов И.» и соответствующий ему возраст.",
        query => "select st.surname || ' ' || substr(st.name, 1, 1) || '.' as surname_name,
                                        cast( ((julianday(date('now')) - julianday(st.birthday)) / 365) as int) as student_age
                                        from student st",
        query_columns => ["surname + name", "student age"]
    },
    {
        description => "13. Посчитать количество всех студентов старше 22 лет, у которых оценка 3.",
        query => "select count(1) as student_count
                                        from student st
                                        where cast( ((julianday(date('now')) - julianday(st.birthday)) / 365) as int) > 22 and mark = 3",
        query_columns => ["student count (older than 22 years with mark = 3)"]
    },
    {
        description => "14. Выбрать студентов, у которых родственники не выезжали за границу.",
        query => "select name, surname
                                        from
                                             (select st.id, st.name, st.surname,
                                                     case when abr.country is NULL then 0
                                                         else 1
                                                     end abroad_visit_fact
                                              from student st
                                              inner join relative rel on (st.id=rel.stud_id)
                                              left outer join abroad abr on (abr.rel_id=rel.id)
                                             ) t1
                                        group by id
                                        having sum(abroad_visit_fact) = 0;",
        query_columns => ["name", "surname"]
    },
    {
        description => "15. Посчитать студентов в каждой группе, у которых родственники не выезжали за границу.",
        query => "select group_id, group_nomer, count(1) student_count
                                        from
                                             (select st.id, st.name, st.surname, gr.id as group_id, gr.nomer as group_nomer,
                                                     case when abr.country is NULL then 0
                                                          else 1
                                                     end abroad_visit_fact
                                              from student st
                                              inner join group_st gr on (gr.id=st.group_id)
                                              inner join relative rel on (st.id=rel.stud_id)
                                              left outer join abroad abr on (abr.rel_id=rel.id)
                                              group by st.id
                                              having sum(abroad_visit_fact) = 0
                                             ) t1
                                        group by group_id;",
        query_columns => ["id", "name", "surname"]
    }
);

sub get_task_descriptor {
    my ($task_id) = @_;
    return $TASK_LIST[$task_id - 1];
}

sub get_task_descriptors_count{
    return scalar @TASK_LIST;
}

sub get_task_descriptors_ids {
    return 1..scalar @TASK_LIST;
}

1;