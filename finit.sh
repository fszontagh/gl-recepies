#
# Package: finit
# Tested version: finit 3.1
#
file_name="${name}"-"${version}".tar.xz
url=https://github.com/troglobit/finit/releases/download/${version}/${file_name}
strip=1
arch=x86_64
libisplugin=1
configure_options="--prefix=/usr \
					--sysconfdir=/etc \
					--localstatedir=/var \
					--enable-resolvconf-plugin \
					--enable-dbus-plugin \
					--enable-redirect \
					--enable-watchdog \
					--enable-progress \
					--enable-rw-rootfs"


function post_make() {
	mkdir -p ${PKG}/etc/finit.d/available
	
#create default finit conf file	
cat > "${PKG}/etc/finit.conf" << "EOF"
#/etc/finit.conf - System bootstrap

# System hostname is set from /etc/hostname
#host default

# Default runlevel is 2
runlevel 2
# Check root filesystem
#check /dev/sda1

# run network script to set up interfaces
#network /etc/init.d/networking

# System patch or extension scripts, see run-parts(8), built-in support in Finit.
# You can also use /etc/rc.local for smaller things.
#runparts /mnt/start.d

# Inetd services
# Allow telnet on standard port only if not from WAN (eth0)
# Allow telnet onport 2323 from WAN (don't do this kids)
# Built-in rdate service also available on custom port 3737, notice internal.time
#inetd ftp/tcp              nowait [2345] /sbin/uftpd -i -f       -- FTP daemon
#inetd tftp/udp               wait [2345] /sbin/uftpd -i -y       -- TFTP daemon
#inetd time/udp               wait [2345] internal                -- UNIX rdate service
#inetd time/tcp             nowait [2345] internal                -- UNIX rdate service
#inetd 3737/tcp             nowait [2345] internal.time           -- UNIX rdate service
#inetd 2323/tcp@eth0       nowait [2345] /sbin/telnetd -i -F     -- Telnet daemon (WAN)
#inetd telnet/tcp@*,!eth0   nowait [2345] /sbin/telnetd -i -F     -- Telnet daemon (LAN)
#inetd 222/tcp@eth0         nowait [2345] /sbin/dropbear -i -R -F -- SSH daemon (WAN)
#inetd ssh/tcp@*,!eth0      nowait [2345] /sbin/dropbear -i -R -F -- SSH daemon (LAN)

# Allow login on ttyUSB0, for systems with no dedicated console port
#tty [12345] /dev/ttyAMA0 115200 vt100 noclear
#tty  [2345] /dev/ttyUSB0 115200 vt100 noclear

# Systems using a serial console can use this arch. neutral variant
#tty [12345] @console 115200 linux noclea	

# Load modules
module ohci_hcd
module button
module evdev
module mousedev
module 8139cp


#default getties
tty [12345] /dev/tty1 115200 vt100 noclear nowait
tty [2345]  /dev/tty2  38400 linux noclear nowait
tty [2345]  /dev/tty3  38400 linux noclear nowait
tty [2345]  /dev/tty7  38400 linux noclear nowait

EOF


}

function pre_make() {
		echo -en ""
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
