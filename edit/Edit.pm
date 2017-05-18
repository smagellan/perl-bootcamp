package edit::Edit;

use strict;
use warnings FATAL => 'all';

use BootcampDbConn;
use base 'Exporter';
our @EXPORT = qw(
    edit_student
    );

sub edit_student {
    my ($c, $r) = @_;
    my $dbh = db_conn();
    my $student_id = 100;
    my $sth = $dbh->prepare("select st.id, st.name, st.surname, st.sex, st.nationality, st.address, st.birthday, st.mark, gr.id as group_id, gr.nomer
                                    from student st inner join group_st gr on (st.group_id = gr.id)
                             where st.id=$student_id" );

    my $rv = $sth->execute() or die $DBI::errstr;
    if($rv < 0){
        print $DBI::errstr;
    }

    my $student_fields = $sth->fetchrow_hashref();

    my $my_path = lib::abs::path(".");
    my $tt_config = {
        INCLUDE_PATH => $my_path
    };
    my $vars = {
        student => $student_fields
    };
    my $template = Template->new($tt_config, $vars);
    my $processed_template;
    $template->process("edit.tt", $vars, \$processed_template) || die $template->error(), "\n";

    $c->send_basic_header(200);
    print $c "Content-Type: text/html";
    $c->send_crlf();
    $c->send_crlf();

    print $c $processed_template;
}

1;
