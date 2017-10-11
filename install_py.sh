#!/bin/bash

wget  https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install cymysql

yum install m2crypto -y
pip install M2Crypto
