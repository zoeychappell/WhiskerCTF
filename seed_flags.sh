#!/bin/bash
# Global VARS: 
ctf_flag_1="CAT_HISS_THERE"
ctf_flag_2="CAT_SOCKS_IS"
ctf_flag_3="CAT_YARN_MANY"
ctf_flag_4="CAT_FELINE_KINDS"
ctf_flag_5="CAT_MEOW_OF"
ctf_flag_6="CAT_SIAMESE_CATS"
ctf_flag_7="CAT_CLAWS_BUT"
ctf_flag_8="CAT_FUR_MY"
ctf_flag_9="CAT_TABBY_FAVORITE"
ctf_flag_10="CAT_YOWL_KIND"
ctf_flag_11="CAT_MICE_ARE"
ctf_flag_12="CAT_STRAY_BLACK"
ctf_flag_13="CAT_BIRD_CATS"

# -------------- SETUP --------------
# Check if whiskers exists, and if not, make them
if ! id whiskers &>/dev/null; then
    useradd -m -s /bin/bash whiskers
    echo "whiskers:whisker-cat-mouse" | chpasswd
fi

# create cat_enthusiasts group 
if ! getent group cat_enthusiasts &>/dev/null; then
    groupadd cat_enthusiasts -g 636174
fi
# add whiskers to cat_enthusiasts
usermod -a -G cat_enthusiasts whiskers

# -------------- FLAG 1 --------------
# run the bash command with flag
sudo -u whiskers bash -c "echo $ctf_flag_13 > /dev/null"
sudo -u whiskers bash -c "echo $ctf_flag_13 >> /home/whiskers/.bash_history; history -w"

# -------------- FLAG 2 --------------
# linux pslist/psaux
sudo -u whiskers bash -c "exec -a '$ctf_flag_2' sleep 3600" &

# -------------- FLAG 3 --------------
sudo -u whiskers bash -c "exec -a '$ctf_flag_3' env YARN_FLAG='CAT_YARN_SCREEN' python3 - <<'PY' &
import time, os
# keep the process alive so its env and name are present in memory
time.sleep(300)
PY"
# -------------- FLAG 4 --------------
# linux.ip
# Note: Root creates the dummy interface, not whiskers
if [ ! -f /etc/sudoers.d/whiskers-ip ]; then
    # whiskers, on all hosts, as root, with no password, can run ip commands
    echo "whiskers ALL=(root) NOPASSWD: /usr/sbin/ip" > /etc/sudoers.d/whiskers-ip
    chmod 440 /etc/sudoers.d/whiskers-ip
fi

sudo ip link add catnip0 type dummy
sudo ip link set catnip0 up

#ip link add catnip0 type dummy
#ip link set catnip0 up
echo $ctf_flag_4 | sudo tee /sys/class/net/catnip0/ifalias > /dev/null

# -------------- FLAG 5 --------------
if [ ! -f /etc/sudoers.d/whiskers-echo ]; then
    # whiskers, on all hosts, as root, with no password
    echo "whiskers ALL=(root) NOPASSWD: /bin/echo" > /etc/sudoers.d/whiskers-echo
    chmod 440 /etc/sudoers.d/whiskers-echo
fi

# CHANGED: corrected command so it actually invokes echo as whiskers
sudo -u whiskers bash -c "echo $ctf_flag_5" | sudo tee /dev/kmsg >/dev/null



# -------------- FLAG 6 --------------
# create the sudoers drop-in, secure it, and verify ownership/mode
cat > /etc/sudoers.d/whiskers-grub <<'EOF'
whiskers ALL=(root) NOPASSWD: /usr/bin/tee
EOF
chmod 440 /etc/sudoers.d/whiskers-grub
chown root:root /etc/sudoers.d/whiskers-grub

# quick test (returns 0 on success)
sudo -u whiskers sudo -n /usr/bin/tee -a /etc/default/grub <<< "GRUB_TEST_ENTRY" >/dev/null 2>&1

# -------------- FLAG 7 --------------
sudo -u whiskers bash -c "echo $ctf_flag_7 > /tmp/CAT_CLAWS_PUMPKIN.txt"
sudo -u whiskers tail -f /tmp/CAT_CLAWS_PUMPKIN.txt &
sudo -u whiskers bash -c "exec -a CAT_CLAWS bash -c 'exec 3> /tmp/CAT-CLAWS-TEAR.txt; echo CAT-CLAWS-TEAR >&3; sleep 300'" &

# -------------- FLAG 8 --------------
if [ ! -f /tmp/libwhisker.so ]; then
    ln -s /lib/x86_64-linux-gnu/libc.so.6 /tmp/libwhisker.so 2>/dev/null \
    || ln -s $(ldconfig -p | awk '/libc\.so/ {print $NF; exit}') /tmp/libwhisker.so
    chown whiskers:whiskers /tmp/libwhisker.so 2>/dev/null || true
fi

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
if [ ! -f /etc/sudoers.d/whiskers-mount ]; then
    echo "whiskers ALL=(root) NOPASSWD: /bin/mkdir, /bin/mount" > /etc/sudoers.d/whiskers-mount
    chmod 440 /etc/sudoers.d/whiskers-mount
fi

sudo -u whiskers mkdir -p "/mnt/$ctf_flag_12"
sudo -u whiskers mount -t tmpfs -o size=10m tmpfs "/mnt/$ctf_flag_12"


# -------------- FLAG 13 --------------
# run the bash command with flag
sudo -u whiskers bash -c "echo $ctf_flag_13 > /dev/null"
sudo -u whiskers bash -c "echo $ctf_flag_13 >> /home/whiskers/.bash_history"
sudo -u whiskers history -w
