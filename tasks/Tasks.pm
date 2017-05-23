package tasks::Tasks;
use strict;
use warnings FATAL => 'all';
use base 'Exporter';
use BootcampDbConn;
use tasks::TaskDataProvider;
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
    my $task_result = defined($task_id) ? fetch_task_data($task_id) : undef;
    my $tt_vars = $task_result ? render_vars_ok($task_result) : render_vars_error("task not found");
    $processed_template = render_template($tt_vars);

    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();
    print $c $processed_template;
}

sub render_vars_error {
    my ($error_message) = @_;
    return {
        task_result              => undef,
        task_result_column_names => undef,
        error_message            => $error_message
    };
}

sub render_vars_ok {
    my ($task_result) = @_;
    return {
        task_result              => $task_result->{'columns'},
        task_result_column_names => $task_result->{'column_names'},
        error_message            => undef
    };
}

sub render_template() {
    my ($tt_vars) = @_;

    my $processed_template;
    my $my_path = lib::abs::path(".");
    my $tt_config = {
        INCLUDE_PATH => $my_path
    };
    my $template = Template->new($tt_config);
    $template->process("task.tt", $tt_vars, \$processed_template) || die $template->error(), "\n";
    return $processed_template;
}

1;