#!/bin/bash
# Global VARS: 
ctf_flag_1="CAT_HISS_HOME"
ctf_flag_2="CAT_SOCKS_SILLY"
#ctf_flag_3 = "CAT_YARN_SCREEN"
ctf_flag_4="CAT_FELINE_GLASSES"
ctf_flag_5="CAT_MEOW_CAMERA"
ctf_flag_6="CAT_SIAMESE_ELEPHANT"
ctf_flag_7="CAT_CLAWS_PUMPKIN"
ctf_flag_8="CAT_FUR_RUG"
ctf_flag_9="CAT_TABBY_SHAPE"
ctf_flag_10="CAT_YOWL_DRAGON"
ctf_flag_11="CAT_MICE_HIPPO"
ctf_flag_12="CAT_STRAY_PENCIL"
ctf_flag_13="CAT_BIRD_PHONE"

# -------------- SETUP --------------
# create Whiskers user
useradd -m -s /bin/bash whiskers
echo "whiskers:whisker-cat-mouse" | chpasswd
# create cat_enthusiasts group 
groupadd cat_enthusiasts -g 636174
# add whiskers to cat_enthusiasts
usermod -a -G cat_enthusiasts whiskers

# -------------- FLAG 1 --------------
# run the bash command with flag
sudo -u whiskers echo $ctf_flag_13 > /dev/null
sudo -u whiskers echo $ctf_flag_13 >> ~/.bash_history
sudo -u whiskers bash -c "history -w"

# -------------- FLAG 2 --------------
# linux pslist/psaux
sudo -u whiskers bash -c "exec -a $ctf_flag_2 sleep 3600" &
sudo -u whiskers echo $!

# -------------- FLAG 3 --------------

# -------------- FLAG 4 --------------
# linux.ip
# Note: Root creates the dummy interface, not whiskers
echo "whiskers ALL=(root) NOPASSWD: /usr/sbin/ip" > /etc/sudoers.d/whiskers-ip
chmod 440 /etc/sudoers.d/whiskers-ip

sudo ip link add catnip0 type dummy
sudo ip link set catnip0 up

#ip link add catnip0 type dummy
#ip link set catnip0 up
echo $ctf_flag_4 | sudo tee /sys/class/net/catnip0/ifalias > /dev/null

# -------------- FLAG 5 --------------
echo "whiskers ALL=(root) NOPASSWD: /bin/echo" > /etc/sudoers.d/whiskers-echo
chmod 440 /etc/sudoers.d/whiskers-echo

sudo -u whiskers echo $ctf_flag_5 | tee /dev/kmsg

# -------------- FLAG 6 --------------
whiskers ALL=(root) NOPASSWD: echo $ctf_flag_6 >> /etc/default/grub

# -------------- FLAG 7 --------------
sudo -u whiskers echo $ctf_flag_7 > /tmp/CAT_CLAWS_PUMPKIN.txt
sudo -u whiskers tail -f /tmp/CAT_CLAWS_PUMPKIN.txt &
sudo -u whiskers bash -c "exec -a CAT_CLAWS exec 3> /tmp/CAT-CLAWS-TEAR.txt; echo 'CAT-CLAWS-TEAR' >&3; sleep 300" &

# -------------- FLAG 8 --------------
sudo -u whiskers python3 - << 'PY' &
import ctypes
import time

# load the shared library
lib = ctypes.CDLL("/tmp/libwhisker.so")

# keep the process alive so volatility can see the mapping
time.sleep(300)
PY

# -------------- FLAG 9 --------------
sudo -u whiskers python3 -c 'import time, sys; time.sleep(300)' $ctf_flag_9 &

# -------------- FLAG 10 --------------
sudo -u whiskers bash -c "export kitty_clue='$ctf_flag_10'; sleep 1"

# -------------- FLAG 11 --------------
echo $ctf_flag_11 > /tmp/flagmaps.txt

python3 - << 'PY'
import mmap
import os
import time

path = "/tmp/flagmaps.txt"
fd = os.open(path, os.O_RDONLY)

# Memory‑map the file
mm = mmap.mmap(fd, 0, mmap.MAP_SHARED, mmap.PROT_READ)

# Keep the mapping alive for forensics (adjust duration as needed)
time.sleep(300)
PY

rm /tmp/flagmaps.txt

# -------------- FLAG 12 --------------
whiskers ALL=(root) NOPASSWD: mkdir -p /mnt/$ctf_flag_12
whiskers ALL=(root) NOPASSWD: mount -t tmpfs -o size=10m tmpfs /mnt/$ctf_flag_12 

# -------------- FLAG 13 --------------
# run the bash command with flag
sudo -u whiskers echo $ctf_flag_13 > /dev/null
sudo -u whiskers echo $ctf_flag_13 >> ~/.bash_history
sudo -u whiskers history -w
