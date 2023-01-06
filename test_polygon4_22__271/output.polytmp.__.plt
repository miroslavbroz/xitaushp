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

tmp=150000
set xr [-tmp:tmp]
set yr [-tmp:tmp]
set yr [-tmp:tmp]
set cbr [0:]

set view 0,0,1
set view equal xyz
set xyplane 0.0
set palette gray

scl=1
set arrow from scl*(0+0.00),0,0 to scl*(s1__+0.00),scl*s2__,scl*s3__ front lc 'orange'
set arrow from scl*(0+0.01),0,0 to scl*(o1__+0.01),scl*o2__,scl*o3__ front lc 'blue'

scl=arcsec*2.13832494981512*au

sp \
  "<./poly.awk output.poly1.01"  u 4:5:6 w l lw 5,\
  "<./poly.awk output.poly2.01"  u 4:5:6 w l lw 4,\
  "<./poly.awk output.poly3.01"  u 4:5:6 w l lw 3,\
  "<./poly.awk output.poly4.01"  u 4:5:6 w l lw 2,\
  "<./poly.awk output.poly5.01"  u 4:5:6 w l lw 1,\
  "<./poly.awk output.polytmp.01" u 4:5:6 w l lw 1 lc 'gray',\

pa -1

q


