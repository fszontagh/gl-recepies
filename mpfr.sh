#
# Package: mpfr
# Tested version: mpfr 4.0.2
#
file_name="${name}"-"${version}".tar.xz
url=https://www.mpfr.org/mpfr-current/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options="--prefix=/usr --enable-thread-safe --libdir=/lib --docdir=/usr/share/doc/mpfr-${version}"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	rm -rf ${PKG}/usr/share/info/dir
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en "" 
	cd ..
	wget http://www.linuxfromscratch.org/patches/downloads/${name}/${name}-${version}-upstream_fixes-3.patch
	cd ${SOURCE_DIR}
	patch -Np1 -i ../${name}-${version}-upstream_fixes-3.patch	
}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "Configuring in : ${1}..."
	cd ${1}
	./configure ${configure_options}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -j${NUMCPU} 
	make DESTDIR="${1}" install
	make html
	make DESTDIR="${1}" install-html	
}
