#!/bin/bash
# Retrieve user uploaded kdb file from mykeystore container

source_filename=current_keypass.kdb
source_server=mykeystore-kfmaster.alaudacn.me
source_dir=keypass_store
source_url=http://${source_server}/${source_dir}/${source_filename}

tgt_dir="/keepass"
tgt_filename=MyKeePass.kdbx

timestamp=`date`

echo "The retrieve_kdbfile process is running since ${timestamp}."

while true
do
    cd ${tgt_dir}
    ping -c 5 ${source_server} 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        wget_output=$(wget -q ${source_url})
        if [ $? -eq 0 ]; then
           wget ${source_url} -O ${tgt_dir}/${tgt_filename} 1>/dev/null 2>&1
        fi
    fi
    rm -f /keepass/current_keypass.kdb.*
done
