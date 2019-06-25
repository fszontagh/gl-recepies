#
# Package: xfsprogs
# Tested version: xfsprogs 5.0.0
#
file_name="${name}"-"${version}".tar.xz
url=https://www.kernel.org/pub/linux/utils/fs/xfs/${name}/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=""


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	rm -rfv ${PKG}/lib/libhandle.{a,la,so}
	ln -sfv ../../lib/libhandle.so.1 ${PKG}/usr/lib/libhandle.so
	rm ${PKG}/usr/lib/libhandle.la
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
	
	cd ${1}
	echo "Skipping configure..."
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${1}"	
	
	make -j${NUMCPU} DEBUG=-DNDEBUG INSTALL_USER=root INSTALL_GROUP=root LOCAL_CONFIGURE_OPTIONS="--enable-readline"
	make DIST_ROOT=${1} PKG_DOC_DIR=/usr/share/doc/${name}-${version} install
	make DIST_ROOT=${1} PKG_DOC_DIR=/usr/share/doc/${name}-${version} install-dev
	
}
