##############################
# Alfred Centos 7 Base
# Tag: kanalfred/fileserver
#
# Refer:
# https://www.howtoforge.com/samba-server-installation-and-configuration-on-centos-7
#
# Create volume container:
# docker create -v /home/alfred/workspace/docker/data/fileserver/mnt:/mnt --name data-fileserver centos:7
#
# Run:
# docker run -e 'ROOT_PASSWORD=test123' -h fileserver --name fileserver -p 2201:22 -d kanalfred/fileserver
# docker run -h fileserver --name fileserver -p 2201:22 -p 445:445 -p 139:139 -p 135:135 -p 137:137/udp -p 138:138/udp -d kanalfred/fileserver
# docker run -h fileserver --name fileserver --volumes-from data-fileserver -p 2201:22 -p 445:445 -p 139:139 -p 135:135 -p 137:137/udp -p 138:138/udp -d kanalfred/fileserver
# 
# Build:
# docker build -t kanalfred/fileserver .
#
# Dependancy:
# Centos 7
#
# Add new users:
#  smbpasswd -a share
#  # export new smb password file
#  ######pdbedit -e smbpasswd:/root/samba-users.backup
#  sudo pdbedit -L -w > /root/samba-users.backup
#  # replace with new export samba-users.backup to config/samba-users.backup
# 
# To import samba password file:
# pdbedit -i smbpasswd:/root/samba-users.backup
# 
# Check samba users
# sudo pdbedit -L -v
#
##############################

FROM kanalfred/centos7:latest
MAINTAINER Alfred Kan <kanalfred@gmail.com>

# Add Files
ADD container-files/etc /etc 
ADD container-files/config /config 

RUN \
    yum -y install \
        samba samba-client samba-common
#        openssh openssh-server openssh-clients \
#        yum clean all && \

RUN \
    # create backup of origal smb.conf
    cp /etc/samba/smb.conf /etc/samba/smb.conf.bak && \

    # create unix users
    useradd share && \
    useradd alfred && \
    useradd akimi && \

    # import samber users
    pdbedit -i smbpasswd:/config/samba-users3.backup && \

    # testing need remove
    mkdir -p /mnt/storage/share && \
    touch /mnt/storage/share/test.txt && \
    chmod 777 -R /mnt


# Clean YUM caches to minimise Docker image size
RUN yum clean all && rm -rf /tmp/yum*

# EXPOSE
# smb
expose 445
expose 139
expose 135
# nmb
expose 137/udp
expose 138/udp
#EXPOSE 22

# Run supervisord as demon with option -n 
# supervisord already triggerd from base cetnos7 image
#CMD dockerize /config/run.sh
#CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

