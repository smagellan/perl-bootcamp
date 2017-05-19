package add::Add;
use strict;
use warnings FATAL => 'all';

use BootcampDbConn;
use createupdate::CreateUpdate;

use base 'Exporter';
our @EXPORT = qw(
    add_student
    );

sub create_student_data {
    my ($c, $r) = @_;
    my $post_body = $r->content();
    my $passed_params = CGI->new($post_body)->Vars();

    my $dbh = db_conn();
    $dbh->do("insert into student(name, surname, nationality,
                          address, birthday, sex, group_id, mark) values
                          (?, ?, ?, ?, ?, ?, ?, ?)", undef,
        $passed_params->{"student_name"}, $passed_params->{"student_surname"}, $passed_params->{"student_nationality"},
        $passed_params->{"student_address"}, $passed_params->{"student_birthday"}, $passed_params->{"student_sex"},
        $passed_params->{"student_group_id"}, $passed_params->{"student_mark"}) or die $DBI::errstr;
}

sub render_create_page {
    my ($student_id) = @_;
    return render_create_or_edit_page($student_id, 'create');
}

sub add_student {
    my ($c, $r) = @_;

    if ($r->method eq 'GET') {
        my ($http_code, $answer) = render_create_page(undef);

        $c->send_basic_header($http_code);
        print $c "Content-Type: text/html";
        $c->send_crlf();
        $c->send_crlf();
        print $c $answer;
    } else {
        if ($r->method eq 'POST') {
            create_student_data($c, $r);

            $c->send_basic_header(302);
            print $c "Location: /";
            $c->send_crlf();
            $c->send_crlf();
        }
    }
}
1;
