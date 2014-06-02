use v6;
use Test;
use Crypt::BCrypt;

is Crypt::BCrypt.hashpw(
	'',
	'$2a$12$VgRlJiQzRMIXoi7fLnXRWOOkuXydB1qA5ALEoYYNHi55Z0vJxV0GS'
),
'$2a$12$VgRlJiQzRMIXoi7fLnXRWOOkuXydB1qA5ALEoYYNHi55Z0vJxV0GS',
'empty string';



# vim: ft=perl6
