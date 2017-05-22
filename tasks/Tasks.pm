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
    my $task_result = task5();




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
    my @result = $dbh->selectall_array("select name, surname, mark from student st");
    my $ret = {
        column_names => ["name", "surname", "mark"],
        columns      => \@result
    };
    return $ret;
}

sub task2 {
    my $dbh = db_conn();
    my @result = $dbh->selectall_array("select st.name, st.surname, st.mark, gr.nomer as group_nomer
                       from student st inner join group_st gr on (st.group_id=gr.id)
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
    my @result = $dbh->selectall_array("select count(1) as student_count from student");
    my $ret = {
        column_names => ["student_count"],
        columns      => \@result
    };
    return $ret;
}

1;