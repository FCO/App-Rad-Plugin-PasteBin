#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Rad::Plugin::PasteBin' );
}

diag( "Testing App::Rad::Plugin::PasteBin $App::Rad::Plugin::PasteBin::VERSION, Perl $], $^X" );
