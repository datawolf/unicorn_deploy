#!/usr/bin/env bash
set -ex

cd $(dirname $0)

curl -fL http://containeros.huawei.com/containeros/latest/x86_84/unicornos.iso > unicornos.iso
rm -fr build
mkdir -p build/openstack/latest

cat > build/openstack/latest/user_data << EOF
#!/bin/bash
set -e

trap "poweroff" EXIT

mount -t 9p -o trans=virtio,version=9p2000.L config-2 /mnt

touch log
openvt -s -- tail -f log &
ros install -d /dev/vda -f --no-reboot > log 2>&1

touch /mnt/success
EOF

rm -f build/{success,hd.img}
qemu-img create -f qcow2  build/hd.img 8G
kvm -curses \
	-drive if=virtio,file=build/hd.img \
	-cdrom unicornos.iso \
	-m 1024 \
	-fsdev local,id=conf,security_model=none,path=$(pwd)/build \
	-device virtio-9p-pci,fsdev=conf,mount_tag=config-2

echo Install UnnicornOS done.
