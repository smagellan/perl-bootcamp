#! /usr/bin/perl

use HTTP::Daemon;
use HTTP::Status;
use Settings;

use strict;
use warnings;

sub find_request_handler {
    my ($c, $r) = @_;
    
    my $request_handler;
    if ($r->method eq 'GET' and $r->uri->path eq "/xyzzy") {
        $request_handler = \&send_file_handler;
    } else {
        $request_handler = \&permission_denied_handler;
    }
}

sub send_file_handler {
    my ($c, $r) = @_;
    $c->send_file_response("/tmp/tt");
}


sub permission_denied_handler {
    my ($c, $r) = @_;
    $r->send_error(RC_FORBIDDEN);
}


my $d = HTTP::Daemon->new(LocalPort => HTTP_PORT) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        my $handler = find_request_handler($c, $r);
        $handler->($c,$r);
    }
    $c->close;
    undef($c);
}


