#!/bin/bash -e
apt-get update
apt-get install -y build-essential cmake libfftw3-dev libportaudio2 libboost-all-dev
ldconfig
