#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use lib qw{../lib  lib};
use WWW::Goodreads;

my $key = 'fcJ7d4tYB5Y0xJSgs7Hpw';
my $secret = 'BCRxFpMuSPOvcuFInxCWRAhNEDGsFgGRhNIdoPXIkE';

my $gr = WWW::Goodreads->new(
    key     => $key,
    secret  => $secret,
    access_token    => 'OyanLfVXLJ5j07KpMeBiQ',
    access_token_secret => 'nU3EbzoHCe9kZHs1Re12oxO1JoyRRQZgcYFFp1njQ',
);

$gr->auth;

print $gr->auth_user;
