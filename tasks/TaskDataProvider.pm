package tasks::TaskDataProvider;
use strict;
use warnings FATAL => 'all';
use tasks::TaskQueryProvider;
use BootcampDbConn;

use base 'Exporter';
our @EXPORT = qw(
    fetch_task_data
    );

=pod
    $Id: TaskDataProvider.pm

=head1 NAME

    Вспомогательный модуль для доступа к решениям заданий.

=head1 DESCRIPTION

=head1 SYNOPSIS
=head1 METHODS

=head2 fetch_task_data($task_id)

    Возвращает результаты решения задания с id=$task_id;

=cut
sub fetch_task_data {
    my ($task_id) = @_;
    my $task = get_task_descriptor($task_id);
    my $ret = undef;
    if ($task) {
        my $dbh = db_conn();
        print("task no: $task_id, query: ".$task->{'query'}."\n");
        my @result = $dbh->selectall_array($task->{'query'});
        $ret = {
            column_names => $task->{'query_columns'},
            columns      => \@result
        };
    }
    return $ret;
}

1;