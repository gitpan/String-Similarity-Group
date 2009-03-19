use Test::Simple 'no_plan';
use strict;
use lib './lib';
use Cwd;
use vars qw($_part);

use String::Similarity::Group ':all';
use Smart::Comments '###';

my @a = qw/victory victorious victoria velociraptor velocirapto matrix garrot/;

my @r;
ok_part("VERY BASIC TEST...");


ok( 1, 'started');

ok @r = groups( 0.8, \@a ),'groups()';
### @r
ok @r = groups_hard( 0.8, \@a ),'groups_hard()';
### @r
ok @r = groups_lazy( 0.8, \@a ),'groups_lazy()';
### @r
ok @r = loners( 0.8, \@a ),'loners()';
### @r





my( $e0, $s0 ) = similarest(\@a, 'matryx');
ok $e0 eq 'matrix';

my $e1 = similarest(\@a, 'matryx');
ok $e1, 'similarest() returns';
ok $e1 eq 'matrix', "$e1 eq 'matrix'";










sub ok_part {
   printf STDERR "\n\n===================\nPART %s %s\n==================\n\n",
      $_part++, "@_";
}


