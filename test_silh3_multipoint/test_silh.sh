#!/bin/sh

make || exit

./test_silh

gnuplot -geometry 1920x1080 ./output.plt

