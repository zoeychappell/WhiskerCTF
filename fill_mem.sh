#/bin/bash

# This script creates legitimate activity for the purpose of hiding 
# the flags in real memory. 

# The purpose is to show a more accurate forensics case investigation. 

# Run the script two times, once at the beginning (before seed_flags)
# and once after.
sudo apt install curl

LIST_OF_CMDs=(
    "uname -r"
    "uname -a"
    "timedatectl"
    "hostname"
    "finger"
    "whoami"
    "date"
    "cd"
    "dmesg"
    "ls"
    "lsblk"
    "pwd"
    "ps"
    "free"
    "vmstat"
    "lsof"
    "journalctl"
    "ip"
    "netstat"
    "clear"
    "mkdir .hidden"
    "ping google.com"

)
# Execute random commands
for i in {1..50}:
    CMD=${LIST_OF_CMDs[$RANDOM % ${#CMDS[@]} ]}
    # Execute the command
    bash -c "$CMD" 
    # pause a random amount of time
    sleep $((RANDOM % 4))

# Create some random weird scripts
touch not_suspicious.py
touch grab_secret_keys.sh
touch break_encryption.py
touch phone_home.sh
touch steal_secrets.sh
touch download_malware.py
touch malware.py
touch malware234.py

for h in {1..30}
    # create a bunch of files with just numbers as name
    touch $RANDOM 

# Create some random directories
mkdir .hidden
mkdir ..hidden
mkdir ...hidden
mkdir .....hidden
mkdir .malware_db
# Create random directories with numbers as name
for k in {1..30}
    mkdir $RANDOM

# Generate fake network traffic
for j in {1..20}
    curl -s https://icanhazip.com >/dev/null
    curl -s https://google.com >/dev/null
    sleep $((RANDOM % 4))

# Browser artifcats
sudo apt install firefox -y
firefox https://cnn.com &
firefox https://google.com &
firefox https://github.com &
firefox https://reddit.com &
firefox https://instagram.com &
firefox https://facebook.com &
firefox https://twitter.com &
firefox https://icanhazip.com &

# Failed SSH attempts
for i in {1..40}
    ssh user@127.0.0.1 -p 22 "test" >/dev/null
    