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
direction=$1
if [ -z "$2" ]
  then
    direction="east"
fi
ssh -i ~/.ssh/id_jetson -XC nvidia@$ip x2x -big -$direction -to :0
