#!/bin/sh -
#===============================================================================
# vim: softtabstop=4 shiftwidth=4 expandtab fenc=utf-8 spell spelllang=en cc=81
#===============================================================================


#--- FUNCTION ----------------------------------------------------------------
# NAME: __function_defined
# DESCRIPTION: Checks if a function is defined within this scripts scope
# PARAMETERS: function name
# RETURNS: 0 or 1 as in defined or not defined
#-------------------------------------------------------------------------------
__function_defined() {
    FUNC_NAME=$1
    if [ "$(command -v $FUNC_NAME)x" != "x" ]; then
        echoinfo "Found function $FUNC_NAME"
        return 0
    fi
    
    echodebug "$FUNC_NAME not found...."
    return 1
}

#--- FUNCTION ----------------------------------------------------------------
# NAME: __strip_duplicates
# DESCRIPTION: Strip duplicate strings
#-------------------------------------------------------------------------------
__strip_duplicates() {
    echo $@ | tr -s '[:space:]' '\n' | awk '!x[$0]++'
}

#--- FUNCTION ----------------------------------------------------------------
# NAME: echoerr
# DESCRIPTION: Echo errors to stderr.
#-------------------------------------------------------------------------------
echoerror() {
    printf "${RC} * ERROR${EC}: $@\n" 1>&2;
}

#--- FUNCTION ----------------------------------------------------------------
# NAME: echoinfo
# DESCRIPTION: Echo information to stdout.
#-------------------------------------------------------------------------------
echoinfo() {
    printf "${GC} * INFO${EC}: %s\n" "$@";
}

#--- FUNCTION ----------------------------------------------------------------
# NAME: echowarn
# DESCRIPTION: Echo warning informations to stdout.
#-------------------------------------------------------------------------------
echowarn() {
    printf "${YC} * WARN${EC}: %s\n" "$@";
}

