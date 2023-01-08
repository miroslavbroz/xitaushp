#!/bin/sh

make

./test_silh

gnuplot -geometry 1920x1080 ./output.plt

