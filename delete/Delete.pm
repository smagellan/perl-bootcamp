package delete::Delete;
use strict;
use warnings FATAL => 'all';


use base 'Exporter';
our @EXPORT = qw(
    delete_student
    );

sub delete_student {
    my ($c, $r) = @_;

    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();
}

1;
