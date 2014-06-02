use v6;
use Test;
use Crypt::BCrypt;

plan 7;

ok Crypt::BCrypt.new(), 'module loads';
ok Crypt::BCrypt.gensalt(), 'gensalt called';
ok Crypt::BCrypt.hashpw(Str.new(), Crypt::BCrypt.gensalt()), 'hashpw called';

my Crypt::BCrypt $bc .= new();
ok $bc, 'object created';
ok $bc ~~ Crypt::BCrypt, 'is BCrypt object';
ok $bc.gensalt(), 'gensalt called from object';
ok $bc.hashpw(Str.new(), $bc.gensalt()), 'hashpw called from object';

# vim: ft=perl6
