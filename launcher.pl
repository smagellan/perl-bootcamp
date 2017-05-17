#! /usr/bin/perl

use HTTP::Daemon;
use HTTP::Status;
use HTTP::Response;
use Settings;
use DBI;
use Data::Printer;

use strict;
use warnings;

sub find_request_handler {
    my ($c, $r) = @_;
    
    my $request_handler;
    if ($r->method eq 'GET' and $r->uri->path eq "/xyzzy") {
        $request_handler = \&send_file_handler;
    } else {
        if ($r->method eq 'GET' and $r->uri->path eq "/") {
            $request_handler = \&students_list;
        } else {
            $request_handler = \&permission_denied_handler;
        }
    }
    return $request_handler;
}

sub send_file_handler {
    my ($c, $r) = @_;
    $c->send_file_response("/tmp/tt");
}


sub permission_denied_handler {
    my ($c, $r) = @_;
    $r->send_error(RC_FORBIDDEN);
}



sub students_list {
    my ($c, $r) = @_;
    my $dbh = db_conn();
    my $sth = $dbh->prepare( "select * from student;" );
    
    my $rv = $sth->execute() or die $DBI::errstr;
    if($rv < 0){
        print $DBI::errstr;
    }

    $c->send_basic_header(200);
    print $c "Content-Type: text/plain";
    $c->send_crlf;
    $c->send_crlf;
    while(my @row = $sth->fetchrow_array()) {
	$c->print("got row\n");
    }
}


my $DB_CONN = undef;
sub db_conn() {
    if (!$DB_CONN) {
        print("creating sqlite connection\n");
        $DB_CONN = DBI->connect('dbi:SQLite:dbname=foo.sqlite','','',{AutoCommit=>1,RaiseError=>1,PrintError=>0});
    }
    return $DB_CONN;
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


