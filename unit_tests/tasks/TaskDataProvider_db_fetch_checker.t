use strict;
use warnings FATAL => 'all';
use tasks::TaskQueryProvider;
use tasks::TaskDataProvider;
use Test::More tests => get_task_descriptors_count();

my @task_ids = get_task_descriptors_ids();

foreach my $task_id (@task_ids) {
    my $actual_data = fetch_task_data($task_id);
    ok($actual_data, "db fetch ok");
}

1;