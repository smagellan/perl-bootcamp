package tasks::TaskDataProvider;
use strict;
use warnings FATAL => 'all';
use tasks::TaskQueryProvider;
use BootcampDbConn;

use base 'Exporter';
our @EXPORT = qw(
    fetch_task_data
    );


sub fetch_task_data {
    my ($task_no) = @_;
    my $task = get_task_descriptor($task_no);
    my $ret = undef;
    if ($task) {
        my $dbh = db_conn();
        print("task no: $task_no, query: ".$task->{'query'});
        my @result = $dbh->selectall_array($task->{'query'});
        $ret = {
            column_names => $task->{'query_columns'},
            columns      => \@result
        };
    }
    return $ret;
}

1;