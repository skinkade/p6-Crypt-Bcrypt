use Test;

use lib 'lib';

use Crypt::Bcrypt;



my $hash = '$2a$12$7DcBeHYo9Vv9UaZIlL9iRuhy76cqZObe8UHRewQdIDBgkqKGeFBGO';

ok bcrypt-match("password", $hash), "Verify correct password";
nok bcrypt-match("password1", $hash), "False to incorrect password";



done-testing;
