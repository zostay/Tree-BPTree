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

plan tests => 48 * @sorted;

sub test {
	my ($tree) = @_;

	my @pairs = @sorted;

	my $i = 0;
	my $cursor = $tree->new_cursor;
	while (my @pair = $cursor->next) {
		$cursor->delete;
		shift @pairs;
		is_deeply([ $tree->pairs ], \@pairs);
	}
}

runtests;
