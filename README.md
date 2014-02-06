# NAME

WWW::Goodreads - www.goodreads.com API implementation

# SYNOPSIS

# ICON LEGEND

# API METHODS

## `auth_user`

    my $user = $gr->auth_user
        or die "Error: " . $gr->error;

    print "User name: $user->{name}\n";
    print "User ID: $user->{id}\n";
    print "Link to user's profile: $user->{link}\n";

    ## Prints
    # User name: Perl Module
    # User ID: 28080395
    # Link to user's profile: https://www.goodreads.com/user/show/28080395-perl-module?utm_medium=api

_Get id of user who authorized OAuth._
__Takes__ no arguments. Fetches information on the currently authorized
user. __On failure__ return either `undef` or an empty
list, depending on the context, and the reason for failure will
be available via `->error` method. __On success__ returns
a hashref with three keys `name`, `id`, and `link`, which are
user's full name, user's ID, and the link to the user's
profile respectively.

## `author_books`

    my $books = $gr->author_books( id => 42 )
        or die "Error: " . $gr->error;

    my $books = $gr->author_books( id => 42, page => 2 )
        or die "Error: " . $gr->error;

_Paginate an author's books._
__Returns__ a paginated list of specified author's books.
__Takes__ arguments `id` and `page` as key/value pairs.
Argument `id` is __mandatory__, and specifies the `Author ID` of the
author whose books we want to retrieve. Argument `page`
is __optional__ (__default__ is `1`) and specifies the page number of
the book list to return. The list seems to be returned in chunks of
24 books; you can check whether you retrieved the last page of the
list by comparing `book_end` and `book_total` arguments in the return.
__On failure__ return either `undef` or an empty
list, depending on the context, and the reason for failure will
be available via `->error` method. __On success__ returns
a hashref, a sample of which is shown below.

- Key `link` contains the link to the author's GoodReads page
- Key `name` contains author's name
- Key `id` contains author's ID
- Key `book_start` contains the book number of the first book
        on this page we retrieved
- Key `book_end` contains the book number of the last book
        on this page we retrieved
- Key `book_total` contains the total number of books in the list.
- Key `books` contains an arrayref of hashrefs, where each
hashref is the author's book. See the data dump below for the structure
of book hashrefs

Sample:

    {
        'link' => 'https://www.goodreads.com/author/show/42.Wendy_Wasserstein',
        'book_end' => '24',
        'book_start' => '1',
        'name' => 'Wendy Wasserstein',
        'id' => '42',
        'book_total' => '24',
        'books' => [
            {
                'image_url' => 'https://www.goodreads.com/assets/nocover/111x148.png',
                'link' => 'https://www.goodreads.com/book/show/19826.Elements_of_Style',
                'small_image_url' => 'https://www.goodreads.com/assets/nocover/60x80.png',
                'publication_day' => '3',
                'publication_month' => '2', # February
                'publication_year' => '1992',
                'publisher' => undef,
                'published' => undef,
                'description' => undef,
                'num_pages' => undef,
                'edition_information' => undef,
                'isbn13' => '9781400042319',
                'isbn' => '1400042313',
                'ratings_count' => '1067',
                'id' => '19826',
                'format' => undef,
                'text_reviews_count' => '161',
                'title' => 'Elements of Style',
                'average_rating' => '2.99'
                'authors' => [
                     {
                       'link' => 'https://www.goodreads.com/author/show/42.Wendy_Wasserstein',
                       'name' => 'Wendy Wasserstein',
                       'small_image_url' => 'https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p2/42.jpg',
                       'text_reviews_count' => '469',
                       'ratings_count' => '4553',
                       'image_url' => 'https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p5/42.jpg',
                       'id' => '42',
                       'average_rating' => '3.56'
                     }
                ],
            }
        ],
    }

## `author_show`

    my $info = $gr->author_show( id => 42 )
        or die "Error: " . $gr->error;

_Get info about an author by id._
__Takes__ arguments as key/value pairs. Argument `id` is __mandatory__
and specifies GoodReads Author ID number, for the author whose information
you want to view. __On failure__ return either `undef` or an empty
list, depending on the context, and the reason for failure will
be available via `->error` method. __On success__ returns
a hashref, a sample of which is shown below.

    {
        'link' => 'https://www.goodreads.com/author/show/42.Wendy_Wasserstein',
        'name' => 'Wendy Wasserstein',
        'small_image_url' => 'https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p2/42.jpg',
        'influences' => undef,
        'works_count' => '24',
        'fans_count' => '15',
        'hometown' => 'Brooklyn, New York',
        'died_at' => '2006/01/30',
        'image_url' => 'https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p5/42.jpg',
        'about' => 'Wendy Wasserstein was an award-winning',
        'id' => '42',
        'born_at' => '1950/10/18',
        'gender' => 'female',
        'books' => [
             {
               'publication_day' => undef,
               'small_image_url' => 'https://d202m5krfqbpi5.cloudfront.net/books/1329241203s/86.jpg',
               'num_pages' => '249',
               'edition_information' => undef,
               'isbn13' => '9780679734994',
               'ratings_count' => '1455',
               'isbn' => '0679734996',
               'id' => '86',
               'publisher' => 'Vintage',
               'link' => 'https://www.goodreads.com/book/show/86.The_Heidi_Chronicles_and_Other_Plays',
               'authors' => [
                    {
                          'link' => 'https://www.goodreads.com/author/show/42.Wendy_Wasserstein',
                          'name' => 'Wendy Wasserstein',
                          'small_image_url' => 'https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p2/42.jpg',
                          'text_reviews_count' => '469',
                          'ratings_count' => '4560',
                          'image_url' => 'https://d202m5krfqbpi5.cloudfront.net/authors/1207026232p5/42.jpg',
                          'id' => '42',
                          'average_rating' => '3.56'
                    }
                ],
               'description' => undef,
               'publication_month' => '6',
               'published' => '1991',
               'format' => 'Paperback',
               'text_reviews_count' => '45',
               'publication_year' => '1991',
               'image_url' => 'https://d202m5krfqbpi5.cloudfront.net/books/1329241203m/86.jpg',
               'title' => 'The Heidi Chronicles and Other Plays',
               'average_rating' => '3.82'
             },
        ],
    }

# REPOSITORY

Fork this module on GitHub:
[https://github.com/zoffixznet/WWW-Lipsum](https://github.com/zoffixznet/WWW-Lipsum)

# BUGS

To report bugs or request features, please use
[https://github.com/zoffixznet/WWW-Lipsum/issues](https://github.com/zoffixznet/WWW-Lipsum/issues)

If you can't access GitHub, you can email your request
to `bug-www-lipsum at rt.cpan.org`

# AUTHOR

Zoffix Znet <zoffix at cpan.org>
([http://zoffix.com/](http://zoffix.com/), [http://haslayout.net/](http://haslayout.net/))

# LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the `LICENSE` file included in this distribution for complete
details.
