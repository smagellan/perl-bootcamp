package delete::Delete;
use strict;
use warnings FATAL => 'all';

use DDP;
use BootcampDbConn;
use BootcampCommons qw(extract_id_from_request_string);
use base 'Exporter';
our @EXPORT = qw(
    delete_student
    );

sub do_delete_student{
    my ($student_id) = @_;
    my $dbh = db_conn();
    $dbh->do("delete from student
              where id = ?", undef,
          $student_id) or die $DBI::errstr;
}

sub render_delete_confirmation_page {
    my ($student_id) = @_;
    my $dbh = db_conn();

    my $sth = $dbh->prepare("select id, name, surname from student where id = ?" );
    $sth->execute($student_id) or die $DBI::errstr;
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
        $template->process("delete.tt", $vars, \$processed_template) || die $template->error(), "\n";
        return (200, $processed_template);
    }
}

sub delete_student {
    my ($c, $r) = @_;
    my $r_path = $r->uri->path;
    my $student_id = extract_id_from_request_string($r_path);

    if ($r->method eq 'GET') {
        my ($http_code, $answer) = render_delete_confirmation_page($student_id);

        $c->send_basic_header($http_code);
        print $c "Content-Type: text/html";
        $c->send_crlf();
        $c->send_crlf();
        print $c $answer;
    } else {
        if ($r->method eq 'POST') {
            my $post_body = $r->content();
            my $passed_params = CGI->new($post_body)->Vars();

            if ($passed_params->{'answer'} eq 'yes') {
                do_delete_student($student_id);
            }

            $c->send_basic_header(302);
            print $c "Location: /";
            $c->send_crlf();
            $c->send_crlf();
        }
    }
}

1;
