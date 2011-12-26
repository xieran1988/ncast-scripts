#!/usr/bin/env perl

use Expect;
use warnings;
use strict;

my $ip = $ARGV[0];
my $cmd = $ARGV[1];
$e = new Expect;
$e->spawn("telnet $ip");
$e->expect(2, '-re', "^Escape") or exit 123;
if ($cmd) {
	$e->send($cmd."\n");
	$e->expect(1000000000, '-re', "^you would never get this fucking line") or die 'fuck';
}

