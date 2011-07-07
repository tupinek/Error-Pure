package Error::Pure::Error;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(err_helper);
use Error::Pure::Output::Text qw(err_pretty);
use List::MoreUtils qw(none);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);
Readonly::Scalar my $EVAL => 'eval {...}';

# Version.
our $VERSION = 0.01;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

# Process error.
sub err {
	my @msg = @_;

	# Get errors structure.
	my $errors_ar = err_helper(@msg);

	# Finalize in main on last err.
	my $stack_ar = $errors_ar->[-1]->{'stack'};
	if ($stack_ar->[-1]->{'class'} eq 'main'
		&& none { $_ eq $EVAL || $_ =~ m/^eval '/ms }
		map { $_->{'sub'} } @{$stack_ar}) {

		die err_pretty($errors_ar);

	# Die for eval.
	} else {
		my $e = $errors_ar->[-1]->{'msg'}->[0];
		chomp $e;
		die "$e\n";
	}
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure::Error - Error::Pure class with error on one line with informations.

=head1 SYNOPSIS

 use Error::Pure::Error qw(err);
 err 'This is a fatal error', 'name', 'value';

=head1 SUBROUTINES

=over 8

=item B<err(@messages)>

 Process error with messages @messages.

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Error qw(err);

 # Error.
 err '1';

 # Output:
 # #Error [example1.pl:9] 1

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Error qw(err);

 # Error.
 err '1', '2', '3';

 # Output:
 # #Error [example2.pl:9] 1

=head1 DEPENDENCIES

L<Error::Pure::Utils(3pm)>,
L<Error::Pure::Output::Text(3pm)>,
L<Exporter(3pm)>,
L<List::MoreUtils(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Error::Pure(3pm)>,
L<Error::Pure::AllError(3pm)>,
L<Error::Pure::Clean(3pm)>,
L<Error::Pure::Die(3pm)>,
L<Error::Pure::ErrorList(3pm)>,
L<Error::Pure::Output::Text(3pm)>,
L<Error::Pure::Print(3pm)>,
L<Error::Pure::Utils(3pm)>.

=head1 AUTHOR

 Michal Špaček L<skim@cpan.org>
 http://skim.cz

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
