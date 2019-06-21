#
# Package: sudo
# Tested version: sudo 1.8.12
#
file_name="${name}"-"${version}".tar.gz
url=http://www.sudo.ws/sudo/dist/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options="		--prefix=/usr 							\
						--libexecdir=/usr/lib 					\
						--docdir=/usr/share/doc/sudo-$version 	\
						--with-all-insults 						\
						--with-env-editor 						\
						--without-sendmail 						\
						--with-passprompt='[sudo] password for %p: '"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}



mkdir -pv ${PKG}/etc/pam.d

cat > ${PKG}/etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 ${PKG}/etc/pam.d/sudo
	
sed -i 's/#%sudo   ALL=(ALL) ALL/%sudo   ALL=(ALL) ALL/g' ${PKG}/etc/sudoers
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
