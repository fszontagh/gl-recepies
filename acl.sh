#
# Package: acl
# 
#
file_name="${name}"-"${version}".tar.gz
url=http://quantum-mirror.hu/mirrors/pub/gnusavannah/acl/${file_name}
strip=1
arch=x86_64
configure_options="--prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/$name-$version"


function post_make() {
	cd ${1}
	mv -v ${1}/usr/lib/libacl.so.* ${1}/lib/
	ln -sfv ../../lib/libacl.so.1 ${1}/usr/lib/libacl.so
	mkdir -p ${1}/usr/share/doc
	install -v -m644 ${1}/doc/*.txt ${1}/usr/share/doc/acl-$version
}

function pre_make() {
		echo "Executing make..."
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
