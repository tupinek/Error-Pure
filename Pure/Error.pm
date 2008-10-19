#------------------------------------------------------------------------------
package Error::Pure::Error;
#------------------------------------------------------------------------------

# Pragmas.
use strict;

# Modules.
use Error::Pure qw(_err);
use Error::Pure::Output::Text qw(err_pretty);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub err(@) {
#------------------------------------------------------------------------------
# Process error.

	my $msg = \@_;
	my $errors = Error::Pure::_err($msg);

	# Finalize in main on last err.
	my $stack = $errors->[-1]->{'stack'};
	if ($stack->[-1]->{'class'} eq 'main'
		&& ! grep({ $_ eq 'eval {...}' || $_ =~ /^eval '/} 
		map { $_->{'sub'} } @{$stack})) {

		CORE::die Error::Pure::Output::Text::err_pretty($errors);

	# Die for eval.
	} else {
		CORE::die "$msg->[0]\n";
	}
}

BEGIN {
        *CORE::GLOBAL::die = \&err;
}

1;
