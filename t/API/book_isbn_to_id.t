#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;

use WWW::Goodreads;
use lib qw{t}; use WWWGoodReadsTester qw/startup_gr/;

my $gr = startup_gr( no_oauth => 1 );

SKIP: {
    my $id1 = $gr->book_isbn_to_id('0679734996');

    unless ( $id1 ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }

    is($id1, 86, 'Got proper book ID using a string as the argument');
}

SKIP: {
    my $id1 = $gr->book_isbn_to_id('0679734996');

    unless ( $id1 ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }

    my $isbn = Business::ISBN->new('978-1-400-04231-9');
    my $id2 = $gr->book_isbn_to_id( $isbn )
        or die "Error: " . $gr->error;

    is($id2, 19826, 'Got proper book ID using Business::ISBN object');
}

done_testing();