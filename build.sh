#!/bin/bash
#
export CROSS_COMPILE=/opt/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
make clean
bear make -j2
