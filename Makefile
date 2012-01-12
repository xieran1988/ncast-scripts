
cross := $(PWD)/buildroot/output/host/opt/ext-toolchain/bin/arm-none-linux-gnueabi-

fshome-src:
	make -C fshome CC=$(cross)gcc

poweroff-all:
	./pwr.pl 1
	./pwr.pl 3

uboot:
	make CROSS_COMPILE=$(cross) ARCH=arm sbc3530_config -C u-boot
	make CROSS_COMPILE=$(cross) ARCH=arm -C u-boot

dsplink-arm:
	make cross=$(cross) kerndir=$(PWD)/linux-2.6 -C dsplink-src arm

dsplink-mod:
	make cross=$(cross) kerndir=$(PWD)/linux-2.6 -C dsplink-src mod

linux:
	make CROSS_COMPILE=$(cross) KERNEL_CONFIG=$(shell pwd)/linux-3530-config ARCH=arm uImage -C linux-2.6

linux-ema:
	make CROSS_COMPILE=$(cross) KERNEL_CONFIG=$(shell pwd)/linux-ema-3530-config ARCH=arm uImage -C linux-2.6-ema

linux-ema-config:
	make ARCH=arm menuconfig KERNEL_CONFIG=$(shell pwd)/linux-ema-3530-config -C linux-2.6-ema
	cp linux-ema/.config linux-ema-3530-config

linux-config:
	make ARCH=arm menuconfig KERNEL_CONFIG=$(shell pwd)/linux-3530-config -C linux-2.6
	cp linux-2.6/.config linux-3530-config

kermitshell-3530:
	./bootboard.pl kermrc3530 0 kermitshell

kermitshell-8168:
	./bootboard.pl kermrc8168 2 kermitshell

ubootshell-3530:
	./bootboard.pl kermrc3530 0 ubootshell

ubootshell-8168:
	./bootboard.pl kermrc8168 2 ubootshell

test-uImage-3530:
	./bootboard.pl kermrc3530 0 testkernel uImage-3530
	
test-linux-3530:
	./bootboard.pl kermrc3530 0 testkernel linux-2.6/arch/arm/boot/uImage

test-linux-ema-3530:
	./bootboard.pl kermrc3530 0 testkernel linux-2.6-ema/arch/arm/boot/uImage

test-linux-8168: 
	./bootboard.pl kermrc8168 2 testkernel linux-2.6/arch/arm/boot/uImage

emafs2-3530:
	./bootboard.pl kermrc3530 0 fs nand emafs2 args3530

.PHONY: simplefs-3530 simplefs-8168 tifs-8168 encode-3530

zcnfs:
	./bootboard.pl kermrc3530 0 fs nand none zcnfs

simplefs-3530:
	./bootboard.pl kermrc3530 0 fs nand simplefs-3530 args3530

simplefs-8168:
	./bootboard.pl kermrc8168 2 fs uImage-dm816x-evm.bin simplefs-8168 args8168

tifs-8168:
	./bootboard.pl kermrc8168 2 fs tifs-8168/boot/uImage-2.6.37 tifs-8168 args8168

mmcfs-8168:
	./bootboard.pl kermrc8168 2 fs uImage-dm816x-evm.bin mmc args8168

rebuild-busybox-and-test-8168:
	make -C buildroot busybox-rebuild
	make mknfs-simplefs
	make simplefs-8168

encode-demo:
	make -C tisdk omx-examples
	sudo cp -v encode-bin simplefs-8168/root
	make poweroff-all
	make open-and-telnet-8168 cmd="./encode.sh"

capture-encode-3530:
	make -C encode-3530
	sudo cp -v encode-3530/encode simplefs-3530/root
	make open-and-telnet-3530 cmd="./encode -v /tmp/1.264 -x"

capture-encode-demo:
	make -C tisdk omx-examples
	sudo cp -v capture-encode-bin simplefs-8168/root
	make poweroff-all
	make open-and-telnet-8168 cmd="./capture-encode.sh"

aragofs-8168:
	./bootboard.pl kermrc8168 2 fs uImage-dm816x-evm.bin aragofs args8168
	
mknfs-simplefs-8168:
	sudo bash mksimplefs.sh 8168 

mknfs-simplefs-3530:
	sudo bash mksimplefs.sh 3530

telnet-3530:
	./telnet.pl 192.168.1.36 "${cmd}" "${eof}"

tenet-8168:
	./telnet.pl 192.168.1.37 "${cmd}" "${eof}"

enter-fs-and-exit-3530:
	./bootboard.pl kermrc3530 0 enterfs nand simplefs-3530 args3530

enter-fs-and-exit-8168:
	./bootboard.pl kermrc8168 2 enterfs uImage-dm816x-evm.bin simplefs-8168 args8168

open-and-telnet-3530: 
	make telnet-3530 cmd="${cmd}" eof="${eof}" || \
		( make enter-fs-and-exit-3530; make telnet-3530 cmd="${cmd}" eof="${eof}" )

open-and-telnet-8168: 
	make telnet-8168 cmd="${cmd}" eof="${eof}" || \
		( make enter-fs-and-exit-8168; make telnet-8168 cmd="${cmd}" eof="${eof}" )

rinetd:
	rinetd -c rinetd.conf -f

root-test:
	sudo touch /etc/init.d/kkk

