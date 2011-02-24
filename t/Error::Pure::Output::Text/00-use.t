# Modules.
use Test::More 'tests' => 2;

BEGIN {

	# Debug message.
	print "Usage tests.\n";

	# Test.
	use_ok('Error::Pure::Output::Text');
}

# Test.
require_ok('Error::Pure::Output::Text');