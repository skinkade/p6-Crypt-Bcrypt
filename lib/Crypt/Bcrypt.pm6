use v6;
use NativeCall;
use LibraryMake;

sub library {
	my $so = get-vars('')<SO>;
	for @*INC {
		if ($_~'/crypt_blowfish'~$so).IO ~~ :f {
			return $_~'/crypt_blowfish'~$so;
		}
	}
	die "unable to find library crypt_blowfish";
}

sub crypt(Str $key, Str $setting)
	returns Str
	# is native('crypt_blowfish.so')
	{*}
trait_mod:<is>(&crypt, :native(library));

sub crypt_gensalt(Str $prefix, Int $count, Str $input, Int $size)
	returns Str
	# is native('crypt_blowfish.so')
	{*}
trait_mod:<is>(&crypt_gensalt, :native(library));

class Crypt::Bcrypt {
	
	sub rand_chars(Int $chars = 16) {
		my $fh = open('/dev/urandom');
		my $bin = $fh.read($chars);
		$fh.close();
		return $bin.list.fmt('%c', '');
	}

	method gensalt($rounds = 12) returns Str {
		# lower limit is log2(2**4 = 16) = 4
		# upper limit is log2(2**31 = 2147483648) = 31
		die "rounds must be between 4 and 31"
			unless $rounds ~~ 4..31;

		my $salt = rand_chars();
		return crypt_gensalt('$2a$', $rounds, $salt, 128);
	}

	method hashpw($password, $salt) returns Str {
		# bcrypt limits passwords to 72 characters
		return crypt($password.substr(0, 72), $salt);
	}
}

# vim: ft=perl6
