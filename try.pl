#!/usr/bin/perl

# Quick script I have used for debugging some features.

use Data::Dumper;
use Tree::BPTree;

my $teststr = 'ANDREW STERLING HANENKAMP';
my @splitstr = split //, $teststr;

my $i = 0;
my $tree = Tree::BPTree->new;
print Dumper($tree);
for (@splitstr) {
	$tree->insert($_, $i++);
	print Dumper($tree);
}

$tree->reverse;
print Dumper($tree);

$i = 0;
for (@splitstr) {
	$tree->delete($_, $i++);
	print Dumper($tree);
}
