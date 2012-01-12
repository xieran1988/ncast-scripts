#!/usr/bin/env perl

use Expect;
use warnings;
use strict;

my $ip = $ARGV[0];
my $cmd = $ARGV[1];
my $eof = $ARGV[2];
my $e = new Expect;
$e->spawn("telnet $ip");
$e->expect(2, '-re', "^Escape") or exit 123;
$e->expect(2, '-re', "# ") or exit 123;
$e->send("cd /root\n");
$e->expect(2, '-re', "# ") or exit 123;
if ($cmd) {
	$e->send($cmd."\n");
	$eof = "^you would never get this" if !$eof;
	$e->expect(1000000000, '-re', $eof) or die 'fuck';
	exit 0
}
$e->interact();

