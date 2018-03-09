#!/bin/bash
ip=""
IFS=" = "
while read -r name value; do
  echo "Content of $name is ${value//\"/}"
  if [ ! -z $value ]; then
    echo "Using $name"
    ip=$value
  fi
done <<< $(./408iIP/decryptor.sh jetson_ip_reporter_key.pem)
echo "Using $ip"
ssh -i ~/.ssh/id_jetson -XC nvidia@$ip
