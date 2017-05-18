package BootcampCommons;
use strict;
use warnings FATAL => 'all';

use URI qw( );
use URI::QueryParam qw( );

use base 'Exporter';
our @EXPORT = qw(
    extract_id_from_request_string
    );

sub extract_id_from_request_string {
    my ($r_path) = @_;
    my $u = URI->new($r_path);
    my @path_segments = $u->path_segments();

    if (@path_segments) {
        my $last_component = $path_segments[$#path_segments];
        if ($last_component  =~ /^(\d+)$/) {
            return $1;
        } else {
            return undef;
        }
    } else {
        return undef;
    }
}

1;
