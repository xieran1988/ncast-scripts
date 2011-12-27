mod=$1
fs=simplefs-$mod
tar -cvf $fs-root.tar $fs/root;
rm -rf $fs
mkdir $fs
tar -xvf buildroot/output/images/rootfs.tar -C $fs 
cd $fs/etc/init.d
mv S40network K40network
cd ../..
sed -i '$atelnetd -l /bin/sh' etc/init.d/rcS 
sed -i '$alighttpd -f /root/lighttpd.conf' etc/init.d/rcS 
chmod 777 root
mkdir etc/profile.d
echo 'echo fuck boss yang' > etc/profile.d/a.sh
rm etc/securetty
cp ../inittab-$mod etc/inittab
cd ..
tar -xvf $fs-root.tar
[ $mod = '8168' ] && {
	tar -xvf libncurses.tar -C $fs
	tar -xvf libtinfo.tar -C $fs
}
exit 0

