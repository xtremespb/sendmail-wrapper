#!/usr/bin/perl
use strict;
use warnings;
use Net::SMTP_auth;
use Email::Address;

my $user = getpwuid( $< );
my $smtp_password = 'password';
my $smtp_default_password = 'password';
my $server = 'srv1.re-hash.org';

my $input = '';
my $to_string = '';
foreach my $line ( <STDIN> ) {
  $input .= $line;
  if ($line =~ /^To:/) {
    $to_string = $line;
  }
}

my @addrs = Email::Address->parse($to_string);

if (0+@addrs eq 0) {
  die "No recipients";
}

my $rec = $addrs[0];
$rec =~ s/\@/\\@/;

my $smtp = Net::SMTP_auth->new('127.0.0.1', Port => 25, Timeout => 10, Debug => 0);
die "Could not connect to SMTP server!\n" unless $smtp;
if (!$smtp->auth('PLAIN', $user.'@'.$server, $smtp_password)) {
 $smtp->auth('PLAIN', 'default@'.$server, $smtp_default_password) or die "Auth failed!\n";
}
$smtp->mail($user.'\@'.$server);
$smtp->to($rec);
$smtp->data();
$smtp->datasend($input);
$smtp->dataend();
$smtp->quit;