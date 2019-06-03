#!/bin/bash
python get-pip.py
pip install cymysql
cd /home/wwwroot/shadowsocks/shadowsocks
nohup python server.py &
