package WWW::Goodreads;

use strict;
use warnings;

# VERSION

use Moo;
use LWP::UserAgent;

has key    => ( is => 'ro', required => 1 );
has secret => ( is => 'ro', required => 1 );

has error => ( is => 'rw', build_arg => undef );
has _ua    => ( is => 'ro', build_arg => undef, default => sub {
    return LWP::UserAgent->new( timeout => 30,
        agent => 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:26.0) '
                    . 'Gecko/20100101 Firefox/26.0'
    );
});

#### API METHODS

sub auth_user { ... }
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
