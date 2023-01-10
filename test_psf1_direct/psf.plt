#!/usr/bin/gnuplot

w = 16
h = 16
pixel_scale = 1.0  # arcsec/pxl

c1 = 0.0       # pxl
c2 = 0.0       # pxl

set term x11

set xl "u [pxl]"
set yl "v [pxl]"

#tmp=0.2
#set xr [-tmp:tmp]
#set yr [-tmp:tmp]
set size ratio -1
set xtics 1
set ytics 1
set grid xtics ytics
set tics front

do for [i=-5:5:1] {
  set arrow from first i,graph 0 rto first 0,graph 1 nohead lc 'gray' front
  set arrow from graph 0,first i rto graph 1,first 0 nohead lc 'gray' front
} 

set arrow from first 0,graph 0 rto first 0,graph 1 nohead lc 'green' front
set arrow from graph 0,first 0 rto graph 1,first 0 nohead lc 'green' front

p \
  "<convert psf.pnm png:-" binary filetype=png origin=(-0.5*w+0.5,-0.5*h+0.5) with rgbimage not,\

pa -1

set term png small size 1024,1024
set out "psf.png"
rep

q


