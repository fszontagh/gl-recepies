#
# Package: apr
# Tested  version: apr 1.7.0
#
file_name="{$name}-${version}.tar.bz2"
url=https://archive.apache.org/dist/apr/${file_name}
strip=1
arch=x86_64
configure_options="--prefix=/usr    \
            --disable-static \
            --with-installbuilddir=/usr/share/apr-1/build"


function post_make() {
	echo -en ""
}

function pre_make() {
		echo -en ""
}

function configure() {
		echo "Configuring in : ${1}..."
		cd ${1}
		./configure ${configure_options} 
}

function build() {
		echo "Starting build... ${name} in ${SOURCES}"
		make -j${NUMCPU} && make DESTDIR="${1}" install
}
