#! /usr/bin/perl

use HTTP::Daemon;
use HTTP::Status;
use HTTP::Response;
use Data::Printer;

use FindBin;
use lib $FindBin::Bin;

use B qw(svref_2object);
use BootcampSettings;
use BootcampDbConn;
use frontpage::Frontpage;
use edit::Edit;
use delete::Delete;
use add::Add;
use tasks::Tasks;

use strict;
use warnings FATAL => 'all';

sub find_request_handler {
    my ($c, $r) = @_;
    
    my $request_handler;
    my $r_path = $r->uri->path;
    if ($r->method eq 'GET' and $r_path eq "/") {
        $request_handler = \&students_list;
    } else {
        if ($r_path =~ /^\/add(\/|$)/) {
            $request_handler = \&add_student;
        } else {
            if ($r_path =~ /^\/edit(\/|$)/) {
                $request_handler = \&edit_student;
            } else {
                if ($r_path =~ /^\/delete(\/|$)/) {
                    $request_handler = \&delete_student;
                } else {
                    if ($r_path =~ /^\/tasks(\/|$)/) {
                        $request_handler = \&show_tasks_solutions;
                    } else {
                        $request_handler = \&permission_denied_handler;
                    }
                }
            }
        }
    }
    return $request_handler;
}

sub permission_denied_handler {
    my ($c, $r) = @_;
    $c->send_error(RC_FORBIDDEN);
}

my $d = HTTP::Daemon->new(LocalPort => HTTP_PORT, ReuseAddr => 1) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my $c = $d->accept() ) {
    if (my $r = $c->get_request() ) {
        my $handler = find_request_handler($c, $r);

        my $cv = svref_2object ( $handler );
        my $gv = $cv->GV;
        print "handler: " . $gv->NAME . "\n";

        $handler->($c, $r);

        $c->close();
        undef($c);
    } else {
        print(STDERR "can't acquire request, reason: ", $c->reason());
    }
}


