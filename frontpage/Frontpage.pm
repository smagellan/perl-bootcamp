package frontpage::Frontpage;

use strict;
use warnings FATAL => 'all';

use File::ShareDir;
use Template;
use Template::Constants qw( :debug );
use BootcampDbConn;
use lib::abs;

use base 'Exporter';
our @EXPORT = qw(
    students_list
);

sub students_list {
    my ($c, $r) = @_;
    my $dbh = db_conn();
    my $sth = $dbh->prepare("select st.id, st.name, st.surname, st.birthday, gr.nomer, st.mark
                                    from student st inner join group_st gr on (st.group_id = gr.id)" );

    $sth->execute() or die $DBI::errstr;

    my $students_hash = $sth->fetchall_hashref("id");
    my @keys = sort { $a cmp $b } keys %$students_hash;
    my @vals = @$students_hash{@keys};

    my $my_path = lib::abs::path(".");
    my $tt_config = {
        INCLUDE_PATH => $my_path
    };
    my $vars = {
        students_list => \@vals
    };
    my $template = Template->new($tt_config, $vars);

    my $processed_template;
    $template->process("frontpage.tt", $vars, \$processed_template) || die $template->error(), "\n";

    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();

    print $c $processed_template;
}

1;
