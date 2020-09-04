# [Server] rttys-for-arm64
rttys-for-arm64 on docker

Use:
```bash
docker run -d \
   --name rttys \
   -p 5912:5912 \
   -p 5913:5913 \
   -v ~/.config/rttys.conf:/etc/rttys/rttys.conf \
   -v /etc/rttys/rttys.crt:/etc/rttys/rttys.crt \
   -v /etc/rttys/rttys.key:/etc/rttys/rttys.key \
   --restart=always \
   dennischancs/rttys
```

`rttys.conf` below: 
```conf
#addr-dev: :5912
#addr-user: :5913

# Auth for http
http-username: rttys
http-password: rttys

#ssl-cert: /etc/rttys/rttys.crt
#ssl-key: /etc/rttys/rttys.key

#base-url: /

#token: a1d4cdb1a3cd6a0e94aa3599afcddcf5

# font-size: 16

# No login required to connect device.
# Values can be device IDs separated by spaces,
# or a "*" indicates that all devices do not require login
# http://localhost:5913/connect/rtty1
#white-list: "*"
#white-list: rtty1 rtty2
```

More details: [zhaojh329/rttys](https://github.com/zhaojh329/rttys/issues)

# [client] rtty for arm64

[zhaojh329/rtty: Access your terminal from anywhere via the web.](https://github.com/zhaojh329/rtty)

**client start:**

```bash
sudo rtty \
   -I 'My-device-ID' \ # client
   -h 'your-server' \ # server ip or domain
   -p 5912 \ # server port [add device]
   -t server_token \ # optional server token
   -a \
   -v \
   -d 'My Device Description' # optional
```

**service manage:**
1. via http://your-server-host:5913 and login

2. click the Connection button to use the web shell like SSH

3. Transfer files is easy:

    - `rtty -R` : Transfer file from local to remote device
    - `rtty -S test.txt` : Transfer file from remote device to the local


**client start on boot:**
run the shell on every device 

```bash
cd /etc/systemd/system # your_systemd_path

cat > rtty.service <<EOF
[Unit]
Description=rtty
After=network.target

[Service]
User=root
ExecStart=/opt/bin/rtty \
              -I 'My-device-ID' \
              -h 'server_ip' \
              -p 5912 \
              -d 'description' \
              -a -v \
              -t 'server_token' # [optional] it may cause `register fail: Invalid token` bug
TimeoutStopSec=5s
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable rtty
sudo systemctl start rtty

# optional
#sudo systemctl status rtty # status
#sudo systemctl stop rtty # stop
```


## Build libev

    git clone https://github.com/enki/libev.git
    cd libev
    ./configure --host=arm-linux-gnueabi
    DESTDIR=/tmp/rtty_install make install

## Build rtty

    git clone --recursive https://github.com/zhaojh329/rtty.git
    cd rtty
    cmake . -DCMAKE_C_COMPILER=/opt/bin/gcc -DCMAKE_FIND_ROOT_PATH=/tmp/rtty_install
    DESTDIR=/tmp/rtty_install make install

## Copy these files to your device's corresponding directory

    /tmp/rtty_install/
     └── usr/
        └── local
            ├── bin
            │   └── rtty
            ├── include
            │   ├── event.h
            │   ├── ev.h
            │   └── ev++.h
            ├── lib
            │   ├── libev.a
            │   ├── libev.la
            │   ├── libev.so -> libev.so.4.0.0
            │   ├── libev.so.4 -> libev.so.4.0.0
            │   └── libev.so.4.0.0
            └── share
                └── man
                    └── man3
                        └── ev.3


[rtty/CROSS_COMPILE.md at master · zhaojh329/rtty](https://github.com/zhaojh329/rtty/blob/master/CROSS_COMPILE.md)