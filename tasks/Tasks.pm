package tasks::Tasks;
use strict;
use warnings FATAL => 'all';
use base 'Exporter';
use BootcampDbConn;
use tasks::TaskQueryProvider;
use BootcampCommons qw(extract_id_from_request_string);
use DDP;

our @EXPORT = qw(
    show_tasks_solutions
    );


sub show_tasks_solutions {
    my ($c, $r) = @_;
    my $r_path = $r->uri->path;
    my $task_id = extract_id_from_request_string($r_path);

    my $processed_template="";
    if (defined($task_id)) {
        my $task_result = fetch_task_data($task_id);

        my $my_path = lib::abs::path(".");
        my $tt_config = {
            INCLUDE_PATH => $my_path
        };
        my $vars = {
            task_result              => $task_result->{'columns'},
            task_result_column_names => $task_result->{'column_names'}
        };
        my $template = Template->new($tt_config, $vars);


        $template->process("task.tt", $vars, \$processed_template) || die $template->error(), "\n";
    }
    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();
    print $c $processed_template;
}

sub fetch_task_data {
    my ($task_no) = @_;
    my $tasks = get_task_descriptors();

    my $task = $tasks->[$task_no];
    if ($task) {
        my $dbh = db_conn();
        print("task no: $task_no, query: ".$task->{'query'});
        my @result = $dbh->selectall_array($task->{'query'});
        my $ret = {
            column_names => $task->{'query_columns'},
            columns      => \@result
        };
        return $ret;
    }
}

1;