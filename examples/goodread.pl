#!/usr/bin/env perl

use strict;
use warnings;
use Acme::Dump::And::Dumper;

use lib qw{../lib  lib};
use WWW::Goodreads;

my $key = 'fcJ7d4tYB5Y0xJSgs7Hpw';
my $secret = 'BCRxFpMuSPOvcuFInxCWRAhNEDGsFgGRhNIdoPXIkE';

my $gr = WWW::Goodreads->new(
    key     => $key,
    secret  => $secret,
    access_token => 'LcbV5FDbRnX6DlGCuCJtYQ',
    access_token_secret => 'Er4wCvp6fLIzTXWDz6CiPfTiSyNWnMxxnWnDqBiT1M',
);

# my $id = $gr->book_isbn_to_id('0679734996')
#     or die "Error: " . $gr->error;


my $isbn = Business::ISBN->new('978-1-400-04231-9');
my $id = $gr->book_isbn_to_id( $isbn )
    or die "Error: " . $gr->error;


use Acme::Dump::And::Dumper;
die DnD [ $id ];