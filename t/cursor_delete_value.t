# vim: set ft=perl :

use strict;
use warnings;

use Storable qw( dclone );
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

plan tests => 48 * @splitstr;

sub test {
	my ($tree) = @_;

	# We need to make a deep copy of each of the buckets too or else the buckets
	# will empty and never refill for the later tests!
	my @pairs = @{ dclone(\@sorted) }; 

	my $i = 0;
	my $cursor = $tree->new_cursor;
	while (my @pair = $cursor->next) {
		# We must copy here or iteration over the values in the bucket will fail
		# when the values are dropped from the bucket.
		my @values = @{$pair[1]};
		for my $value (@values) {
			$cursor->delete($value);
			shift @{$pairs[0][1]};
			if (@{$pairs[0][1]} == 0) {
				shift @pairs;
			}

			is_deeply([ $tree->pairs ], \@pairs);
		}
	}
}

runtests;
