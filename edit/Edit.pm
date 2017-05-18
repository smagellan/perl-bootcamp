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
    my $sth = $dbh->prepare("select st.id, st.name, st.surname, st.sex, st.nationality, st.address, st.birthday, st.mark, gr.id as group_id, gr.nomer
                                    from student st inner join group_st gr on (st.group_id = gr.id)" );

    my $rv = $sth->execute() or die $DBI::errstr;
    if($rv < 0){
        print $DBI::errstr;
    }
}

1;
