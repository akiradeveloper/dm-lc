#!/bin/sh

# usage:
# #sh prepare.sh

. ./util.sh

fail_if_not_root

load_kmods

. ./config

echo 7 > /proc/sys/kernel/printk

# discard the whole cache device before formatting blkdiscard command is include
# in upstream util-linux. But don't worry, without discarding, dm-writeboost works
# correctly.
if which blkdiscard >/dev/null 2>&1 ; then
    blkdiscard --offset 0 --length `blockdev --getsize64 ${CACHE}` ${CACHE}
fi

# zeroing the first sector in the cache device triggers formatting the cache device
echo destroy ...
dd if=/dev/zero of=${CACHE} bs=512 count=1 oflag=direct

echo create wb device
# type = 0
sz=`blockdev --getsize ${BACKING}`
dmsetup create writeboost-vol --table "0 ${sz} writeboost 0 ${BACKING} ${CACHE} 4 segment_size_order 10 nr_rambuf_pool 8 8 enable_migration_modulator 0 allow_migrate 0 sync_interval 0 update_record_interval 0"
# type = 1
# dmsetup create writeboost-vol --table "0 ${sz} writeboost 1 ${BACKING} ${CACHE} ${PLOG} 4 segment_size_order 10 nr_rambuf_pool 8 8 enable_migration_modulator 0 allow_migrate 0 sync_interval 0 update_record_interval 0"

if [ $? -ne 0 ]; then
    echo "initialization failed. see dmseg"
    exit
fi
