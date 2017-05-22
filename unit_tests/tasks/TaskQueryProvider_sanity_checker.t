use strict;
use warnings FATAL => 'all';
use tasks::TaskQueryProvider;
use Test::More tests => get_task_descriptors_count() * 3;

my @descriptors = @{get_task_descriptors()};

foreach my $task_descriptor (@descriptors) {
    ok($task_descriptor->{'description'}, 'descriptor has "description" field');
    ok($task_descriptor->{'query'}, 'descriptor has "query" field');
    ok($task_descriptor->{'query_columns'}, 'descriptor has "query_columns" field');
}

1;