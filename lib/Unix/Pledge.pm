package Unix::Pledge;

use strict;

require Exporter;

our @ISA = qw{Exporter};
our @EXPORT = qw{pledge};

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('Unix::Pledge', $VERSION);

1;
__END__

=head1 NAME

Unix::Pledge - restrict system operations 

=head1 SYNOPSIS

  use Unix::Pledge;

  # ...
  # Program initializtion, open files, fork, etc
  # ...

  # Now that we're initialized, limit our process to only perform operations on
  # /tmp as well as standard io
  pledge("stdio tmppath");

  # ...
  # Code restricted to tmp and stdio operations only
  # ...

  print "This is OK."
 
  # Further restrict our process to tmp only
  pledge("tmppath");

  print "This will fail and cause a SIGABRT, terminating the program";


=head1 DESCRIPTION
 
The current process is forced into a restricted-service operating mode.
A few subsets are available, roughly described as computation, memory
management, read-write operations on file descriptors, opening of files,
networking.  In general, these modes were selected by studying the
operation of many programs using libc and other such interfaces, and
setting promises or paths.

Requires that the kernel supports the pledge(2) syscall, which as of this
writing is only available in OpenBSD.

The pledge function takes two parameters: "promises" and "whitepaths".

"Promises" is a space delimited string of modes which the process is promising
that it will stick to from here on out.  "Whitepaths" is an optional array ref
parameter that is useful to further limit the process to operate under specific paths
only.  Paths that are not under the whitepath will return ENOENT if you attempt
to access them.

Process violations of the previously "pledged" modes will result in
your processing being forcibly terminated via SIGABRT.  In this
way pledge serves as a capabilities framework like capsicum, systrace,
AppArmor, etc.  The difference is that pledge aims to be very easy to use
for the typical developer to sandbox their process.

Note that restrictions are one way only: you can only increase the restrictions
on your process, not relax them.

=head2 ERRORS

Unix::Pledge will croak on any errors.



=head2 EXPORT

The "pledge" function is exported by default.

=head1 SEE ALSO

For detailed information on pledge, its parameters and errors, please see the
L<OpenBSD pledge(2) man page|http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man2/pledge.2?query=pledge>.

L<Github repo|https://github.com/rfarr/Unix-Pledge>


=head1 AUTHOR

Richard Farr C<< <richard@nxbit.io> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Richard Farr

This module is licensed under the same terms as perl itself.

=cut
