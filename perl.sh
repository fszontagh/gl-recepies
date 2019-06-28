#
# Package: perl
# Tested version: perl 5.30.0
#
file_name="${name}"-"${version}".tar.gz
url=https://www.cpan.org/src/5.0/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=""

_ARCH="-Dcccdlflags='-fPIC'"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}

	find ${PKG} -iname 'TODO*' -or -iname 'Change*' -or -iname 'README*' -or -name '*.bs' -or -name .packlist -or -name perllocal.pod | xargs rm
	find ${PKG} -depth -empty -exec rmdir {} \;
	chmod -R +w ${PKG}
	unset BUILD_ZLIB BUILD_BZIP2

}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "No gnu configure"
	cd ${1}
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0	
	cd ${SOURCE_DIR}
	
sh Configure -des  -Dusethreads \
	-Dprefix=/usr -Duseshrplib -Dscriptdir=/usr/bin \
	-Dvendorbin=/usr/bin -Dsitebin=/usr/bin \
	-Dvendorprefix=/usr -Dinc_version_list=none \
	-Darchlib=/usr/lib/share/perl5/base \
	-Dprivlib=/usr/lib/share/perl5/base \
	-Dvendorlib=/usr/lib/share/perl5/vendor \
	-Dvendorarch=/usr/lib/perl5/vendor \
	-Dsitelib=/usr/lib/perl5/site \
	-Dsitearch=/usr/lib/perl5/site \
	-Dman1dir=/usr/share/man/man1 \
	-Dman3dir=/usr/share/man/man3 \
	-Dpager="/usr/bin/less isR" ${_ARCH}	
	
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -j${NUMCPU} && make DESTDIR="${1}" install
}
