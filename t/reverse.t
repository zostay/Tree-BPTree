# vim: set ft=perl :

use strict;
use warnings;

use Test::More tests => 48;
use Tree::BPTree;
require 't/runtests.pl';
use vars qw( &runtests @splitstr );

my $i = 0;
my @pairs = map { [ $i++, $_ ] } @splitstr;
my @sorted = reverse(map { $_->[0] } sort { $a->[1] cmp $b->[1] } @pairs);

sub test {
	my ($tree) = @_;

	$tree->reverse;
	is_deeply([ $tree->flattened_values ], \@sorted);
}

runtests;