#--- FUNCTION ----------------------------------------------------------------
# NAME: echodebug
# DESCRIPTION: Echo debug information to stdout.
#-------------------------------------------------------------------------------
echodebug() {
    if [ $_ECHO_DEBUG -eq $BS_TRUE ]; then
        printf "${BC} * DEBUG${EC}: %s\n" "$@";
    fi
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __apt_get_install_noinput
#   DESCRIPTION:  (DRY) apt-get install with noinput options
#-------------------------------------------------------------------------------
__apt_get_install_noinput() {
    apt-get install -y -o DPkg::Options::=--force-confold $@; return $?
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __apt_get_upgrade_noinput
#   DESCRIPTION:  (DRY) apt-get upgrade with noinput options
#-------------------------------------------------------------------------------
__apt_get_upgrade_noinput() {
    apt-get upgrade -y -o DPkg::Options::=--force-confold $@; return $?
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __pip_install_noinput
#   DESCRIPTION:  (DRY)
#-------------------------------------------------------------------------------
__pip_install_noinput() {
    pip install --upgrade $@; return $?
}


__enable_universe_repository() {
    if [ "x$(grep -R universe /etc/apt/sources.list /etc/apt/sources.list.d/ | grep -v '#')" != "x" ]; then
        # The universe repository is already enabled
        return 0
    fi

    echodebug "Enabling the universe repository"

    # Ubuntu versions higher than 12.04 do not live in the old repositories
    if [ $DISTRO_MAJOR_VERSION -gt 12 ] || ([ $DISTRO_MAJOR_VERSION -eq 12 ] && [ $DISTRO_MINOR_VERSION -gt 04 ]); then
        add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" || return 1
    elif [ $DISTRO_MAJOR_VERSION -lt 11 ] && [ $DISTRO_MINOR_VERSION -lt 10 ]; then
        # Below Ubuntu 11.10, the -y flag to add-apt-repository is not supported
        add-apt-repository "deb http://old-releases.ubuntu.com/ubuntu $(lsb_release -sc) universe" || return 1
    fi

    add-apt-repository -y "deb http://old-releases.ubuntu.com/ubuntu $(lsb_release -sc) universe" || return 1

    return 0
}

__check_unparsed_options() {
    shellopts="$1"
    # grep alternative for SunOS
    if [ -f /usr/xpg4/bin/grep ]; then
        grep='/usr/xpg4/bin/grep'
    else
        grep='grep'
    fi
    unparsed_options=$( echo "$shellopts" | ${grep} -E '(^|[[:space:]])[-]+[[:alnum:]]' )
    if [ "x$unparsed_options" != "x" ]; then
        usage
        echo
        echoerror "options are only allowed before install arguments"
        echo
        exit 1
    fi
}

configure_cpan() {
    (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan > /dev/null
}

usage() {
    echo "usage"
    exit 1
}

install_ubuntu_deps() {
    apt-get update

    __apt_get_install_noinput python-software-properties || return 1

    __enable_universe_repository || return 1

    add-apt-repository -y ppa:sift/$@ || return 1

    apt-get update

    __apt_get_upgrade_noinput || return 1

    return 0
}

install_ubuntu() {
    packages="sift sift-scripts 4n6time-static aeskeyfind afflib-tools afterglow aircrack-ng arp-scan autopsy binplist bitpim bitpim-lib bless blt build-essential bulk-extractor cabextract clamav cryptsetup dc3dd dconf-tools dff dumbpig e2fslibs-dev ent epic5 etherape exif extundelete f-spot fdupes flare flasm flex foremost fuse-utils g++ gcc gdb ghex gthumb hal hal-info hexedit honeyd htop hydra hydra-gtk ipython kdiff3 kpartx libafflib0 libafflib-dev libbde libbde-tools libesedb libesedb-tools libevt libevt-tools libevtx libevtx-tools libewf libewf-dev libewf-python libewf-tools libfuse-dev libfvde libfvde-tools liblightgrep libmsiecf libnet1 libolecf libparse-win32registry-perl libregf libregf-dev libregf-python libregf-tools libssl-dev libtext-csv-perl libvshadow libvshadow-dev libvshadow-python libvshadow-tools libxml2-dev maltegoce md5deep myunity nbd-client netcat netpbm nfdump ngrep ntopng okular openjdk-6-jdk p7zip-full phonon pv pyew python python-dev python-pip python-analyzemft python-flowgrep python-nids python-ntdsxtract python-pefile python-plaso python-qt4 python-tk pytsk3 rsakeyfind safecopy sleuthkit ssdeep ssldump stunnel4 tcl tcpflow tcpstat tcptrace tofrodos torsocks transmission unrar upx-ucl vbindiff virtuoso-minimal winbind wine wireshark xmount zenity regripper jd-gui cmospwd ophcrack ophcrack-cli bkhive samdump2 cryptcat outguess bcrypt ccrypt readpst ettercap-graphical driftnet tcpreplay tcpxtract tcptrack p0f netwox lft netsed socat knocker nikto nbtscan radare-gtk python-yara gzrt testdisk scalpel qemu qemu-utils gddrescue dcfldd vmfs-tools guymager mantaray python-fuse samba open-iscsi curl git system-config-samba libpff libpff-dev libpff-tools libpff-python xfsprogs gawk fuse-exfat exfat-utils"

    if [ "$@" = "dev" ]; then
        packages="$packages"
    elif [ "$@" = "stable" ]; then
        packages="$packages"
    fi

    __apt_get_install_noinput $packages || return 1

    return 0
}

install_pip_packages() {
    pip_packages="rekall docopt"

    if [ "$@" = "dev" ]; then
        pip_packages="$pip_packages"
    elif [ "$@" = "stable" ]; then
        pip_packages="$pip_packages"
    fi

    __pip_install_noinput $pip_packages || return 1

    return 0
}

install_perl_modules() {
	# Required by macl.pl script
	perl -MCPAN -e "install Net::Wigle" > /dev/null
}

configure_ubuntu() {
	if [ ! -d /cases ]; then
		mkdir -p /cases
	fi

	for dir in usb vss shadow windows_mount e01 aff ewf bde iscsi
	do
		if [ ! -d /mnt/$dir ]; then
			mkdir -p /mnt/$dir
		fi
	done

	for NUM in 1 2 3 4 5
	do
		if [ ! -d /mnt/windows_mount$NUM ]; then
			mkdir -p /mnt/windows_mount$NUM
		fi
		if [ ! -d /mnt/ewf$NUM ]; then
			mkdir -p /mnt/ewf$NUM
		fi
	done
 
	for NUM in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
	do
		if [ ! -d /mnt/shadow/vss$NUM ]; then
			mkdir -p /mnt/shadow/vss$NUM
		fi
		if [ ! -d /mnt/shadow_mount/vss$NUM ]; then
			mkdir -p /mnt/shadow_mount/vss$NUM
		fi
	done
	
	if [ ! -L /usr/bin/vol.py ]; then
		ln -s /usr/bin/vol /usr/bin/vol.py
	fi
	if [ ! -L /usr/bin/log2timeline ]; then
		ln -s /usr/bin/log2timeline_legacy /usr/bin/log2timeline
	fi
	if [ ! -L /usr/bin/kedit ]; then
		ln -s /usr/bin/gedit /usr/bin/kedit
	fi
	if [ ! -L /usr/bin/mount_ewf.py ] && [ ! -e /usr/bin/mount_ewf.py ]; then
		ln -s /usr/bin/ewfmount /usr/bin/mount_ewf.py
	fi
}

configure_ubuntu_skin() {
	if [ ! -d /home/$SUDO_USER/.config/autostart ]; then
		sudo -u $SUDO_USER mkdir -p /home/$SUDO_USER/.config/autostart
	fi

	sudo -u $SUDO_USER gsettings set org.gnome.desktop.background picture-uri file:///usr/share/sift/images/forensics_blue.jpg
	sudo -u $SUDO_USER dconf write /desktop/unity/launcher/favorites "['nautilus.desktop', 'gnome-terminal.desktop', 'firefox.desktop', 'gnome-screenshot.desktop', 'gcalctool.desktop', 'bless.desktop', 'dff.desktop', 'autopsy.desktop', 'wireshark.desktop']"

	if [ ! -L /home/$SUDO_USER/Desktop/cases ]; then
		sudo -u $SUDO_USER ln -s /cases /home/$SUDO_USER/Desktop/cases
	fi
  
	if [ ! -L /home/$SUDO_USER/Desktop/mount_points ]; then
		sudo -u $SUDO_USER ln -s /mnt /home/$SUDO_USER/Desktop/mount_points
	fi

	# Clean up broken symlinks
	find -L /home/$SUDO_USER/Desktop -type l -delete

	for file in /usr/share/sift/resources/*.pdf
	do
		base=`basename $file`
		if [ ! -L /home/$SUDO_USER/Desktop/$base ]; then
			sudo -u $SUDO_USER ln -s $file /home/$SUDO_USER/Desktop/$base
		fi
	done
	
	if [ ! -L /home/$SUDO_USER/.config/autostart ]; then
		sudo -u $SUDO_USER cp /usr/share/sift/other/gnome-terminal.desktop /home/$SUDO_USER/.config/autostart
	fi
    
	if [ ! -e /usr/share/unity-greeter/logo.png.ubuntu ]; then
		sudo cp /usr/share/unity-greeter/logo.png /usr/share/unity-greeter/logo.png.ubuntu
		sudo cp /usr/share/sift/images/login_logo.png /usr/share/unity-greeter/logo.png
	fi

	gsettings set com.canonical.unity-greeter background file:///usr/share/sift/images/forensics_blue.jpg

	# Checkout code from sift-files and put these files into place
	CDIR=$(pwd)
	git clone https://github.com/sans-dfir/sift-files /tmp/sift-files
	cd /tmp/sift-files
	bash install.sh
	cd $CDIR
	rm -r -f /tmp/sift-files

	service smbd restart

	# Make sure to remove all ^M from regripper plugins
	# Not sure why they are there in the first place ...
	dos2unix -ascii /usr/share/regripper/*

	OLD_HOSTNAME=$(hostname)
	sed -i "s/$OLD_HOSTNAME/siftworkstation/g" /etc/hosts
	echo "siftworkstation" > /etc/hostname
	hostname siftworkstation
}


complete_message() {
    echo
    echo "Installation Complete!"
    echo 
    echo "The documentation included with the SIFT package is for the 2.14 version"
    echo "it is included as a reference, but please realize there may be things that"
    echo "do not apply"
    echo 
    echo "New documentation is in the works."
    echo
    echo "http://sift.readthedocs.org"
    echo
}

complete_message_skin() {
    echo "The hostname was changed, you should relogin or reboot for it to take full effect."
    echo
    echo "sudo reboot"
    echo
}

CONFIGURE_ONLY=0
SKIN=0
INSTALL=1
YESTOALL=0

OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)


if [ $OS != "Ubuntu" ]; then
    echo "SIFT is only installable on Ubuntu operating systems at this time."
    exit 1
fi

if [ $ARCH != "64" ]; then
    echo "SIFT is only installable on a 64 bit architecture at this time."
    exit 2
fi

if [ $VER != "12.04" ]; then
    echo "SIFT is only installable on Ubuntu 12.04 at this time."
    exit 3
fi

if [ `whoami` != "root" ]; then
    echo "SIFT Bootstrap must be run as root!"
    exit 3
fi

if [ "$SUDO_USER" = "" ]; then
    echo "The SUDO_USER variable doesn't seem to be set"
    exit 4
fi


while getopts ":hvcsiy" opt
do
case "${opt}" in
    h ) usage; exit 0 ;;  
    v ) echo "$0 -- Version $__ScriptVersion"; exit 0 ;;
    s ) SKIN=1 ;;
    i ) INSTALL=1 ;;
    c ) CONFIGURE_ONLY=1; INSTALL=0; SKIN=0; ;;
    y ) YESTOALL=1 ;;
    \?) echo
        echoerror "Option does not exist: $OPTARG"
        usage
        exit 1
        ;;
esac
done

shift $(($OPTIND-1))

if [ "$#" -eq 0 ]; then
    ITYPE="stable"
else
    __check_unparsed_options "$*"
    ITYPE=$1
    shift
fi

# Check installation type
if [ "$(echo $ITYPE | egrep '(dev|stable)')x" = "x" ]; then
    echoerror "Installation type \"$ITYPE\" is not known..."
    exit 1
fi


echo "Welcome to the SIFT Bootstrap"
echo "This script will now proceed to configure your system."

if [ "$YESTOALL" -eq 1 ]; then
    echo "You supplied the -y option, this script will not exit for any reason"
fi

if [ "$SKIN" -eq 1 ] && [ "$YESTOALL" -eq 0 ]; then
    echo
    echo "You have chosen to apply the SIFT skin to your ubuntu system."
    echo 
    echo "You did not choose to say YES to all, so we are going to exit."
    echo
    echo "Your current user is: $SUDO_USER"
    echo
    echo "Re-run this command with the -y option"
    echo
    exit 10
fi

if [ "$INSTALL" -eq 1 ] && [ "$CONFIGURE_ONLY" -eq 0 ]; then
    install_ubuntu_deps $ITYPE
    install_ubuntu $ITYPE
    install_pip_packages $ITYPE
    configure_cpan
    install_perl_modules
fi

configure_ubuntu

if [ "$SKIN" -eq 1 ]; then
    configure_ubuntu_skin
fi

complete_message

if [ "$SKIN" -eq 1 ]; then
    complete_message_skin
fi
