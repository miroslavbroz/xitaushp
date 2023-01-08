#!/usr/bin/gnuplot

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

w=10
h=10

p \
  "input.png" binary filetype=png origin=(-0.5*w+0.5,-0.5*h+0.5) with rgbimage not,\
  "fort.10" u 1:2 w p lc 'green' not,\
  "fort.20" u 1:($2-0.2):(sprintf("%.0f", column(5))) w labels center tc 'brown',\
  "fort.30" u 1:2:(sprintf("%.0f", column(5))) w labels center tc 'blue',\
  "output.silh" u ($1/pixel_scale+c1):($2/pixel_scale+c2) w l lc 'red' lw 3 t "nearest-neighbor",\
  "output.silh_" u ($1/pixel_scale+c1):($2/pixel_scale+c2) w l lc 'green' lw 3 t "multipoint",\

pa -1

set term png small size 1024,1024
set out "output.png"
rep

q


