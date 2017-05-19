package edit::Edit;

use strict;
use warnings FATAL => 'all';

use DDP;
use CGI;
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
    my $rv = $dbh->do("update student set
                    name = ?, surname = ?, nationality = ?,
                    address = ?, birthday = ?
              where id = ?", undef,
        $passed_params->{"student_name"}, $passed_params->{"student_surname"}, $passed_params->{"student_nationality"},
        $passed_params->{"student_address"}, $passed_params->{"student_birthday"},
        $passed_params->{"student_id"});
    if ($rv < 0) {
        print $DBI::errstr;
    }
}

sub render_get {
    my ($student_id) = @_;
    my $dbh = db_conn();
    my $sth = $dbh->prepare("select st.id, st.name, st.surname, st.sex, st.nationality, st.address, st.birthday, st.mark, gr.id as group_id, gr.nomer
                                    from student st inner join group_st gr on (st.group_id = gr.id)
                             where st.id=$student_id" );

    my $rv = $sth->execute() or die $DBI::errstr;
    if ($rv < 0) {
        print $DBI::errstr;
    }

    my $student_fields = $sth->fetchrow_hashref();
    if ($student_fields) {
        my $my_path = lib::abs::path(".");
        my $tt_config = {
            INCLUDE_PATH => $my_path
        };
        my $vars = {
            student => $student_fields
        };
        my $template = Template->new($tt_config, $vars);
        my $processed_template = "";
        $template->process("edit.tt", $vars, \$processed_template) || die $template->error(), "\n";
        return (200, $processed_template);
    }
    return (404, "");
}

sub edit_student {
    my ($c, $r) = @_;
    my $r_path = $r->uri->path;
    my $student_id = extract_id_from_request_string($r_path);
    print("student id: $student_id\n");
    if ($r->method eq 'GET') {
        my ($http_code, $answer) = render_get($student_id);
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
