#
# Package: sysklogd
# Tested version: sysklogd 1.5.1
#
file_name="${name}"-"${version}".tar.gz
url=http://www.infodrom.org/projects/sysklogd/download/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=""


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
cat > ${PKG}/etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.* -/var/log/syslog
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
sudo.* -/var/log/sudo.log
*.emerg *

# End /etc/syslog.conf
EOF

mkdir ${PKG}/etc/finit.d/available/

cat > ${PKG}/etc/finit.d/available/sysklogd.conf << "EOF"
service [S12345] /sbin/syslogd -n -f /etc/syslog.conf                       -- System log daemon
EOF


}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	cd ${SOURCE_DIR}
	sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
	sed -i 's/union wait/int/' syslogd.c
	mkdir -p ${PKG}/{/sbin,etc,usr/share/man/man{5,8}}

}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "No configure..."
	cd ${1}
	#./configure ${configure_options}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -j${NUMCPU} 
	make BINDIR=${PKG}/sbin MANDIR=${PKG}/usr/share/man install	
	
}
