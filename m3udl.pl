#!/usr/bin/env perl
# Takes a URL to an m3u file and downloads that playlist's songs to a
# directory in the current working directory.

use warnings;
use strict;
use LWP::UserAgent;
use LWP::Simple qw(getstore);
use URI::Encode qw(uri_encode uri_decode);

my $m3u_url;
my $root_url;
my $download_dir;
my @song_list;

sub usage {
    print "$0 will take a m3u URL as an argument and download the music files listed in\n";
    print "the m3u playlist to an aptly named directory in the current working directory.\n";
    print "\n";
    print "Usage: $0 <URL>\n";
    print "\tURL    The URL for the m3u file.\n\n";
}

# Check for proper arguments (directory)
sub get_args {
    # Do we have an argument?
    if (! $ARGV[0]) {
        return 0;
    }

    # Save the Argument
    $m3u_url = $ARGV[0];

    # Is url and is m3u?
    if ($m3u_url =~ /^http\S+\.m3u$/) {
        return 1;
    }

    # I guess not.
    print "ERROR: Argument is not an m3u URL.\n\n";
    return 0;
}

# Get name of download dir as well as root path in url.
sub split_m3u {
    # get download directory
    my ($download_dir_html) = $m3u_url =~ /^http\S+\/(\S+)\.m3u$/;
    $download_dir = uri_decode($download_dir_html);

    # Get root URL
    ($root_url) = $m3u_url =~ /^(http\S+\/)\S+\.m3u$/;
}

# download m3u file from $m3u_url
sub download_m3u {
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($m3u_url);

    if (!$response->is_success) {
        print "ERROR" , $response->status_line , "\n";
        return 0;
    }

    return $response->decoded_content;
}

# Download each file 
sub download_files {
    print "Downloading...\n";
    foreach my $song (@song_list) {
        # file save path
        my $save = "$download_dir/$song";
        # url encoding
        my $encoded_song = uri_encode($song);
        # full url
        my $url = $root_url . $encoded_song;

        print "$song\n";
        getstore($url,$save);
    }
}


sub main {
    # check arguments
    if (!&get_args()) {
        &usage();
        return 0;
    }

    # split the m3u url up into required bits.
    if (!&split_m3u()) {
        return 0;
    }

    # download songlist
    my $song_list = &download_m3u;
    if (!$song_list) {
        return 0;
    }
    @song_list = split "\n", $song_list;

    # Create the destination directory.
    mkdir($download_dir);


    &download_files();
}

&main();
