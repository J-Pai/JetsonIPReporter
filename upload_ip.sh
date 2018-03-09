#!/bin/bash
encrypt=true
KEY_FILE="./keys/jetson_ip_reporter_key.pem"
PUB_KEY_FILE="./keys/pub_key.pem"
IP_ENC_FILE="curr_ip_enc.txt"
IP_NOENC_FILE="curr_ip.txt"

date

cd "$(dirname "$0")"

for var in "$@"; do
  if [ $var = "no-encrypt" ]; then
    encrypt=false
  fi
done

jetson_wlan_ip=$(ifconfig wlan0 | grep -Po 't addr:\K[\d.]+')
echo "Jetson's Wifi IP $jetson_wlan_ip"
jetson_eth_ip=$(ifconfig eth0 | grep -Po 't addr:\K[\d.]+')
echo "Jetson's Ethernet IP $jetson_eth_ip"

if [ $encrypt = true ]; then
  echo "Will Encrypt"
  if [ ! -f $KEY_FILE ]; then
    echo "Encryption Key file does not exist. Generating new Key file."
    echo "Location: $KEY_FILE"
    if [ ! -d ./keys ]; then
      mkdir keys
    fi
    openssl genrsa -out $KEY_FILE 4096
    openssl rsa -in $KEY_FILE -pubout -out $PUB_KEY_FILE
  fi

  echo "wlan0=$jetson_wlan_ip" >> $IP_NOENC_FILE
  echo "eth0=$jetson_eth_ip" >> $IP_NOENC_FILE
  openssl rsautl -encrypt -inkey $PUB_KEY_FILE -pubin -in $IP_NOENC_FILE -out $IP_ENC_FILE
  rm $IP_NOENC_FILE
else
  echo "Will not Encrypt"
  echo "wlan0=$jetson_wlan_ip" >> $IP_NOENC_FILE
  echo "eth0=$jetson_eth_ip" >> $IP_NOENC_FILE
fi

git add --all
git commit -m "Updated Jetson IP Address"
git push origin master

exit 0
