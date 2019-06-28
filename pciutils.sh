#
# Package: pciutils
# Tested version: pciutils 3.6.2
#
file_name="${name}"-"${version}".tar.xz
url=https://mirrors.edge.kernel.org/pub/software/utils/pciutils/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=""


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	chmod -v 755 ${PKG}/usr/lib/libpci.so
	#for cron	
	cp -pv ${RECEPIES}/pciutils.post.install.sh ${PKG}/post.install.sh
	chmod -v 777 ${PKG}/post.install.sh
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
	echo "No configure..."	
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make PREFIX=/usr SHAREDIR=/usr/share/hwdata SHARED=yes -j${NUMCPU} all
	make PREFIX=/usr SHAREDIR=/usr/share/hwdata SHARED=yes install install-lib 	
}
