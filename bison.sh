#
# Package: bison
# Tested version bison 3.0.4
# 
file_name="${name}"-"${version}".tar.xz
url=http://ftp.gnu.org/gnu/${name}/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=" \
					--prefix=/usr        \
					--sysconfdir=/etc    \
					--localstatedir=/var \
					--disable-static	 \
					--docdir=/usr/share/doc/$name-$version"


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
	cd ${SOURCE_DIR}
	sed -i '6855 s/mv/cp/' Makefile.in
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
	make -j1 && make DESTDIR="${1}" install
}
