#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;

use WWW::Goodreads;
use lib qw{t}; use WWWGoodReadsTester qw/startup_gr/;

my $gr = startup_gr( no_oauth => 1 );

cmp_deeply(
    $gr->author_books( id => 42 ),
    {
        'link' => 'https://www.goodreads.com/author/show/42.Wendy_Wasserstein',
        'book_end' => re('\A\d+\z'),
        'book_start' => '1',
        'name' => 'Wendy Wasserstein',
        'id' => '42',
        'book_total' => '24', # if this number fails, we need to update the docs!!!
        books => array_each({
           'publication_day' => any(undef, re('\A\d+\z')),
           'small_image_url' => code(sub{1}),
           'num_pages' => any(undef, re('\A\d+\z')),
           'edition_information' => code(sub{1}),
           'isbn13' => re('\A[\d\s-]+\z'),
           'ratings_count' => re('\A\d+\z'),
           'isbn' => any(undef, re('\A[\w\s-]+\z')),
           'id' => re('\A\d+\z'),
           'publisher' => code(sub{1}),
           'link' => code(sub{1}),
           'authors' => array_each({
              'link' => re('.+'),
              'name' => re('.+'),
              'small_image_url' => code(sub{1}),
              'text_reviews_count' => re('\A\d+\z'),
              'ratings_count' => re('\A\d+\z'),
              'image_url' => re('.+'),
              'id' => re('\A\d+\z'),
              'average_rating' => re('\A[\d.]+\z'),
            }),
           'description' => code(sub{1}),
           'publication_month' => any(undef, re('\A\d+\z')),
           'published' => any(undef, re('\A\d+\z')),
           'format' => code(sub{1}),
           'text_reviews_count' => re('\A\d+\z'),
           'publication_year' => any(undef, re('\A\d+\z')),
           'image_url' => code(sub{1}),
           'title' => re('.+'),
           'average_rating' => re('\A[\d.]+\z'),
        }),
    },
    '->auth_user got the right stuff'
);


done_testing();



