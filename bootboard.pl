#!/usr/bin/env perl

use Expect;
use warnings;
use strict;

my $e;

my $kermrc = $ARGV[0];
my $pwron = int($ARGV[1]);
my $cmd = $ARGV[2];
my $uimage = $ARGV[3];
my $fspath = `realpath $ARGV[4]` if $ARGV[4];
chomp $fspath if $fspath;

sub uboot {
	my ($c) = @_;
	$e->send("$c\n");
	$e->expect(1000000, '-re', "^(OMAP3|TI8168).*") or die;
}

$e = new Expect;
$e->spawn("kermit $kermrc");

print "power reset ..\n";
my $pwroff = $pwron + 1;
`./pwr.pl $pwroff`;
`./pwr.pl $pwron`;

$e->expect(10, '-re', "^--------") or die;

if ($cmd eq 'kermitshell') {
	$e->interact();
}

$e->expect(10, '-re', "^Hit") or die;
uboot "c";

if ($cmd eq 'ubootshell') {
	$e->interact();
}

die 'fspath should not be empty !!' if !$fspath;

my $myip = "192.168.1.174";
my $armip = "192.168.1.36";
my $gateip = "192.168.1.1";
my $net = "192.168.1.0";

uboot "setenv serverip $myip";
uboot "setenv ipaddr $armip";
`cp $uimage /var/lib/tftpboot`;

my $cfg = "
auto eth0
iface eth0 inet static
address $armip
netmask 255.255.255.0
network $net
#gateway $gateip
";
`echo "$cfg" > $fspath/etc/network/interfaces`;
`echo "route add default gw $gateip" > $fspath/etc/myprofile`;
`cat /etc/resolv.conf > $fspath/etc/resolv.conf`;

my $a2 = "setenv bootargs " .
"console=ttyS0,115200n8 vram=12M omapfb.mode=dvi:1024x768MR-16\@60 " .
"omapdss.def_disp=dvi " .
"root=/dev/nfs nfsroot=$myip:$fspath,port=2049 " .
"mem=99M\@0x80000000 mem=128M\@0x88000000 " .
#				"ip=$armip:$myip:192.168.1.1:255.255.255.0:arm:eth0 " .
"ip=$armip:$myip:$gateip:255.255.255.0:arm:eth0 " .
#ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
"mpurate=1000 " .
#"boardmodel=SBC35X-B1-1880-LUAC0 " 
"boardmodel=SBC35X-B1-1880-LUAC0 "
;

uboot $a2;

if ($uimage eq 'nand') {
#uboot "mmc init; fatload mmc 0 \${loadaddr} uImage; bootm \${loadaddr}";
	uboot "nand read \${loadaddr} 280000 400000; bootm \${loadaddr}";
} else {
	uboot "tftp \${loadaddr} $uimage";
	uboot "bootm \${loadaddr}";
}

$e->interact();


