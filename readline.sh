#
# Package: readline
# Tested version: readline 8.0
#
file_name="${name}"-"${version}".tar.gz
url=http://ftp.gnu.org/gnu/readline/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options="--prefix=/usr --docdir=/usr/share/doc/${name}-${version}"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	
	mkdir -p ${PKG}/lib
	mv -v ${PKG}/usr/lib/lib{readline,history}.so.* ${PKG}/lib

	mkdir -p ${PKG}/usr/share/doc/readline-${version}
	cd ${SOURCE_DIR}
	install -v -m644 doc/*.{ps,pdf,html,dvi} ${PKG}/usr/share/doc/readline-${version}
	cd ${PKG}
	rm -rv ${PKG}/usr/bin
	ln -sfv ../../lib/libreadline.so.8 ${PKG}/usr/lib/libreadline.so
	ln -sfv ../../lib/libhistory.so.8 ${PKG}/usr/lib/libhistory.so	
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
	cd ${SOURCE_DIR}
	sed -i '/MV.*old/d' Makefile.in
	sed -i '/{OLDSUFF}/c:' support/shlib-install
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
	make -j${NUMCPU} SHLIB_LIBS=-lncurses && make DESTDIR="${1}" SHLIB_LIBS=-lncurses install
}
