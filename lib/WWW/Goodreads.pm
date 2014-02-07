package WWW::Goodreads;

use strict;
use warnings;

# VERSION

use Moo;
use LWP::UserAgent;
use Net::OAuth::Simple;
use URI;
use Carp qw/croak/;
use JSON::MaybeXS qw/decode_json/;
use Business::ISBN;
use XML::Simple; # wat?
use namespace::autoclean -also => qr/^__/;

our $AUTHORIZATION_URL = 'https://www.goodreads.com/oauth/authorize';
our $ACCESS_TOKEN_URL  = 'https://www.goodreads.com/oauth/access_token';
our $REQUEST_TOKEN_URL = 'https://www.goodreads.com/oauth/request_token';

has key    => ( is => 'ro', required => 1 );
has secret => ( is => 'ro', required => 1 );
has be_nice => ( is => 'rw', default => 1 ); # Whether we should stick to
                                    # the at most 1-request-per-second
                                    # rule of API terms
has access_token        => ( is => 'rw', );
has access_token_secret => ( is => 'rw', );
has _auth   => ( is => 'rw', build_arg => undef, );

has error => ( is => 'rw', build_arg => undef );
has _ua    => ( is => 'ro', build_arg => undef, default => sub {
    return LWP::UserAgent->new( timeout => 30,
        agent => 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:26.0) '
                    . 'Gecko/20100101 Firefox/26.0'
    );
});

sub auth {
    my $self = shift;

    my %tokens = (
        consumer_key       => $self->key,
        consumer_secret    => $self->secret,
        access_token       => $self->access_token,
        access_token_secret      => $self->access_token_secret,
    );
    my $auth = Net::OAuth::Simple->new(
        tokens => \%tokens,
        return_undef_on_error => 1,
        urls   => {
            authorization_url => $AUTHORIZATION_URL,
            request_token_url => $REQUEST_TOKEN_URL,
            access_token_url  => $ACCESS_TOKEN_URL,
        },
    );

    unless ( $auth->authorized ) {
        print "STEP 1: REQUEST GOODREADS AUTHORIZATION FOR THIS APP\n";
        print "\tURL : ".
            $auth->get_authorization_url( callback => 'oob' ) ."\n";
        print "\n-- Please go to the above URL and authorize the app";
        print "\n-- It will give you a code. Please type it here: ";
        my $verifier = <STDIN>; print "\n";
        chomp($verifier);
        $auth->verifier($verifier);

        my ( $access_token, $access_token_secret )
        = $auth->request_access_token;
        $self->access_token( $access_token );
        $self->access_token_secret( $access_token_secret );

        print "You have now authorized this app.\n";
        print "Your access token and secret are:\n\n";
        print "access_token=$access_token\n";
        print "access_token_secret=$access_token_secret\n";
        print "\n";
    }

    $self->_auth( $auth );

    return;
}

sub _set_error {
    my ( $self, $error ) = @_;
    $self->error( $error );
    return;
}

