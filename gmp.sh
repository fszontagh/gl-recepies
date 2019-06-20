#
# Package: gmp
# Tested version: gmp 6.1.2
#
file_name="${name}"-"${version}".tar.xz
url=ftp://ftp.gmplib.org/pub/gmp-${version}/${file_name}
strip=1
arch=x86_64
configure_options="--prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-${version}"


function post_make() {
	cd ${PKG}
	rm -rf ${PKG}/usr/share/info/dir
	# Documentation
	mkdir -p ${PKG}/usr/share/doc/gmp-${version}
	cp doc/{isa_abi_headache,configuration} doc/*.html ${PKG}/usr/share/doc/gmp-${version}	
}

function pre_make() {
		echo "Executing make..."
		
}

function configure() {
		echo "Configuring in : ${1}..."		
		cd ${1}		
		cp -v configfsf.guess config.guess
		cp -v configfsf.sub   config.sub		
		
		./configure ${configure_options} 
}

function build() {
		echo "Starting build... ${name} in ${SOURCES}"
		make -j${NUMCPU} && make DESTDIR="${1}" install && make DESTDIR="${1}" html
}
