#!/bin/sh

make || exit

./test_psf

#pqiv -z 3 *.pnm

#gnuplot -geometry 1920x1080 ./psf.plt

