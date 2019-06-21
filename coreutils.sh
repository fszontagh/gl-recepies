#
# Package: coreutils
# Tested version: coreutils 8.30
# 
file_name="${name}"-"${version}".tar.xz
url=http://ftp.gnu.org/gnu/$name/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options="--prefix=/usr --libexecdir=/lib --bindir=/bin --sbindir=/sbin --enable-no-install-program=kill,uptime"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	mkdir ${PKG}/sbin
	mkdir -p ${PKG}/usr/share/man/man8
	mv -v ${PKG}/bin/chroot ${PKG}/sbin
	mv -v ${PKG}/usr/share/man/man1/chroot.1 ${PKG}/usr/share/man/man8/chroot.8
	sed -i s/\"1\"/\"8\"/1 ${PKG}/usr/share/man/man8/chroot.8
	rm -rf ${PKG}/usr/share/info/dir
	mkdir -p ${PKG}/usr/bin
	mv ${PKG}/bin/env ${PKG}/usr/bin
	mv ${PKG}/bin/install ${PKG}/usr/bin 
	
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
	cd ${SOURCE_DIR}
	if [ ! -e "../$name-$version-i18n-1.patch" ]; then
		cd ..
		wget http://www.linuxfromscratch.org/patches/downloads/$name/$name-$version-i18n-1.patch
		cd ${SOURCE_DIR}
		patch -Np1 -i ../$name-$version-i18n-1.patch
		sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
	fi;
	
	
}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "Configuring in : ${1}..."
	cd ${1}
	autoreconf -fiv 
	FORCE_UNSAFE_CONFIGURE=1 ./configure ${configure_options}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -j${NUMCPU} && make DESTDIR="${1}" install
}