sub _make_oauth_request {
    my ( $self, $url, $type ) = @_;
    $type ||= 'GET';
    $self->_auth and $self->_auth->authorized
        or croak q{We don't seem to be authorized to use OAuth API calls.}
            . ' Did you forget to call ->auth() first?';

    my $res = $self->_auth->make_restricted_request( $url, $type );
    $res->is_success or return $self->_set_error(
        'Network error: ' . $res->status_line
    );

    return XMLin($res->decoded_content);
}

sub _make_key_request {
    my ( $self, $url, $type, %args ) = @_;
    $type ||= 'GET';

    if ( $type eq 'GET' ) {
        my $url = URI->new( $url );
        $url->query_form( key => $self->key, %args );
        my $res = $self->_ua->get($url);
        $res->is_success or return $self->_set_error(
            'Network error: ' . $res->status_line
        );
        return $res->decoded_content;
    }

    ...
}

####
#### Methods to fix up some of the values XML::Simple gives us
#### Moving these to separate methods, because we probably should
#### Use a different XML parser to make things cleaner
####

sub __xml_simple_decontentify {
    $_ = $_->{content}
        for @_;
}

sub __xml_simple_make_true_undef {
    for ( values %{ $_[0] } ) {
        ref eq 'HASH'
            and (
                not keys %$_
                or ( keys %$_ == 1 and $_->{nil} eq 'true' )
            )
            and undef $_;
    }
}

# We have cases where we can't use this natively with XML::Simple
sub __xml_simple_forcearray {
    ref eq 'HASH' and $_ = [ $_ ]
        for @_;
}

sub _isbn_from_arg {
    my $self = shift;
    my $isbn = shift;
    $isbn or croak 'You MUST specify a book ISBN as the argument';

    $isbn = Business::ISBN->new( $isbn )
        unless ref $isbn;

    return $isbn;
}

#### API METHODS

sub auth_user {
    my $self = shift;
    my $data
    = $self->_make_oauth_request('https://www.goodreads.com/api/auth_user');

    return delete $data->{user};
}

sub author_books {
    my ( $self, $id, $page ) = @_;
    $id or croak 'You MUST specify Goodreads Author id number '
        . 'using the argument';

    $page ||= 1; $page += 0; $page =~ /\D/
        and croak 'Argument `page` takes positive integers only';

    my $data = $self->_make_key_request(
        'https://www.goodreads.com/author/list/' . $id . '.xml',
    );

    $data = XMLin( $data,
        GroupTags => { authors => 'author' }
    );

    # Shuffle the data to where it makes more sense
    $data = delete $data->{author};
    $data->{ "book_$_" } = delete $data->{books}{ $_ }
        for qw/end  start  total/;
    $data->{books} = delete $data->{books}{book};

    # This is really sort of a hack to fix what XML::Simple gave us;
    # Would this be cleaner if we used a different parser?
    for my $book ( @{ $data->{books} } ) {
        __xml_simple_forcearray( $book->{authors} );
        __xml_simple_decontentify( @$book{qw/text_reviews_count  id/} );
        __xml_simple_make_true_undef( $book );
    }

    return $data;
}

sub author_show {
    my ( $self, $id ) = @_;
    $id
     or croak 'You MUST specify Goodreads Author id number as the argument';

    my $data = $self->_make_key_request(
        'https://www.goodreads.com/author/show/' . $id . '.xml',
    );

    $data = XMLin( $data,
        GroupTags => { authors => 'author' },
    );

    # Shuffle the data to where it makes more sense
    $data = delete $data->{author};
    $data->{books} = delete $data->{books}{book};

    # This is really sort of a hack to fix what XML::Simple gave us;
    # Would this be cleaner if we used a different parser?
    __xml_simple_make_true_undef( $data );
    __xml_simple_decontentify( @$data{qw/fans_count/} );
    for my $book ( @{ $data->{books} } ) {
        __xml_simple_forcearray( $book->{authors} );
        __xml_simple_decontentify( @$book{qw/text_reviews_count  id/} );
        __xml_simple_make_true_undef( $book );
    }

    return $data;
}

sub book_isbn_to_id {
    my $self = shift;
    my $isbn = $self->_isbn_from_arg( shift );
    return $self->_make_key_request(
        'https://www.goodreads.com/book/isbn_to_id/' . $isbn->as_string([])
    );
}

sub book_review_counts {
    my $self = shift;
    my $isbns = shift;
    $isbns = [ $isbns ] unless ref $isbns eq 'ARRAY';
    my $callback = shift;

    ### ISBN processing and checking
    @$isbns = map $self->_isbn_from_arg( $_ ), @$isbns;
    for ( 0 .. $#$isbns ) {
        next if defined $isbns->[$_] and length $isbns->[$_]->as_string([]);
        croak 'The ISBN you provided is invalid or you gave me an undef'
            if $_ == 0;

        croak 'The ISBN number at position ' . ($_+1)
            . ' is invalid or is an undef';
    }

    @$isbns or croak 'You must provide at least one valid ISBN'
        . 'number or compatible object';

    my $json = $self->_make_key_request(
        'https://www.goodreads.com/book/review_counts.json',
        'GET',
        isbns   => join(',', map $_->as_string([]), @$isbns),
        format  => 'json',
        defined $callback ? ( callback => $callback ) : (),
    );

    unless ( $json ) {
        $self->error =~ /Network.+404/
            and $self->error('not found');
        return;
    }

    return $json
        if defined $callback;
    $json = decode_json $json;

    if ( @$isbns > 1 ) {
        return wantarray ? @{ $json->{books} } : $json->{books};
    }
    else {
        $json->{books}[0];
    }
}

sub book_show { ... }
sub book_show_by_isbn { ... }
sub book_title { ... }
sub comment_create { ... }
sub comment_list { ... }
sub events_list { ... }
sub fanship_create { ... }
sub fanship_destroy { ... }
sub fanship_show { ... }
sub followers_create { ... }
sub followers_destroy { ... }
sub friend_confirm_recommendation { ... }
sub friend_confirm_request { ... }
sub friend_requests { ... }
sub friends_create { ... }
sub group_join { ... }
sub group_list { ... }
sub group_members { ... }
sub group_search { ... }
sub group_show { ... }
sub list_book { ... }
sub notifications { ... }
sub owned_books_create { ... }
sub owned_books_list { ... }
sub owned_books_show { ... }
sub owned_books_update { ... }
sub quotes_create { ... }
sub rating_create { ... }
sub rating_destroy { ... }
sub read_statuses_show { ... }
sub recommendations_show { ... }
sub review_create { ... }
sub review_edit { ... }
sub reviews_list { ... }
sub review_recent_reviews { ... }
sub review_show { ... }
sub review_show_by_user_and_book { ... }
sub review_update { ... }
sub search_authors { ... }
sub search_books { ... }
sub series_show { ... }
sub series_list { ... }
sub series_work { ... }
sub shelves_add_to_shelf { ... }
sub shelves_add_books_to_shelves { ... }
sub shelves_list { ... }
sub topic_create { ... }
sub topic_group_folder { ... }
sub topic_show { ... }
sub topic_unread_group { ... }
sub updates_friends { ... }
sub user_shelves_create { ... }
sub user_shelves_update { ... }
sub user_show { ... }
sub user_compare { ... }
sub user_followers { ... }
sub user_following { ... }
sub user_friends { ... }
sub user_status_create { ... }
sub user_status_destroy { ... }
sub user_status_show { ... }
sub user_status_index { ... }
sub work_editions { ... }




q|
The fantastic element that explains the appeal of games to many developers
is neither the fire-breathing monsters nor the milky-skinned, semi-clad
sirens; it is the experience of carrying out a task from start to finish
without any change in the user requirements.
|;

__END__

=encoding utf8

=head1 NAME

WWW::Goodreads - www.goodreads.com API implementation

=head1 SYNOPSIS

=head1 API METHODS

=head2 C<auth_user>

    my $user = $gr->auth_user
        or die "Error: " . $gr->error;

    print "User name: $user->{name}\n";
    print "User ID: $user->{id}\n";
    print "Link to user's profile: $user->{link}\n";

    ## Prints
    # User name: Perl Module
    # User ID: 28080395
    # Link to user's profile: https://www.goodreads.com/user/show/28080395-perl-module?utm_medium=api

I<Get id of user who authorized OAuth.>
B<Takes> no arguments. Fetches information on the currently authorized
user. B<On failure> returns either C<undef> or an empty
list, depending on the context, and the reason for failure will
be available via C<< ->error >> method. B<On success> returns
a hashref with three keys C<name>, C<id>, and C<link>, which are
user's full name, user's ID, and the link to the user's
profile respectively.

=head2 C<author_books>

    my $books = $gr->author_books( 42 )
        or die "Error: " . $gr->error;

    my $books = $gr->author_books( 42, 2 )
        or die "Error: " . $gr->error;

I<Paginate an author's books.>
B<Returns> a paginated list of specified author's books.
B<Takes> two arguments. The first argument is B<mandatory>, and
specifies the C<Author ID> of the
author whose books we want to retrieve. The second argument
is B<optional> (B<default> is C<1>) and specifies the page number of
the book list to return. The list seems to be returned in chunks of
24 books; you can check whether you retrieved the last page of the
list by comparing C<book_end> and C<book_total> arguments in the return.
B<On failure> returns either C<undef> or an empty
list, depending on the context, and the reason for failure will
be available via C<< ->error >> method. B<On success> returns
a hashref, a sample of which is shown below.

=over 4

=item * Key C<link> contains the link to the author's GoodReads page

=item * Key C<name> contains author's name

=item * Key C<id> contains author's ID

=item * Key C<book_start> contains the book number of the first book
        on this page we retrieved

=item * Key C<book_end> contains the book number of the last book
        on this page we retrieved

=item * Key C<book_total> contains the total number of books in the list.

=item * Key C<books> contains an arrayref of hashrefs, where each
hashref is the author's book. See the data dump below for the structure
of book hashrefs

=back

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

=head2 C<author_show>

    my $info = $gr->author_show( 42 )
        or die "Error: " . $gr->error;

I<Get info about an author by id.>
B<Takes> one B<mandatory> argument
that specifies GoodReads Author ID number, for the author whose information
you want to view. B<On failure> returns either C<undef> or an empty
list, depending on the context, and the reason for failure will
be available via C<< ->error >> method. B<On success> returns
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

=head2 C<book_isbn_to_id>

    my $id = $gr->book_isbn_to_id('9780679734994')
        or die "Error: " . $gr->error;


    my $isbn = Business::ISBN->new('978-0-679-73499-4');
    my $id = $gr->book_isbn_to_id( $isbn )
        or die "Error: " . $gr->error;

I<Get the Goodreads book ID given an ISBN. Response
contains the ID without any markup.>
B<Takes> one B<mandatory> argument that is the ISBN of the book whose ID
you want to obtain. The ISBN can be either given as a string or
as a L<Business::ISBN> object.

B<On failure> (or if the book wasn't found; or an invalid ISBN was given)
returns either C<undef> or an empty
list, depending on the context, and the reason for failure will
be available via C<< ->error >> method. B<On success> returns a string
containing book ID.

=head2 C<book_review_counts>

    my $isbn = Business::ISBN->new('978-1-400-04231-9');
    my $revs = $gr->book_review_counts( [ $isbn, '0345348125',] )
        or die "Error: " . $gr->error;

    my $json = $gr->book_review_counts( [ $isbn, '0345348125',], 'callback' )
        or die "Error: " . $gr->error;

    my @revs = $gr->book_review_counts( [ $isbn, '0345348125',] )
        or die "Error: " . $gr->error;

    my $rev = $gr->book_review_counts( $isbn )
        or die "Error: " . $gr->error;

    my $json = $gr->book_review_counts( $isbn, 'callback' )
        or die "Error: " . $gr->error;

    my $rev = $gr->book_review_counts( $isbn );
    unless ( $rev ) {
        if ( $gr->error eq 'not found' ) {
            print "Book was not found!\n";
        }
        else {
            die "Error: " . $gr->error;
        }
    }

I<Get review statistics for books given a list of ISBNs.>
You must give at least one ISBN number too look up in the arguments,
which can be either a string, or an object like L<Business::ISBN>.
Possible arguments and their forms are as follows:

=over 4

=item * B<One argument, a string:> Must be an ISBN number

=item * B<Two arguments, both strings:> The first one must be an ISBN
number; the second one is the string with the "function to wrap JSON
response"

=item * B<One argument, an arrayref:>
Each element of the arrayref must be an ISBN number, and the arrayref
must have at least one of them. If any element is C<undef> or an
invalid ISBN number, the module will C<croak()>

=item * B<Two arguments, first one an arrayref, second a string:>
The arrayref must contain ISBN numbers (as detailed above) and the
second argument is the string with the "function to wrap JSON response"

=back

The return values depend on the result of the request, the input arguments,
and the context:

=over 4

=item * B<If an error occurs:>
Returns either C<undef> or an empty list, depending on the context,
and the reason for failure will be available via C<< ->error >> method.

=item * B<If no books were found:>
Will return the same as if an error occured, and the error message
will be C<not found> (lowercase).

=item * B<If callback string was given:>
Will return JSON string wrapped in the provided callback.

=item * B<No callback string, list context:>
Will return a list of hashrefs, each representing a found review
statistic for the book

=item * B<No callback string, scalar context, only one ISBN was given
in the arguments:>
Will return a hashrefs representing the found review
statistic for the book.

=item * B<No callback string, scalar context, several ISBN were given
in the arguments:>
Will return an arrayref of hashrefs, each representing a found review
statistic for a book.

=back

Each book review statistic hashref has the following format:

    {
        'work_text_reviews_count' => 47,
        'work_ratings_count' => 1458,
        'work_reviews_count' => 1970,
        'text_reviews_count' => 45,
        'isbn13' => '9780679734994',
        'reviews_count' => 1955,
        'ratings_count' => 1449,
        'isbn' => '0679734996',
        'id' => 86,
        'average_rating' => '3.82'
    }

=head1 REPOSITORY

Fork this module on GitHub:
L<https://github.com/zoffixznet/WWW-Lipsum>

=head1 BUGS

To report bugs or request features, please use
L<https://github.com/zoffixznet/WWW-Lipsum/issues>

If you can't access GitHub, you can email your request
to C<bug-www-lipsum at rt.cpan.org>

=head1 AUTHOR

Zoffix Znet <zoffix at cpan.org>
(L<http://zoffix.com/>, L<http://haslayout.net/>)

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut
