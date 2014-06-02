use v6;
use Test;
use Crypt::BCrypt;

plan 14;

is Crypt::BCrypt.hashpw(
		'',
		'$2a$12$VgRlJiQzRMIXoi7fLnXRWOOkuXydB1qA5ALEoYYNHi55Z0vJxV0GS'
	),
	'$2a$12$VgRlJiQzRMIXoi7fLnXRWOOkuXydB1qA5ALEoYYNHi55Z0vJxV0GS',
	'empty string';

my @chars = @('a'..'z', 0..9);
@chars .= pick(*);

sub addchars(int $many) {
	@chars .= pick(*);
	return @chars.pick($many);
}


loop (my Int $round = 4; $round < 15; $round++) {
	my $salt = Crypt::BCrypt.gensalt($round);
	my $password = addchars(32);
	my $hash = Crypt::BCrypt.hashpw($password, $salt);

	is $hash, Crypt::BCrypt.hashpw($password, $hash),
		'reusing hash as salt-settings works';
}

my $hash = Crypt::BCrypt.hashpw('My secret password 123',
	Crypt::BCrypt.gensalt());

is $hash, Crypt::BCrypt.hashpw('My secret password 123', $hash), 'validation';
isnt $hash, Crypt::BCrypt.hashpw('Let me in 123', $hash), 'correctly fails';

# vim: ft=perl6
