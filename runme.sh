#!/bin/bash

function newuser {
   read -p "Enter your username: " user;
   id $user > /dev/null 2> /dev/null
   if [ $? -eq 0 ]
   then
      echo "User exists!"
      getuser
      return 0
   fi
   adduser $user
}

function fixupstart {
#make upstart work
   dpkg-divert --local --rename --add /sbin/initctl
   ln -s /bin/true/ /sbin/initctl
}

#change apt repo to oneiric
sed -i "s/natty/oneiric/g" /etc/apt/sources.list

#upgrade the system
apt-get update -y
fixupstart
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y update-manager-core
do-release-upgrade -d -f DistUpgradeViewNonInteractive

#install packages
apt-get install -y lxde-core chromium-browser

#create new user
#newuser

#clean up
rm ubuntu-natty-chroot.tgz
