use Panda::Common;
use Panda::Builder;

class Build is Panda::Builder {
	method build($dir) {
		chdir("ext/crypt_blowfish-1.2");
		run('make');
		chdir($dir);
	}
}
