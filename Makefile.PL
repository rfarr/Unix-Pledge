use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Unix::Pledge',
    VERSION_FROM      => 'lib/Unix/Pledge.pm',
    PREREQ_PM         => {},
    AUTHOR            => 'Richard Farr',
    LICENSE           => 'perl',
    dist => {
        PREOP => 'pod2text $(VERSION_FROM) > $(DISTVNAME)/README',
    },
    META_MERGE => {
        resources => {
            repository => 'git://github.com/rfarr/Unix-Pledge.git',
            bugtracker => 'https://github.com/rfarr/Unix-Pledge/issues',
        },
    },
);
