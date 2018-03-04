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
Wherever you want to obtain the the Jetson's IP address, simply clone your remote repository to another machine and copy the private key file jetson_ip_reporter_key.pem (stored in the generated directory keys) to your current system.

Obtain IP Address and Upload to remote repository:
```bash
./upload_ip.sh
```
Decrypt curr_up_enc.txt:
```bash
./decryptor.sh $LOCATION_OF_JETSON_IP_REPORTER_KEY_PEM
```
If you are fine with uploading the IP address in it's unencrypted format, simply attach a no-encrypt flag when running the upload_ip.sh script.
```bash
./upload_ip.sh no-encrypt
```
By default, the scripts looks at the wlan0 NIC for the ip address. You can set the NIC to eth0 by attaching the eth0 flag to the end of the command.
```bash
./upload_ip.sh eth0
```
Both flags can be combined for combined effects.
```bash
./upload_ip.sh no-encrypt eth0
```
Top command uses eth0 for its IP address and does not encrypt the IP address

## Setting up Startup Autorun
- Open up /etc/rc.local with a text editor (make sure to use sudo).
- Add before the line `exit 0` the following line:
```bash
su nvidia /path/to/upload_repo/upload_ip.sh
```
NOTE: You may want to create a script that will check if the remote repository is accessible before calling the script in the repo.
- Save the file
- Reboot
