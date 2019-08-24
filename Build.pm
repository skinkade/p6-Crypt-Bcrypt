use v6;
use LibraryMake;

class Build {
    sub make(Str $folder, Str $destfolder, IO() :$libname!) {
        my %vars = LibraryMake::get-vars($destfolder);
        %vars<LIB_NAME> = ~ $*VM.platform-library-name($libname);
        mkdir($destfolder);
        LibraryMake::process-makefile($folder, %vars);
        shell(%vars<MAKE>);
    }

    method build($workdir) {
        my $destdir = 'resources/libraries';
        mkdir 'resources';
        mkdir $destdir;
        make($workdir, $destdir, :libname<bcrypt>);
        True;
    }

}

sub MAIN(Str $working-directory = '.' ) {
    Build.new.build($working-directory);
}
