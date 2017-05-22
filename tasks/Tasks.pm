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
    my $task_result = task1();




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
    print "task1 results:\n";
    my $ret = {
        column_names => ["name", "surname", "mark"],
        columns      => \@result
    };
    return $ret;
}

1;