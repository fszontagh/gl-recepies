#
# Package: p11-kit
# Tested version: p11-kit 0.23.16.1
#
file_name="${name}"-"${version}".tar.gz
url=https://github.com/p11-glue/p11-kit/releases/download/${version}/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options="--prefix=/usr --sysconfdir=/etc --with-trust-paths=/etc/pki/anchors"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	ln -sfv /usr/libexec/p11-kit/trust-extract-compat ${PKG}/usr/bin/update-ca-certificates
	ln -sfv ./pkcs11/p11-kit-trust.so ${PKG}/usr/lib/libnssckbi.so
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	
	sed '20,$ d' -i trust/trust-extract-compat.in &&
cat >> trust/trust-extract-compat.in << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Generate a new trust store
/usr/sbin/make-ca -f -g
EOF
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
	make -j${NUMCPU} && make DESTDIR="${1}" install
}
