package tasks::Tasks;
use strict;
use warnings FATAL => 'all';
use base 'Exporter';
use BootcampDbConn;
use DDP;

our @EXPORT = qw(
    show_tasks_solutions
    );


sub show_tasks_solutions{
    my ($c, $r) = @_;
    my $task_result = task14();




    my $my_path = lib::abs::path(".");
    my $tt_config = {
        INCLUDE_PATH => $my_path
    };
    my $vars = {
        task_result => $task_result -> {'columns'},
        task_result_column_names => $task_result -> {'column_names'}
    };
    my $template = Template->new($tt_config, $vars);

    my $processed_template;
    $template->process("task.tt", $vars, \$processed_template) || die $template->error(), "\n";


    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();
    print $c $processed_template;
}

sub task1 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select name, surname, mark
                                        from student st");
    my $ret = {
        column_names => ["name", "surname", "mark"],
        columns      => \@result
    };
    return $ret;
}

sub task2 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select st.name, st.surname, st.mark, gr.nomer as group_nomer
                       from student st
                       inner join group_st gr on (st.group_id=gr.id)
                       order by surname");
    my $ret = {
        column_names => ["name", "surname", "mark", "group_nomer"],
        columns      => \@result
    };
    return $ret;
}

sub task3 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select st.name, st.surname, st.birthday, mark, gr.nomer as group_nomer, fa.name as faculty_name
                       from student st
                       inner join group_st gr on (st.group_id = gr.id)
                       inner join sub_faculty fa on (gr.sub_fac_id = fa.id)
                       order by surname, birthday");
    my $ret = {
        column_names => ["name", "surname", "birthday", "mark", "group_nomer", "faculty_name"],
        columns      => \@result
    };
    return $ret;
}

sub task4 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select st.name, st.surname, gr.nomer as group_nomer
                       from student st
                       inner join group_st gr on (st.group_id = gr.id)
                       where st.nationality not like 'Русск%'");
    my $ret = {
        column_names => ["name", "surname","group_nomer"],
        columns      => \@result
    };
    return $ret;
}

sub task5 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select count(1) as student_count
                                        from student");
    my $ret = {
        column_names => ["total student count"],
        columns      => \@result
    };
    return $ret;
}

sub task6 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select count(1) as student_count
                                        from student
                                        where mark = 4");
    my $ret = {
        column_names => ["total student count (with mark = 4)"],
        columns      => \@result
    };
    return $ret;
}

sub task7 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select count(1) as student_count
                                        from student
                                        where mark = 4 and sex='F'");
    my $ret = {
        column_names => ["total female student count (with mark = 4)"],
        columns      => \@result
    };
    return $ret;
}

sub task8 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select mark, sum(1) as student_count
                                        from student
                                        group by mark");
    my $ret = {
        column_names => ["mark", "student count"],
        columns      => \@result
    };
    return $ret;
}
sub task9 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select fa.name, count(1) as profession_count
                                        from sub_faculty fa
                                        inner join profession prof on (fa.id = prof.sub_fac_id)
                                        group by fa.id");
    my $ret = {
        column_names => ["faculty name", "profession count"],
        columns      => \@result
    };
    return $ret;
}

sub task10 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select gr.nomer, avg(st.mark)
                                        from group_st gr
                                        inner join student st on (st.group_id = gr.id) group by gr.id");
    my $ret = {
        column_names => ["group nomer", "avg mark"],
        columns      => \@result
    };
    return $ret;
}

sub task11 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select st.name, st.surname, count(1) as relattives_count
                                        from student st
                                        inner join relative rel on (st.id=rel.stud_id) group by st.id");
    my $ret = {
        column_names => ["name", "surname", "relatives count"],
        columns      => \@result
    };
    return $ret;
}

sub task12 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select st.surname || ' ' || substr(st.name, 1, 1) || '.' as surname_name,
                                        cast( ((julianday(date('now')) - julianday(st.birthday)) / 365) as int) as student_age
                                        from student st");
    my $ret = {
        column_names => ["surname + name", "student age"],
        columns      => \@result
    };
    return $ret;
}

sub task13 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select count(1) as student_count
                                        from student st
                                        where cast( ((julianday(date('now')) - julianday(st.birthday)) / 365) as int) > 32 and mark = 3");
    my $ret = {
        column_names => ["student count (with mark = 3)"],
        columns      => \@result
    };
    return $ret;
}

sub task14 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select name, surname
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
                                        having sum(abroad_visit_fact) = 0;");
    my $ret = {
        column_names => ["name", "surname"],
        columns      => \@result
    };
    return $ret;
}


sub task15 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select group_id, group_nomer, count(1) student_count
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
                                        group by group_id;");
    my $ret = {
        column_names => ["id", "name", "surname"],
        columns      => \@result
    };
    return $ret;
}


1;