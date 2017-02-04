#!/bin/bash

cd /mnt/storage_bak/
/usr/bin/rsync -vp -a -H --delete /mnt/storage/ /mnt/storage_bak/ > /var/log/rsyncStorage.log
