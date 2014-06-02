use v6;
use Test;
use Crypt::BCrypt;

plan *;

{

my Crypt::BCrypt $bc .= new();

my @chars = @('a'..'z', 0..9);
# shuffle the array, just because
@chars .= pick(*);

sub addchars(int $many) {
	my $s = '';
	
	loop (my $i = 0; $i < $many; $i++) {
		$s ~= @chars.pick;
	}
	return $s;
}	

my $pw = addchars(72);

my $salt = $bc.gensalt();
my $hash = $bc.hashpw($pw, $salt);
ok $hash, 'hashed random string';

my $newpw = $pw ~ addchars(42);
is $newpw.chars, 114, 'added extra chars to string';

isnt $pw, $newpw, 'pw and newpw are not the same';
is $hash, Crypt::BCrypt.hashpw($newpw, $salt), 'hashes match < 72 chars';

my $smallerpw = addchars(32);
my $smallerhash = $bc.hashpw($smallerpw, $salt);
ok $smallerhash, 'hashed smaller string';

my $newsmallerpw = $smallerpw ~ addchars(32);
is $newsmallerpw.chars, 64, 'added extra chars';

isnt $smallerpw, $newsmallerpw, 'are not the same';
isnt $smallerhash, Crypt::BCrypt.hashpw($newsmallerpw, $salt), 'not a match';

}

my $salt = '$2a$12$.cmkW62Nm/tipf3XcROriO';
is Crypt::BCrypt.hashpw("Perl 6", $salt),
	'$2a$12$.cmkW62Nm/tipf3XcROriOO8hKebDCPzOAEOI/dNS8uGZ0Wrrzy/G',
	'matches known hash';

$salt = '$2a$12$UDCJu2r7zilM3D/y7LCZoO';
is Crypt::BCrypt.hashpw("Crypt::BCrypt", $salt),
	'$2a$12$UDCJu2r7zilM3D/y7LCZoO4jIZ1tBKMd6H/0Sb2.uT/rmreooZovi',
	'matches known hash';

$salt = '$2a$12$c6mo1k8Hw.u5o1NXemxj1e';
is Crypt::BCrypt.hashpw(
	'~!@#$%^&*()_-+=qwertyuiopasdfghjklzxcvbnm1234567890{}[]<>?/.,`',
	$salt),
	'$2a$12$c6mo1k8Hw.u5o1NXemxj1eLdGEwF72DAERG9qtE5me17oH4DZcYf6',
	'non-alpha chars matches known hash';

# vim: ft=perl6
