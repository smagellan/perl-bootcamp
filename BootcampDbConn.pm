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

=pod
    $Id: BootcampDbConn.pm

=head1 NAME

    Модуль-провайдер соединения с БД

=head1 DESCRIPTION

    Инкапсулирует работу по установке соединения с БД. Соединение одно на все приложение и
    создается по необходимости

=head1 SYNOPSIS

    use BootcampDbConn;

    my $dbh = db_conn();

=head1 METHODS

=head2 db_conn()

    Возвращает соеинение c БД

=cut
sub db_conn() {
    if (!$_DB_CONN) {
        print("creating sqlite connection\n");
        $_DB_CONN = DBI->connect('dbi:SQLite:dbname=perl_bootcamp.sqlite','','',{AutoCommit=>1,RaiseError=>1,PrintError=>0});
    }
    return $_DB_CONN;
}

1;
