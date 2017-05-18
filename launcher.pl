#! /usr/bin/perl

use HTTP::Daemon;
use HTTP::Status;
use HTTP::Response;
use Data::Printer;

use FindBin;
use lib $FindBin::Bin;

use BootcampSettings;
use BootcampDbConn;
use frontpage::Frontpage;

use strict;
use warnings;

sub find_request_handler {
    my ($c, $r) = @_;
    
    my $request_handler;
    if ($r->method eq 'GET' and $r->uri->path eq "/") {
        $request_handler = \&students_list;
    } else {
        $request_handler = \&permission_denied_handler;
    }
    return $request_handler;
}

sub permission_denied_handler {
    my ($c, $r) = @_;
    $c->send_error(RC_FORBIDDEN);
}

my $d = HTTP::Daemon->new(LocalPort => HTTP_PORT, ReuseAddr => 1) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my $c = $d->accept) {
    if (my $r = $c->get_request) {
        my $handler = find_request_handler($c, $r);
        $handler->($c, $r);

        $c->close();
        undef($c);
    } else {
        print(STDERR "can't acquire request, reason: ", $c->reason());
    }
}


