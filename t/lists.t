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
my @sorted_pairs = 
	sort { $a->[0] cmp $b->[0] }
	map { [ $_, $seen{$_} ] } 
	keys(%seen);
my @sorted_keys = map { $$_[0] } @sorted_pairs;
my @sorted_values = map { $$_[1] } @sorted_pairs;
my @sorted_flattened_values = map { @$_ } @sorted_values;

my @letters = ('A' .. 'Z', 'a' .. 'z');
my @matches = map { qr/^$letters[$_]/ } map { int(rand(scalar(@letters))) } 0 .. 9;

plan tests => 3 * 48;

sub test {
	my ($tree) = @_;

	is_deeply([ $tree->keys ], \@sorted_keys);
	is_deeply([ $tree->values ], \@sorted_values);
	is_deeply([ $tree->flattened_values ], \@sorted_flattened_values);
}

runtests;
