#
# Package: tzdata
# Tested version: tzdata 2019a
#
file_name="${name}${version}".tar.gz
url=http://www.iana.org/time-zones/repository/releases/${file_name}
strip=0
arch=noarch
#the default configure options
configure_options=""

timezones=('africa' 'antarctica' 'asia' 'australasia'
           'europe' 'northamerica' 'southamerica'
           'pacificnew' 'etcetera' 'backward'
           'systemv')


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	cd ${SOURCE_DIR}
	/usr/sbin/zic -d ${PKG}/usr/share/zoneinfo ${timezones[@]}
	/usr/sbin/zic -d ${PKG}/usr/share/zoneinfo/posix ${timezones[@]}
	/usr/sbin/zic -d ${PKG}/usr/share/zoneinfo/right -L leapseconds ${timezones[@]}
	/usr/sbin/zic -d ${PKG}/usr/share/zoneinfo -p America/New_York
	install -m444 -t ${PKG}/usr/share/zoneinfo iso3166.tab zone.tab	
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
	[ $USER = "root" ] || { echo "You must run this as root! Exiting..."; exit; }
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
	echo "No build for this pkg...";
}
