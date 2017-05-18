package add::Add;
use strict;
use warnings FATAL => 'all';

use base 'Exporter';
our @EXPORT = qw(
    add_student
    );

sub add_student {
    my ($c, $r) = @_;

    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();
}
1;
