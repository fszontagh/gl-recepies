#
# Package: bzip2
# Tested version: bzip2 1.0.6
# http://www.bzip.org/$version/bzip2-$version.tar.gz
file_name="${name}"-"${version}".tar.gz
url=https://netix.dl.sourceforge.net/project/bzip2/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options=" \
					--prefix=/usr \
					--sysconfdir=/etc \
					--localstatedir=/var \
					--disable-static"


function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	cd ${SOURCE_DIR}
	mkdir -pv ${PKG}/{bin,lib}

	cp -v bzip2-shared ${PKG}/bin/bzip2
	cp -av libbz2.so* ${PKG}/lib
	ln -sv ../../lib/libbz2.so.1.0 ${PKG}/usr/lib/libbz2.so
	rm -v ${PKG}/usr/bin/{bunzip2,bzcat,bzip2}
	mv -v $PKG/usr/bin/* ${PKG}/bin
	for i in bzegrep bzfgrep 
	do
	  ln -svf bzgrep ${PKG}/bin/$i
	done
	for i in bunzip2 bzcat
	do
	 ln -svf bzip2 ${PKG}/bin/$i
	done
	for i in  bzless 
	do
	 ln -svf bzmore ${PKG}/bin/$i
	done
	for i in bzcmp
	do
	 ln -svf bzdiff ${PKG}/bin/$i
	done	
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
	cd ${SOURCE_DIR}
	
	if [ ! -e "../bzip2-$version-install_docs-1.patch" ]; then
		cd ..	
		#pach to docs
		wget http://www.linuxfromscratch.org/patches/lfs/development/bzip2-${version}-install_docs-1.patch
		cd ${SOURCE_DIR}
		patch -Np1 -i ../bzip2-$version-install_docs-1.patch
		sed -i 's@\(ln -s -f \)/bin/@\1@' Makefile
		sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile		
	fi;
	
}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "Configuring in : ${1}..."
	cd ${1}
	#no configure for bzip2
	#./configure ${configure_options}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -f Makefile-libbz2_so
	make clean
	make PREFIX="${1}" install
	
	#make -j${NUMCPU} && make DESTDIR="${1}" install
}
