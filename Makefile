
cross := $(PWD)/buildroot/output/host/opt/ext-toolchain/bin/arm-none-linux-gnueabi-

fshome-src:
	make -C fshome CC=$(cross)gcc

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

emafs-3530:
	./bootboard.pl kermrc3530 0 fs nand emafs

emafs2-3530:
	./bootboard.pl kermrc3530 0 fs nand emafs2

simplefs-8168:
	./bootboard.pl kermrc8168 2 fs uImage-dm816x-evm.bin simplefs


