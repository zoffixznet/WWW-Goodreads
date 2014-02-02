package WWW::Goodreads;

use 5.010;
use strict;
use warnings;

# VERSION

use Moo;
use LWP::UserAgent;
use Net::OAuth::Simple;
use XML::Simple; # wat?

our $AUTHORIZATION_URL = 'https://www.goodreads.com/oauth/authorize';
our $ACCESS_TOKEN_URL  = 'https://www.goodreads.com/oauth/access_token';
our $REQUEST_TOKEN_URL = 'https://www.goodreads.com/oauth/request_token';

has key    => ( is => 'ro', required => 1 );
has secret => ( is => 'ro', required => 1 );
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

sub _make_request {
    my ( $self, $url, $type ) = @_;
    $type ||= 'GET';
    my $res = $self->_auth->make_restricted_request( $url, $type );
    $res->is_success or return $self->_set_error( $res->status_line );

    my $data = XMLin($res->decoded_content);
    return $data;
}

#### API METHODS

sub auth_user {
    my $self = shift;
    my $data
    = $self->_make_request('https://www.goodreads.com/api/auth_user');

    return delete $data->{user};
}

sub author_books { ... }
sub author_show { ... }
sub book_isbn_to_id { ... }
sub book_review_counts { ... }
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

B<Takes> no arguments. Fetches information on the currently authorized
user. B<On failure> return either C<undef> or an empty
list, depending on the context, and the reason for failure will
be available via C<< ->error >> method. B<On success> returns
a hashref with three keys C<name>, C<id>, and C<link>, which are
user's full name, user's ID, and the link to the user's
profile respectively.

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
