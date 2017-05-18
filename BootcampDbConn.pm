package BootcampDbConn;

use strict;
use warnings FATAL => 'all';


use DBI;
use BootcampSettings;
use base 'Exporter';
our @EXPORT = qw(
    db_conn
);


my $_DB_CONN = undef;
sub db_conn() {
    if (!$_DB_CONN) {
        print("creating sqlite connection\n");
        $_DB_CONN = DBI->connect('dbi:SQLite:dbname=foo.sqlite','','',{AutoCommit=>1,RaiseError=>1,PrintError=>0});
    }
    return $_DB_CONN;
}

1;
