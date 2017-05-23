use strict;
use warnings FATAL => 'all';
use tasks::TaskQueryProvider;
use Test::More tests => get_task_descriptors_count() * 3;

my @task_ids = get_task_descriptors_ids();

foreach my $task_id (@task_ids) {
    my $task_descriptor = get_task_descriptor($task_id);
    ok($task_descriptor->{'description'}, 'descriptor has "description" field');
    ok($task_descriptor->{'query'}, 'descriptor has "query" field');
    ok($task_descriptor->{'query_columns'}, 'descriptor has "query_columns" field');
}

1;