#!/usr/bin/env perl

use warnings;
use strict;

my @arr = (
	"\x55\x01\x01\x02\x00\x00\x00\x59",
	"\x55\x01\x01\x01\x00\x00\x00\x58",
	"\x55\x01\x01\x00\x02\x00\x00\x59",
	"\x55\x01\x01\x00\x01\x00\x00\x58"
);

# speed 9600 baud; line = 0; -brkint -imaxbel

my $s = $arr[int($ARGV[0])]; 
open T, ">/dev/ttyUSB2";
print T $s;
close T;

