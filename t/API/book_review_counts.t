#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;
use Test::Exception;

use WWW::Goodreads;
use lib qw{t}; use WWWGoodReadsTester qw/startup_gr/;

my $gr = startup_gr( no_oauth => 1 );

my $isbn = Business::ISBN->new('978-1-400-04231-9');
my $isbn2 = '0679734996';
my $isbn3 = '0345348125';

my @returns_check = (
    {
      'work_text_reviews_count' => re('\A\d+\z'),
      'work_ratings_count' => re('\A\d+\z'),
      'work_reviews_count' => re('\A\d+\z'),
      'text_reviews_count' => re('\A\d+\z'),
      'isbn13' => '9781400042319',
      'reviews_count' => re('\A\d+\z'),
      'ratings_count' => re('\A\d+\z'),
      'isbn' => '1400042313',
      'id' => 19826,
      'average_rating' => re('\A\d+(?:.\d+)?\z'),
    },
    {
      'work_text_reviews_count' => re('\A\d+\z'),
      'work_ratings_count' => re('\A\d+\z'),
      'work_reviews_count' => re('\A\d+\z'),
      'text_reviews_count' => re('\A\d+\z'),
      'isbn13' => '9780679734994',
      'reviews_count' => re('\A\d+\z'),
      'ratings_count' => re('\A\d+\z'),
      'isbn' => '0679734996',
      'id' => 86,
      'average_rating' => re('\A\d+(?:.\d+)?\z'),
    }
);

SKIP: {
    my $books = $gr->book_review_counts( [ $isbn, $isbn2,] );

    unless ( $books ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }

    cmp_deeply(
        $books,
        \@returns_check,
        '->book_review_counts([ "two", "isbns"] )',
    );
}

SKIP: {
    my $json = $gr->book_review_counts( [ $isbn, $isbn3,], 'zcallback' );

    unless ( $json ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }

    like( $json, qr/
        zcallback([{"id":19826,
            "isbn":"1400042313","isbn13":"9781400042319",
            "ratings_count":\d+,"reviews_count":\d+,
            "text_reviews_count":\d+,"work_ratings_count":\d+,
            "work_reviews_count":\d+,"work_text_reviews_count":200,
            "average_rating":"\d+(?:.\d+)?"},{"id":1063101,
            "isbn":"0345348125","isbn13":"9780345348128",
            "ratings_count":\d+,"reviews_count":\d+,
            "text_reviews_count":\d+,
            "work_ratings_count":\d+,"work_reviews_count":\d+,
            "work_text_reviews_count":\d+,"average_rating":"\d+(?:.\d+)?"}])
    /x, q{->book_review_counts( [ $isbn, '0345348125',], 'zcallback' )});
}

SKIP: {
    my @books = $gr->book_review_counts( [ $isbn, $isbn2,] );

    unless ( @books ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }

    cmp_deeply(
        \@books,
        \@returns_check,
        '->book_review_counts([ "two", "isbns"] )  [list contex]',
    );

}

SKIP: {
    my $book = $gr->book_review_counts( $isbn );

    unless ( $book ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }

    cmp_deeply(
        $book,
        $returns_check[0],
        '->book_review_counts( $isbn )',
    );
}

SKIP: {
    my $json = $gr->book_review_counts( $isbn, 'zcallback' );

    unless ( $json ) {
        $gr->error =~ /^Network/
            and skip 'Got network error ' . $gr->error, 1;

        BAIL_OUT('Got weird error: ' . $gr->error);
    }
    like(
        $json,
        qr/callback([{"id":19826,"isbn":"1400042313",
            "isbn13":"9781400042319","ratings_count":\d+,
            "reviews_count":\d+,"text_reviews_count":\d+,
            "work_ratings_count":\d+,"work_reviews_count":\d+,
            "work_text_reviews_count":\d+,
            "average_rating":"\d+(?:.\d+)?"}])/x,
        q{->book_review_counts( $isbn, 'zcallback' )},
    );
}

SKIP: {
    # it's a proper book, but unknown, so we should consistently get
    # a "not found" from good reads here.
    my $book = $gr->book_review_counts('978-1-105-87246-4');
    is( $book, undef, 'return is undef, when given unknown ISBN');

    $gr->error =~ /^Network/
        and skip 'Got network error ' . $gr->error, 1;

    is( $gr->error, 'not found', 'Error reads "not found" when we '
    );
}

SKIP: {
    my $book;
    throws_ok { $book = $gr->book_review_counts('000000') }
        qr/The ISBN you provided is invalid or you gave me an undef at/,
        'Got proper error when gave invalid ISBN';

    is( $book, undef, 'return is undef, when given invalid ISBN');
}

done_testing();
