package frontpage::Frontpage;

use strict;
use warnings;

use File::ShareDir;
use Template;
use Template::Constants qw( :debug );
use BootcampDbConn;
use DDP;
use lib::abs;

use base 'Exporter';
our @EXPORT = qw(
    students_list
);

sub students_list {
    my ($c, $r) = @_;
    my $dbh = db_conn();
    my $sth = $dbh->prepare( "select * from student order by id desc;" );

    my $rv = $sth->execute() or die $DBI::errstr;
    if($rv < 0){
        print $DBI::errstr;
    }

    my $students_hash = $sth->fetchall_hashref("id");
    my @keys = sort { $a cmp $b } keys %$students_hash;
    my @vals = @$students_hash{@keys};

    my $tt_config = {
    };
    my $vars = {
        students_list => \@vals
    };
    my $template = Template->new($tt_config, $vars);

    my $processed_template;
    $template->process("frontpage/frontpage.tt", $vars, \$processed_template) || die $template->error(), "\n";;

    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();

    print $c $processed_template;
}

1;
