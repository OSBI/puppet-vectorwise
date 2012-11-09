#!/bin/bash
mkdir /mnt/ingres/ingres
cd /tmp
tar xvfz /mnt/ingres/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz
cd /mnt/ingres/ingres
tar xvf /tmp/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64/ingres.tar
export II_SYSTEM=/mnt/ingres
export LD_LIBRARY_PATH=/mnt/ingres/ingres/lib
export PATH=$PATH:/mnt/ingres/ingres/bin:/mnt/ingres/ingres/utility
install/ingbuild -all -acceptlicense -exresponse -file=/mnt/ingres/ingrsp.rsp /tmp/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64/ingres.tar 