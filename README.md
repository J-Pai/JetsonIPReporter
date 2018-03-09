# Jetson IP Reporter
This repository contains code that can be used to locate and upload the wlan0 or eth0 IP addresses to a centralized location. Assuming the Jetson is connected to the internet, when the upload_up.sh script is ran, it will obtain the IP address and store it in an encrypted text file. The script will then add all the changes made to the repository and commit the changes to the remote origin repository. The file can be accessed and decrypted using the included decryptor.sh script will allow the user to decrypt the file and obtain the IP address using the auto-generated private key stored in the directory keys.

Note: The directory keys and its contents are NOT committed alongside any changes made to the repository. You will need to move the file jetson_ip_reporter_key.pem to any locations where you would like to decrypt the curr_up_enc.txt file.

The upload_ip.sh script is meant to be executed on startup of the Jetson TX2 and allows users to quickly upload the Jetson's IP address (for ssh or other remote connections) somewhere on the internet for easier access. This is designed to allow users to take advantage of free services like GitHub.

## Requirements and Setup
### Requirements
* Ubuntu 16.04
* bash
* git

### Setup
First clone this repostory and enter the repository.
```bash
git clone https://github.com/J-Pai/JetsonIPReporter.git
cd JetsonIPReporter
```
Then create a remote repository using your preferred service (GitHub, GitLab, Bitbucket).

NOTE: Make sure you are able to push to the repository using ssh keys. In order to allow this script to run without human intervention, an ssh key must be added in order to avoid username/password authentication. Google "GitHub SSH authentication" if you are not sure what this is.

Change the origin repository to use that new remote repository. Make sure to use the ssh url (make sure your remote service supports this type of push). The following is an EXAMPLE of how to do this. Make sure to change the URL to the correct remote repository.
```bash
git remote set-url origin git@github.com:J-Pai/JetsonIPReporter.git
```
Next, make sure to update your ssh config file (typically located at ~/.ssh/config) and add the following lines:
```bash
host <HOST OF REMOTE GIT REPO>
  HostName <HOSTNAME OF REMOTE GIT REPO>
  IdentityFile <LOCATE OF SSH PRIVATE KEY>
  User git
```
An exampe:
```bash
host github.com
  HostName github.com
  IdentityFile ~/.ssh/key
  User git
```
NOTE: Usually, the service you are using will have instructions on how to set this up.

Test if you have push access to the repository using the following command:
```bash
ssh -T git@<HOST OF REMOTE GIT REPO>
```
From here, the script should be able to commit the curr_ip_enc.txt document to the remote repostiory of your choice.

## Usage
To obtain and commit the Jetson's IP address run the following command:
```bash
./upload_ip.sh
```
If you are running this script for the first time, it will generate a director called keys. Inside the directory there should be two keys, jetson_ip_reporter_key.pem and pub_key.pem. The file jetson_ip_reporter_key.pem is the PRIVATE key and is used to decrypt the encrypted IP address file (curr_ip_enc.txt).

This script will also add the curr_ip_enc.txt file to the local repository and then commit it to the remote repository.

When you want to access the IP address from another system, simply clone the remote repository on the desired system. Copy over the private key (jetson_ip_reporter_key.pem) and use the included decryptor.sh script (with the path of the private key as an argument) to decrypt and obtain the IP address from the curr_ip_enc.txt file.

It is possible to commit the IP address without encrypting it. The commands to do that can be found later in this document.

Decrypt curr_up_enc.txt:
```bash
./decryptor.sh $LOCATION_OF_JETSON_IP_REPORTER_KEY_PEM
```
If you are fine with uploading the IP address in it's unencrypted format, simply attach a no-encrypt flag when running the upload_ip.sh script.
```bash
./upload_ip.sh no-encrypt
```

## Setting up Startup Autorun
1. Open up /etc/rc.local with a text editor (make sure to use sudo).
2. Add before the line `exit 0` the following lines:
```bash
touch /tmp/upload_ip.log
su nvidia /path/to/repo/upload_ip_auto >> /tmp/upload_ip.log &
```
NOTE: The upload_ip_auto checks runs a while loop that checks GitHub. Make sure to change that to the remote repo that you are using.

3. Save the file
4. Reboot
