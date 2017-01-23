#!/bin/bash

cd /mnt/storage-bak/
/usr/bin/rsync -vp -a -H --delete /mnt/storage/ /mnt/storage-bak/ > /var/log/rsyncStorage.log
