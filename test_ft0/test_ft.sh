#!/bin/sh

make || exit

./test_ft > test_ft.out; less test_ft.out

#pqiv -t *.pnm

#gnuplot -geometry 1920x1080 ./psf.plt

