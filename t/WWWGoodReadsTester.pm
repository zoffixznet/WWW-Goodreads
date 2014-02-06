package
    WWWGoodReadsTester;

use strict;
use warnings;
use Test::More;
use Test::GetVolatileData;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(startup_gr);

sub startup_gr {
    my %args = @_;

    my $keys_data;
    if ( -e 'WWW-Goodreads-KEYS' ) {
        $ENV{AUTOMATED_TESTING} and diag "Reading WWW-Goodreads-KEYS";
        my $fh;
        open $fh, '<', 'WWW-Goodreads-KEYS'
            and chomp($keys_data = <$fh>);

        $ENV{AUTOMATED_TESTING} and diag "Got: $keys_data";
    }

    unless ( $keys_data ) {
        $ENV{AUTOMATED_TESTING} and diag "Fetching keys from remote";

        $keys_data = get_data('http://zoffix.com/CPAN/WWW-Goodreads.txt')
        or plan skip_all =>
        "Failed to fetch API key; error is: $Test::GetVolatileData::ERROR";
        my $fh;
        open $fh, '>', 'WWW-Goodreads-KEYS'
            and print $fh $keys_data;

        $ENV{AUTOMATED_TESTING} and diag "Got $keys_data";
    }

    my ( $key, $secret, $access, $access_secret ) = split /\|/, $keys_data;

    sleep(1); # API Terms require requests to happen at most once per second

    my $gr = WWW::Goodreads->new(
        key     => $key,
        secret  => $secret,
        access_token => $access,
        access_token_secret => $access_secret,
    );

    $gr->auth unless $args{no_oauth};

    return $gr;
}
