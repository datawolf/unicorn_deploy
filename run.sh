#!/usr/bin/env bash
set -ex

kvm --curses \
	-drive if=virtio,file=build/hd.img \
	-rtc base=utc,clock=host \
	-enable-kvm \
	-cpu host \
	-m 1024 \
	-net nic,vlan=0,model=virtio -net user,vlan=0,hostfwd=tcp::2222-:22,hostname=unicorn-dev
