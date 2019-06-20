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
	mv -v /usr/lib/libacl.so.* /lib
	ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

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
