#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use lib qw{../lib  lib};
use WWW::Goodreads;

my $key = 'wYJkkdoi7hgbmsvq5GfbQ';
my $secret = 'c9kUTvNIqZ5JladiHl3HONXU8dU4dChKy3sNttFAvk';

my $gr = WWW::Goodreads->new(
    key     => $key,
    secret  => $secret,
);

$gr->oauth;



