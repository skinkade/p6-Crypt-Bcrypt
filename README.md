# Crypt::Bcrypt #

This is an implementation of bcrypt for Perl 6

## Example ##

	use Crypt::Bcrypt;
	my $salt = Crypt::Bcrypt.gensalt(10);
	my $hash = Crypt::Bcrypt.hash("My password", $salt);
	
	my $password_attempt = Crypt::Bcrypt.hash("My password", $hash);

	if (Crypt::Bcrypt.compare("My password", $hash)) {
		say 'O frabjous day! Callooh! Callay!'
	}
	else {
		say 'Does not match :-(';
	}

## Methods ##

 - `gensalt(Int $rounds = 12)`

	Generates a salt
	The generated salt includes a prefix specifying the number of rounds
	that the password will be hashed with when the returned salt is 
	passed to `hash`

 - `hash(Str $password, Str $salt)`

	Generates a hash of the password, using the settings from the salt
	The salt should be generated using gensalt but can be passed manually

	The salt can also be a fully qualified bcrypt hash, this is useful
	if you want to compare a string against a known hash

 - `compare(Str $password, Str $hash) returns Bool`

	Compares a password with a hash

	Returns True if the given hash was created with the provided plain text

## Requirements ##

Your system must be capable of compiling the provided libraries

This should work on most Unix variants, however Windows is not currently
supported as the library depends on the existance of /dev/urandom

Confirmed working on rakudo running on the MoarVM

## How to ##

First get your system ready for compiling
If you installed a Perl 6 implementation from source you probably already
meet this requirement

On Debian-based systems this can be achieved like this:

	apt-get install build-essential

On openSUSE you can do:

	zypper in --type pattern devel_basis

### Panda ###

This module can be installed using panda:

	panda install Crypt::Bcrypt

Alternatively, you can clone the respository using git. After that, if you have
Panda installed, you can build the library by running `panda-build`.
You can then run the tests using `panda-test` and install using `panda-install`.
Once installed the module can be used like any other module, or you can
manually run the tests just like any other Perl 6 code:

	perl6 t/01-basic.t

### Pandamonium ###

If you do not have Panda installed, you should really install Panda. However,
if you want to build the library without Panda you can run:

	perl6 Configure.pl6

This builds the crypt_blowfish library and puts it in the lib/ directory.
You can then run the tests like this:

	PERL6LIB=lib perl6 t/01-basic.t


## Contact ##

carlin in #perl6 on Freenode

## Credit ##

This module uses the Openwall crypt_blowfish library by Solar Designer. See http://www.openwall.com/crypt/ and the header of
[crypt_blowfish.c](ext/crypt_blowfish-1.2/crypt_blowfish.c) for details.

This module contains a local copy of [LibraryMake](https://github.com/retupmoca/P6-LibraryMake), for use during build time, as some system configurations have issues loading dependencies when running Build.pm.

## License ##

The Openwall library is licensed and redistributed under the terms outlined in the header of [crypt_blowfish.c](ext/crypt_blowfish-1.2/crypt_blowfish.c). Any modifications are released under the same terms.

LibraryMake is redistributed with this module under the terms of the MIT license. See the [LICENSE](ext/LibraryMake/LICENSE) and the header of [LibraryMake.pm6](ext/LibraryMake/LibraryMake.pm6) for details.

This module is licensed under the ISC License. See the [LICENSE](LICENSE) file for details.
