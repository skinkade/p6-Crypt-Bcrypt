# Crypt::Bcrypt #
Bcrypt password hashing in Perl6.

## Synopsis ##
```
use Crypt::Bcrypt;

# 2^12 rounds by default
my $hash = bcrypt-hash("password");
my $hard-hash = bcrypt-hash("password", :rounds(15));

bcrypt-match("password", $hash);   # True
bcrypt-match("password1", $hash);   # False
```

## Windows ##
Windows support is absent, though planned.

## Credit ##

This module uses the Openwall crypt\_blowfish library by Solar Designer. See http://www.openwall.com/crypt/ and the header of
[crypt\_blowfish.c](ext/crypt_blowfish-1.3/crypt_blowfish.c) for details.

## License ##

The Openwall library is licensed and redistributed under the terms outlined in the header of [crypt\_blowfish.c](ext/crypt_blowfish-1.3/crypt_blowfish.c). Any modifications are released under the same terms.

This module is released under the terms of the ISC License.
See the [LICENSE](LICENSE) file for details.
