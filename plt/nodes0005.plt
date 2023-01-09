#!/usr/bin/gnuplot

pixel_scale = 3.6e-3  # arcsec/pxl
w = 256
h = 256

c1 = -1.4370458808926612       
c2 = 0.98767099218198995
c1 = c1 + -9.6248582164033586E-004
c2 = c2 + 7.4757285401364460E-003
c1 = c1 + 0.5
c2 = c2 - 0.5

set xl "u [pxl]"
set yl "v [pxl]"

tmp=0.1
set xr [-tmp:tmp]
set yr [-tmp:tmp]
set size ratio -1
set zeroaxis

do for [i=-1:1:1] {
  set arrow from first i*pixel_scale,graph 0 rto first 0,graph 1 nohead lc 'green' front
  set arrow from graph 0,first i*pixel_scale rto graph 1,first 0 nohead lc 'green' front
}

p \
  "21_SRobj.png" binary filetype=png origin=((-0.5*w+0.5-c1)*pixel_scale,(-0.5*h+0.5-c2)*pixel_scale) dx=pixel_scale dy=pixel_scale with rgbimage,\
  "nodes0005.silh"                        u 1:2 w l lc 'orange',\
  "nodes0005.silh_"                       u 1:2 w l lc 'blue',\
  "<awk '($6==21) || (NF==0)' chi2_AO.dat" u 2:3 w l lc 'red',\
  "<awk '{ print 0,0; print $0; print s; }' nodes0005.silh_" u 1:2 w l lc 'gray',\

pa -1

set term png small size 1024,1024
set out "nodes0005.png"
rep

q



