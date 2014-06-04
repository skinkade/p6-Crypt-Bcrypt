use Panda::Common;
use Panda::Builder;
use LibraryMake;

class Build is Panda::Builder {
	method build($dir) {
		shell("mkdir -p $dir/blib/lib");
		make("$dir/ext/crypt_blowfish-1.2", "$dir/blib/lib");
	}
}
