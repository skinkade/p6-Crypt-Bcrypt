use v6;
use NativeCall;

sub crypt(Str $key, Str $setting)
	returns Str
	is native('libcrypt.so')
	{*}

sub crypt_gensalt(Str $prefix, Int $count, Str $input, Int $size)
	returns Str
	is native('libowcrypt.so')
	{*}

class Crypt::BCrypt {
	method gensalt($rounds = 12) returns Str {
		if ($rounds !~~ 4..31) {
			die "rounds must be from 4 to 31";
		}

		my $salt = "thisisatest12456";
		return crypt_gensalt('$2a$', $rounds, $salt, 128);
	}

	method hashpw($password, $salt) returns Str {
		return crypt($password, $salt);
	}
}

# vim: ft=perl6
