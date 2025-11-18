#!/bin/bash

###############################################
#   CAT CTF — Forensics Artifact Generator    #
#   Long-Term Artifacts + Auto LiME Dump      #
###############################################

# ---------------- GLOBAL FLAGS ----------------
ctf_flag_1="CAT_BIRD_THERE"
ctf_flag_2="CAT_CLAWS_ARE"
ctf_flag_3="CAT_HISS_MANY"
ctf_flag_4="CAT_FELINE_KINDS"
ctf_flag_5="CAT_MEOW_OF"
ctf_flag_6="CAT_MICE_CATS"
ctf_flag_7="CAT_PAW_BUT"
ctf_flag_8="CAT_SIAMESE_MY"
ctf_flag_9="CAT_SOCKS_FAVORITE"
ctf_flag_10="CAT_STRAY_KIND"
ctf_flag_11="CAT_TABBY_ARE"
ctf_flag_12="CAT_YARN_BLACK"
ctf_flag_13="CAT_YOWL_CATS"

# ---------------- USER SETUP ----------------
if ! id whiskers &>/dev/null; then
    useradd -m -s /bin/bash whiskers
    echo "whiskers:whisker-cat-mouse" | chpasswd
fi

if ! getent group cat_enthusiasts &>/dev/null; then
    groupadd cat_enthusiasts -g 636174
fi

usermod -a -G cat_enthusiasts whiskers

# ---------------- FLAG 1 ----------------
sudo -u whiskers bash -c "echo $ctf_flag_13 >> /home/whiskers/.bash_history; history -w"

# ---------------- FLAG 2 ----------------
sudo -u whiskers bash -c "exec -a '$ctf_flag_2' sleep 99999999" &

# ---------------- FLAG 3 ----------------
sudo -u whiskers bash -c "exec -a '$ctf_flag_3' env YARN_FLAG='CAT_YARN_SCREEN' python3 -" <<'PY' &
import time
while True:
    time.sleep(60)
PY

# ---------------- FLAG 4 ----------------
if [ ! -f /etc/sudoers.d/whiskers-ip ]; then
    echo "whiskers ALL=(root) NOPASSWD: /usr/sbin/ip" > /etc/sudoers.d/whiskers-ip
    chmod 440 /etc/sudoers.d/whiskers-ip
fi

sudo ip link add catnip0 type dummy 2>/dev/null || true
sudo ip link set catnip0 up
echo $ctf_flag_4 | sudo tee /sys/class/net/catnip0/ifalias >/dev/null

# ---------------- FLAG 5 ----------------
if [ ! -f /etc/sudoers.d/whiskers-echo ]; then
    echo "whiskers ALL=(root) NOPASSWD: /bin/echo" > /etc/sudoers.d/whiskers-echo
    chmod 440 /etc/sudoers.d/whiskers-echo
fi

sudo -u whiskers bash -c "echo $ctf_flag_5" | sudo tee /dev/kmsg >/dev/null

# ---------------- FLAG 6 ----------------
cat > /etc/sudoers.d/whiskers-grub <<'EOF'
whiskers ALL=(root) NOPASSWD: /usr/bin/tee
EOF
chmod 440 /etc/sudoers.d/whiskers-grub
chown root:root /etc/sudoers.d/whiskers-grub

sudo -u whiskers sudo -n /usr/bin/tee -a /etc/default/grub <<< "GRUB_TEST_ENTRY" >/dev/null 2>&1

# ---------------- FLAG 7 ----------------
sudo -u whiskers bash -c "echo $ctf_flag_7 > /tmp/CAT_CLAWS_PUMPKIN.txt"
# long-term tail for open FD evidence
sudo -u whiskers tail -f /tmp/CAT_CLAWS_PUMPKIN.txt &
sudo -u whiskers bash -c "exec -a CAT_CLAWS bash -c 'exec 3> /tmp/CAT-CLAWS-TEAR.txt; echo CAT-CLAWS-TEAR >&3; sleep infinity'" &

# ---------------- FLAG 8 ----------------
if [ ! -f /tmp/libwhisker.so ]; then
    ln -s /lib/x86_64-linux-gnu/libc.so.6 /tmp/libwhisker.so 2>/dev/null \
    || ln -s $(ldconfig -p | awk '/libc\.so/ {print $NF; exit}') /tmp/libwhisker.so
    chown whiskers:whiskers /tmp/libwhisker.so 2>/dev/null || true
fi

sudo -u whiskers bash -c "exec -a LIBMAP_$ctf_flag_8 python3 -" <<'PY' &
import ctypes, time
ctypes.CDLL('/tmp/libwhisker.so')
while True:
    time.sleep(30)
PY

# ---------------- FLAG 9 ----------------
sudo -u whiskers python3 -- -c 'import time; 
while True: time.sleep(60)' -- "$ctf_flag_9" &

# ---------------- FLAG 10 ----------------
sudo -u whiskers bash -c "export kitty_clue='$ctf_flag_10'; sleep infinity" &

# ---------------- FLAG 11 ----------------
echo $ctf_flag_11 > /tmp/flagmaps.txt

python3 << 'PY' &
import mmap, os, time

fd = os.open("/tmp/flagmaps.txt", os.O_RDONLY)
mm = mmap.mmap(fd, 0, mmap.MAP_SHARED, mmap.PROT_READ)

while True:
    time.sleep(60)
PY

rm /tmp/flagmaps.txt

# ---------------- FLAG 12 ----------------
if [ ! -f /etc/sudoers.d/whiskers-mount ]; then
    echo "whiskers ALL=(root) NOPASSWD: /bin/mkdir, /bin/mount" > /etc/sudoers.d/whiskers-mount
    chmod 440 /etc/sudoers.d/whiskers-mount
fi

sudo -u whiskers mkdir -p "/mnt/$ctf_flag_12"
sudo -u whiskers sudo mount -t tmpfs -o size=10m tmpfs "/mnt/$ctf_flag_12"

# ---------------- FLAG 13 ----------------
sudo -u whiskers bash -c "echo $ctf_flag_13 >> /home/whiskers/.bash_history"
sudo -u whiskers history -w

###############################################
#           LiME MEMORY DUMP START            #
###############################################
echo "[+] Starting LiME memory acquisition..."

LIME_OUTPUT="/tmp/memdump.lime"

if ! command -v make &>/dev/null; then
    apt-get update -y
    apt-get install -y build-essential linux-headers-$(uname -r) git
fi

if [ ! -d /opt/lime ]; then
    git clone https://github.com/504ensicsLabs/LiME.git /opt/lime
fi

make -C /lib/modules/$(uname -r)/build M=/opt/lime/src modules

if [ ! -f /opt/lime/src/lime.ko ]; then
    echo "[!] LiME failed to build."
    exit 1
fi

insmod /opt/lime/src/lime.ko "path=${LIME_OUTPUT}" "format=lime"

echo "[+] LiME is now dumping memory to: $LIME_OUTPUT"
echo "[+] All forensic artifacts remain running indefinitely."
