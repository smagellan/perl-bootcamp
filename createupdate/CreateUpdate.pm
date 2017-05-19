package createupdate::CreateUpdate;
use strict;
use warnings FATAL => 'all';

use BootcampDbConn;

use base 'Exporter';
our @EXPORT = qw(
    render_create_or_edit_page
    );

sub fetch_student_fields {
    my ($student_id, $page_mode) = @_;

    my $student_fields;
    if ($student_id) {
        my $dbh = db_conn();
        my $sth = $dbh->prepare("select st.id, st.name, st.surname, st.sex, st.nationality, st.address, st.birthday, st.mark, gr.id as group_id, gr.nomer as group_nomer
                                    from student st inner join group_st gr on (st.group_id = gr.id)
                             where st.id = ?" );
        $sth->execute($student_id) or die $DBI::errstr;

        $student_fields = $sth->fetchrow_hashref();
    } else {
        $student_fields = {
            id => undef,
            name => undef,
            surname => undef,
            sex => undef,
            nationality => undef,
            address => undef,
            birthday => undef,
            mark => undef,
            group_id => undef,
            group_nomer => undef
        };
    }
}

sub fetch_avail_groups() {
    my $dbh = db_conn();
    my $sth = $dbh->prepare("select id, nomer from group_st" );
    $sth->execute() or die $DBI::errstr;

    my $groups_hash = $sth->fetchall_hashref("id");
    my @keys = sort { $a cmp $b } keys %$groups_hash;
    my @vals = @$groups_hash{@keys};
    return @vals;
}


sub render_create_or_edit_page{
    my ($student_id, $page_mode) = @_;


    my $student_fields = fetch_student_fields($student_id);

    my $my_path = lib::abs::path(".");
    my $tt_config = {
        INCLUDE_PATH => $my_path
    };
    my @avail_groups = fetch_avail_groups();
    my $vars = {
        student => $student_fields,
        avail_groups => \@avail_groups,
        page_mode => $page_mode
    };
    my $template = Template->new($tt_config, $vars);
    my $processed_template = "";
    $template->process("create_update.tt", $vars, \$processed_template) || die $template->error(), "\n";
    return (200, $processed_template);
}

1;
