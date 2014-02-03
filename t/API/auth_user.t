#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

use WWW::Goodreads;
use lib qw{t}; use WWWGoodReadsTester qw/startup_gr/;

my $gr = startup_gr();

is_deeply(
    $gr->auth_user, ### REWRITE THIS TO CHECK FOR NETWORK ERRORS!!
    {
        'link' => 'https://www.goodreads.com/user/show/28080395-perl-module?utm_medium=api',
        'name' => 'Perl Module',
        'id' => '28080395',
    },
    '->auth_user got the right stuff'
);


done_testing();


