#!/usr/bin/env perl
# Takes a URL to an m3u file and downloads that playlist's songs to a
# directory in the current working directory.

use warnings;
use strict;
#use LWP::UserAgent;

#my $ua = LWP::UserAgent->new;
my $m3u_url;
my $root_url;
my $download_dir;

sub usage {
    print "$0 will take a m3u URL as an argument and download the music files listed in\n";
    print "the m3u playlist to an aptly named directory in the current working directory\n";
    print "\n";
    print "Usage: $0 <URL>\n";
    print "\tURL    The URL for the m3u file.\n\n";
}

# Check for proper arguments (directory)
sub getArgs {
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
}

# download m3u file from $m3u_url
sub download_m3u {
}

sub main {
    if (!&getArgs()){
        &usage();
        return 0;
    }
}

&main();
