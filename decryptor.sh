#!/bin/bash

IP_ENC_FILE="curr_ip_enc.txt"
IP_NOENC_FILE="curr_ip.txt"

key=$(realpath $1)

cd "$(dirname "$0")"

git pull origin master

if [ -f $IP_INC_FILE ]; then
  if [ $# -gt 0 ]; then
    openssl rsautl -decrypt -inkey $key -in $IP_ENC_FILE
  else
    echo "Must provide jetson_ip_reporter_key.pem file location."
  fi
fi
