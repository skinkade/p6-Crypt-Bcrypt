use v6;
use NativeCall;
use LibraryMake;

=begin LICENSE

Copyright (c) 2014-2015, carlin <cb@viennan.net>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

=end LICENSE

sub library returns Str {
	my $so = get-vars('')<SO>;
	for @*INC {
	    my $inc-path = $_.IO.path.subst(/ ['file#' || 'inst#'] /, '');
	    my $crypt-blowfish-lib-path = $*SPEC.catfile($inc-path, "crypt_blowfish"~$so);
		if $crypt-blowfish-lib-path.IO ~~ :f {
			return $crypt-blowfish-lib-path;
		}
	}
	die 'unable to find library crypt_blowfish';
}

sub crypt(Str $key, Str $setting)
	returns Str
	# is native('crypt_blowfish.so')
	{*}
trait_mod:<is>(&crypt, :native(library));

sub crypt_gensalt(Str $prefix, int32 $count, Str $input, int32 $size)
	returns Str
	# is native('crypt_blowfish.so')
	{*}
trait_mod:<is>(&crypt_gensalt, :native(library));

class Crypt::Bcrypt {
	
	sub rand_chars(Int $chars = 16) returns Str {
		my $fh = open('/dev/urandom');
		my $bin = $fh.read($chars);
		$fh.close();
		return $bin.list.fmt('%c', '');
	}

	method gensalt(Int $rounds = 12) returns Str {
		# lower limit is log2(2**4 = 16) = 4
		# upper limit is log2(2**31 = 2147483648) = 31
		die "rounds must be between 4 and 31"
			unless $rounds ~~ 4..31;

		my $salt = rand_chars();
		return crypt_gensalt('$2a$', $rounds, $salt, 128);
	}

	method hash(Str $password, Str $salt) returns Str {
		# bcrypt limits passwords to 72 characters
		return crypt($password.substr(0, 72), $salt);
	}

	method compare(Str $password, Str $hash) returns Bool {
		return Crypt::Bcrypt.hash($password, $hash)
		eq $hash;
	}
}

# vim: ft=perl6
