#
# Package: make-ca
# Tested version: make-ca 1.4
#
file_name="${name}"-"${version}".xz
url=https://github.com/djlucas/make-ca/releases/download/v${version}/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=""


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	ln -sfv /etc/pki/tls/certs/ca-bundle.crt ${PKG}/etc/ssl/ca-bundle.crt
	echo "Adding cron..."
	install -vdm755 ${PKG}/etc/cron.weekly
cat > /etc/cron.weekly/update-pki.sh << EOF
#!/bin/bash
/usr/sbin/make-ca -g
EOF
	chmod 754 ${PKG}/etc/cron.weekly/update-pki.sh	
	echo "Copy post install script..."
	cp -pv ${RECEPIES}/make-ca.post.install.sh ${PKG}/post.install.sh	
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
	echo "No configure..."
	cd ${1}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make DESTDIR="${1}" install
}
