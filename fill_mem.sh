#!/bin/bash

# This script creates legitimate activity for the purpose of hiding
# the flags in real memory.

# The purpose is to show a more accurate forensics case investigation.

# Run the script before runing seed_flags
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
	"ls"
	"lsblk"
	"pwd"
	"ps"
	"free"
	"vmstat"
	"lsof"
	"ip"
	"netstat"
	"clear"
	"mkdir .hidden"
	"ping -c 4  google.com"
)

# Execute random commands
for i in {1..50}
do
	CMD=${LIST_OF_CMDs[$RANDOM % ${#LIST_OF_CMDs[@]} ]}
	# Execute the command
	bash -c "$CMD"
	# Pause a random amount of time
	sleep $((RANDOM % 4))
done

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
do
	# Create a bunch of files with just numbers as names
	touch $RANDOM
done

# Create some random directories
mkdir .hidden
mkdir ..hidden
mkdir ...hidden
mkdir .....hidden
mkdir .malware_db

# Create random directories with numbers as names
for k in {1..30}
do
	mkdir $RANDOM
done

# Generate fake network traffic
for j in {1..20}
do
	curl -s https://icanhazip.com >/dev/null
	curl -s https://google.com >/dev/null
	sleep $((RANDOM % 4))
done

# Browser artifacts
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
do
	ssh user@127.0.0.1 -p 22 "test" >/dev/null
done

