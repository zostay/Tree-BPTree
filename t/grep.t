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

my @letters = ('A' .. 'Z', 'a' .. 'z');
my @matches = map { qr/^$letters[$_]/ } map { int(rand(scalar(@letters))) } 0 .. 9;

plan tests => 4 * 10 * 48;

sub test {
	my ($tree) = @_;

	for my $i (0 .. $#matches) {
		my $treematch = sub { $_[0] =~$matches[$i] };
		my $listmatch = sub { $$_[0] =~ $matches[$i] };
		is_deeply([ $tree->grep($treematch) ],
				  [ grep {&$listmatch($_)} @sorted_pairs ]);

		is_deeply([ $tree->grep_keys($treematch) ],
				  [ map { $_->[0] } grep {&$listmatch($_)} @sorted_pairs ]);

		is_deeply([ $tree->grep_values($treematch) ],
				  [ map { $_->[1] } grep {&$listmatch($_)} @sorted_pairs ]);

		is_deeply([ $tree->grep_flattened_values($treematch) ],
				  [ map { @{$_->[1]} } grep {&$listmatch($_)} @sorted_pairs ]);
	}
}

runtests;
