use v6;
use Test;
use Crypt::Bcrypt;

plan 7;

ok Crypt::Bcrypt.new(), 'module loads';
ok Crypt::Bcrypt.gensalt(), 'gensalt called';
ok Crypt::Bcrypt.hashpw(Str.new(), Crypt::Bcrypt.gensalt()), 'hashpw called';

my Crypt::Bcrypt $bc .= new();
ok $bc, 'object created';
ok $bc ~~ Crypt::Bcrypt, 'is Crypt::Bcrypt object';
ok $bc.gensalt(), 'gensalt called from object';
ok $bc.hashpw(Str.new(), $bc.gensalt()), 'hashpw called from object';

# vim: ft=perl6
