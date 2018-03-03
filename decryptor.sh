#!/bin/bash

IP_ENC_FILE="curr_ip_enc.txt"
IP_NOENC_FILE="curr_ip.txt"

if [ $# -gt 0 ]; then
  key=$(realpath $1)
else
  if [ -f $IP_NOENC_FILE ]; then
    cd "$(dirname "$0")"
    cat $IP_NOENC_FILE
    exit
  fi
fi

cd "$(dirname "$0")"

git pull origin master > /dev/null 2>&1

if [ -f $IP_INC_FILE ]; then
  if [ $# -gt 0 ]; then
    if [ -f $IP_ENC_FILE ]; then
      openssl rsautl -decrypt -inkey $key -in $IP_ENC_FILE
    elif [ -f $IP_NOENC_FILE ]; then
      cat $IP_NOENC_FILE
    else
      echo "No curr_ip file found..."
    fi
  else
    echo "Must provide jetson_ip_reporter_key.pem file location."
  fi
fi
