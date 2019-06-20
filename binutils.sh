#
# Package: binutils
# tested on binutils 2.32
#
file_name="${name}"-"${version}".tar.xz
url=http://ftp.gnu.org/gnu/binutils/${file_name}
strip=1
arch=x86_64
configure_options="--prefix=/usr --includedir=/usr/include \
					--bindir=/bin --sbindir=/sbin \
					--datarootdir=/usr/share \
					--enable-shared \
					--disable-werror"


function post_make() {
	cd ${1}
	rm -rf ${1}/usr/share/info/dir	
	mkdir ${1}/lib
		for lib in libopcodes libbfd
		do
			mv ${1}/usr/lib/${lib}-${version}.so \
			${1}/lib/${lib}-${version}.so
			ln -s ${lib}-${version}.so  ${1}/lib/${lib}
			ln -s ../../lib/${lib}-${version}.so \
			${1}/usr/lib/${lib}-${version}.so
			ln -s ../../lib/${lib}-${version}.so \
			${1}/usr/lib/${lib}
		done	
}

function pre_make() {
		echo "Executing make..."
}

function configure() {
		echo "Configuring in : ${1}..."
		cd "${1}"
		[ -e "build" ] || mkdir -v build		
		cd build		
		../configure ${configure_options} 
}

function build() {
		echo "Starting build... ${name} in ${SOURCES}"
		cd ${SOURCE_DIR}/build
		make tooldir=/usr -j${NUMCPU} && make tooldir=/usr DESTDIR="${1}" install
}
