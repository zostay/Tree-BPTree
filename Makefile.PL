use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME			=> 'Tree::BPTree',
	VERSION_FROM	=> 'BPTree.pm',
	AUTHOR			=> 'Andrew Sterling Hanenkamp <hanenkamp@users.sourceforge.net>',
	ABSTRACT_FROM	=> 'BPTree.pm',
	PM				=> { 'BPTree.pm' => '$(INST_LIBDIR)/BPTree.pm' }
);
