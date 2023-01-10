#!/bin/sh

make || exit

./test_fft > test_fft.out
less test_fft.out

#pqiv -z 3 *.pnm

#gnuplot -geometry 1920x1080 ./psf.plt

