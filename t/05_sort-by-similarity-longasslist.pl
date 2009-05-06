#!/usr/bin/perl
use strict;
use lib './lib';
use String::Similarity::Group ':all';
use Getopt::Std::Strict 't:';
$opt_t||=0.5;
warn("THRESHOLD: $opt_t\n");

my @names;
for my $line (<>){
   chomp $line;
   push @names, $line;
}

printf STDERR "got %s elements\n", scalar @names;
my @g = groups($opt_t, \@names);

printf STDERR "got %s groups \n",  scalar @g;

exit;
