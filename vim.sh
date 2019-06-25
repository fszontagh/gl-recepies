#
# Package: vim
# Tested version: vim 8.1
#
file_name="${name}"-"${version}".tar.bz2
url=ftp://ftp.vim.org/pub/vim/unix/${file_name}
strip=1
arch=x86_64
#the default configure options
configure_options="--prefix=/usr --enable-multibyte --enable-gui=no --with-x=no --disable-gpm"
curdir=`pwd`

function post_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} is equal with the ${SOURCE_DIR}
	
	ln -sv vim ${PKG}/usr/bin/vi
	for L in ${PKG}/usr/share/man/{,*/}man1/vim.1; do
			ln -sv vim.1 $(dirname $L)/vi.1
	done
	ln -sv ../vim/vim${version/./}/doc ${PKG}/usr/share/doc/vim-${version}
	rm -rfv ${PKG}/usr/share/applications
	rm -rfv ${PKG}/usr/share/icons
	mkdir -p ${PKG}/etc
	cp -p ${RECEPIES}/vim.post.install.sh ${PKG}/post.install.sh
	chmod 777 ${PKG}/post.install.sh
}

function pre_make() {
	#${PKG} is the package dir
	#${SOURCE_DIR} is the source dir, where run the compile and the make
	#${1} there is no parameter to the function.
	# This function called before configure on the source
	echo -en ""
	mkdir -pv ${PKG}/usr/share/locale
}

function configure() {
	#${1} is the source dir
	#${SOURCE_DIR} is equal with the ${1}
	echo "Configuring in : ${1}..."
	cd ${1}
	echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
	./configure ${configure_options}
}

function build() {
	#${1} is the target directory, where the raw binaries will be saved
	#${SOURCE_DIR} is the sources dir
	# Default, the make running in the ${SOURCE_DIR}, because the configure function cding into this dir
	echo "Starting build... ${name} in ${SOURCES}"
	make -j${NUMCPU} && make DESTDIR="${1}" DEST_HELP=${PKG}/usr/share/doc/vim-${version} LANGSUBLOC=/usr/share/locale install
}
