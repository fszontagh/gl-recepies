#
# Package: bzip2
# Tested version: bzip2 1.0.6
# http://www.bzip.org/$version/bzip2-$version.tar.gz
file_name="${name}"-"${version}".tar.gz
url=https://netix.dl.sourceforge.net/project/bzip2/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=" \
					--prefix=/usr \
					--sysconfdir=/etc \
					--localstatedir=/var \
					--disable-static"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	echo -en "";
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
	cd ${SOURCE_DIR}
	
	if [ ! -e "../bzip2-$version-install_docs-1.patch" ]; then
		cd ..	
		#pach to docs
		wget http://www.linuxfromscratch.org/patches/lfs/development/bzip2-${version}-install_docs-1.patch
		#patch to DESTDIR variable
		wget https://pub.sortix.org/sortix/release/nightly/patches/${name}.patch
		cd ${SOURCE_DIR}
		patch -Np1 -i ../bzip2-$version-install_docs-1.patch
		patch -Np1 -i ../${name}.patch
		sed -i 's@\(ln -s -f \)/bin/@\1@' Makefile
		sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile		
	fi;
	
}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "Configuring in : ${1}..."
	cd ${1}
	#no configure for bzip2
	#./configure ${configure_options}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -f Makefile-libbz2_so
	make clean
	make DESTDIR="${1}" install
	#make -j${NUMCPU} && make DESTDIR="${1}" install
}
