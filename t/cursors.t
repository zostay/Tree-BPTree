# vim: set ft=perl :

use strict;
use warnings;

use Test::More;
use Tree::BPTree;
require 't/runtests.pl';
use vars qw( &runtests @splitstr );

my $i = 0;
my @pairs = map { [ $i++, $_ ] } @splitstr;

# Taken and modified from the _Perl Cookbook_ (2nd Ed.) by Tom Christiansen
# et. al.  published by O'Reilly
my (%seen, @collapsed);
for my $pair (@pairs) {
	push @{$seen{$$pair[1]}}, $$pair[0];
}

# This is some crazy list operator stacking to get a sorted list of pairs
my @sorted = 
	sort { $a->[0] cmp $b->[0] }
	map { [ $_, $seen{$_} ] } 
	keys(%seen);

plan tests => 3 * 48 * @sorted;

sub test {
	my ($tree) = @_;

	my $i = 0;
	my $c1 = $tree->new_cursor;
	my $c2 = $tree->new_cursor;
	while (my @pair = $c1->each) {
		is_deeply([ $c1->current ], \@pair);
		is_deeply(\@pair, $sorted[$i++]);

		$c2->each; 
		my @pair = $c2->each;
		is_deeply(\@pair, $sorted[1]);
		$c2->reset;
	}
}

runtests;
