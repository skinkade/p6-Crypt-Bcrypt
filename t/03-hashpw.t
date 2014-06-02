use v6;
use Test;
use Crypt::BCrypt;

plan 25;

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

my Str $prefix = '$2a$';
my Int $rounds;
my Str $suffix = '$';
$salt = 'PerlSix.PERL6/perlSIX6';

my Str %hashes = Hash.new();

# only test up to 15, starts getting too resource intensive past that point
loop ($rounds = 4; $rounds < 16; $rounds++) {
	my $fs = $prefix ~ $rounds.Str.fmt('%02d') ~ $suffix ~ $salt;
	my $cr =  Crypt::BCrypt.hashpw(
		'~!@#$%^&*()_-+=qwertyuiopasdfghjklzxcvbnm1234567890{}[]<>?/.,`'
		~ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		$fs);
	%hashes.push($rounds.Str => $cr);
}

is %hashes<<4>>, '$2a$04$PerlSix.PERL6/perlSIXug.BVcuaH9f0thr1zP8j0BEKoQpC91tS';
is %hashes<<5>>, '$2a$05$PerlSix.PERL6/perlSIXu0Ulqn0FfCV2F1/VFMwFwIGJWobE4yZa';
is %hashes<<6>>, '$2a$06$PerlSix.PERL6/perlSIXu7OYsPEGakXjzlyJZvhniDko1s1uZpxe';
is %hashes<<7>>, '$2a$07$PerlSix.PERL6/perlSIXu5jjs.08X80R660rqpwedi2e5R0PJnbC';
is %hashes<<8>>, '$2a$08$PerlSix.PERL6/perlSIXuvXlWHac4qdb/qW5ki1gyOL6NG6JtaaG';
is %hashes<<9>>, '$2a$09$PerlSix.PERL6/perlSIXuXGF55SH7fDiud/2IetcaUMzUFubfKH.';
is %hashes<<10>>, '$2a$10$PerlSix.PERL6/perlSIXukAcH7Vc1otuJmwl9LcHvwFjsTs.NZ9y';
is %hashes<<11>>, '$2a$11$PerlSix.PERL6/perlSIXudXkJN57VFBQM36d2QDMF5TmLl8RdXG.';
is %hashes<<12>>, '$2a$12$PerlSix.PERL6/perlSIXuVdb09aNyMg4j1fwcGyon8cxOT/Ubb6W';
is %hashes<<13>>, '$2a$13$PerlSix.PERL6/perlSIXuvvzVLS5BAbSouFfia2Q87SocsFyBkP2';
is %hashes<<14>>, '$2a$14$PerlSix.PERL6/perlSIXuK2jAo/WxZW5Ss5xg6Tpty/fR5L236Oa';
is %hashes<<15>>, '$2a$15$PerlSix.PERL6/perlSIXugXvY1a1c8BzmnTO0taVrZ3Rv3..OOyC';

is '$2a$12$qXOgQR5cAL2JClCe4sYx0e6qh1Ar1CrcP6CJDFfcUJX7Gw5mLF7Xi',
	Crypt::BCrypt.hashpw('Perl Six!', '$2a$12$qXOgQR5cAL2JClCe4sYx0e'),
	'known hash matches';
isnt '$2a$12$qXOgQR5cAL2JClCe4sYx0e6qh1Ar1CrcP6CJDFfcUJX7Gw5mLF7Xi',
	Crypt::BCrypt.hashpw('Perl 6!', '$2a$12$qXOgQR5cAL2JClCe4sYx0e'),
	'incorrect string does not match';



# vim: ft=perl6
