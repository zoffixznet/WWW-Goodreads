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
    # access_token => 'LcbV5FDbRnX6DlGCuCJtYQ',
    # access_token_secret => 'Er4wCvp6fLIzTXWDz6CiPfTiSyNWnMxxnWnDqBiT1M',
);

$gr->auth;



