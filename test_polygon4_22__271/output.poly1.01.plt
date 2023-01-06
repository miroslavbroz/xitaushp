#!/usr/bin/gnuplot

au = 1.49597870700e11
deg = pi/180.
arcsec = deg/3600.
mas = 1.e-3*arcsec

set term x11
load "output.gnu"

set xl "x"
set yl "y"
set zl "z"
set cbl "-"

tmp=1.5e5
set xr [-tmp:tmp]
set yr [-tmp:tmp]
set zr [-tmp:tmp]
set cbr [0:]

set view 0,0,2.0
set view equal xyz
set xyplane 0.0
set palette gray

sp \
  "<./poly.awk output.poly1.01"  u 4:5:6 w l not,\
  "<./minus.awk output.surf1.01 output.poly1.01 | ./poly.awk" u 4:5:6 w l lw 3 lc 'black',\

pa -1

q

