#!/bin/bash
cd /tmp
tar xvfz /home/ingres/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64.tgz
cd /home/ingres/ingres
tar xvf /tmp/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64/ingres.tar
export II_SYSTEM=/home/ingres
export LD_LIBRARY_PATH=/home/ingres/ingres/lib
export PATH=$PATH:/home/ingres/ingres/bin:/home/ingres/ingres/utility
install/ingbuild -all -acceptlicense -exresponse -file=/home/ingres/ingrsp.rsp /tmp/ingresvw-2.0.2-121-NPTL-com-linux-ingbuild-x86_64/ingres.tar 