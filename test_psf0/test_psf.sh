#!/bin/sh

make || exit

./test_psf

pqiv -t *.pnm

gnuplot -geometry 1920x1080 ./psf.plt

