package edit::Edit;

use strict;
use warnings FATAL => 'all';

use DDP;
use CGI;
use createupdate::CreateUpdate;
use BootcampDbConn;
use BootcampCommons qw(extract_id_from_request_string);



use base 'Exporter';
our @EXPORT = qw(
    edit_student
    );

sub update_student_data {
    my ($c, $r, $student_id) = @_;
    my $post_body = $r->content();
    my $passed_params = CGI->new($post_body)->Vars();

    my $dbh = db_conn();
    $dbh->do("update student set
                    name = ?, surname = ?, nationality = ?,
                    address = ?, birthday = ?, sex = ?, group_id = ?
              where id = ?", undef,
        $passed_params->{"student_name"}, $passed_params->{"student_surname"}, $passed_params->{"student_nationality"},
        $passed_params->{"student_address"}, $passed_params->{"student_birthday"}, $passed_params->{"student_sex"},
        $passed_params->{"student_group_id"},
        $student_id) or die $DBI::errstr;
}

sub render_edit_page {
    my ($student_id) = @_;
    return render_create_or_edit_page($student_id, 'edit');
}

sub edit_student {
    my ($c, $r) = @_;
    my $r_path = $r->uri->path;
    my $student_id = extract_id_from_request_string($r_path);

    if ($r->method eq 'GET') {
        my ($http_code, $answer) = render_edit_page($student_id);

        $c->send_basic_header($http_code);
        print $c "Content-Type: text/html";
        $c->send_crlf();
        $c->send_crlf();
        print $c $answer;
    } else {
        if ($r->method eq 'POST') {
            update_student_data($c, $r, $student_id);

            $c->send_basic_header(302);
            print $c "Location: /";
            $c->send_crlf();
            $c->send_crlf();
        }
    }
}
1;
